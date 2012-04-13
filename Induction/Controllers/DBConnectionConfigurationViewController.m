//
//  DBConnectionConfigurationViewController.m
//  Kirin
//
//  Created by Mattt Thompson on 12/01/26.
//  Copyright (c) 2012年 Heroku. All rights reserved.
//

#import "DBConnectionConfigurationViewController.h"

static NSString * const kInductionPreviousConnectionURLKey = @"com.induction.connection.previous.url";

static NSString * DBURLStringFromComponents(NSString *scheme, NSString *host, NSString *user, NSString *password, NSNumber *port, NSString *database) {
    NSMutableString *mutableURLString = [NSMutableString stringWithFormat:@"%@://", scheme];
    if (user && [user length] > 0) {
        [mutableURLString appendFormat:@"%@", user];
        if (password && [password length] > 0) {
            [mutableURLString appendFormat:@":%@", password];
        }
        [mutableURLString appendString:@"@"];
    }
    
    if (host && [host length] > 0) {
        [mutableURLString appendString:host];
    }
    
    if (port && [port integerValue] > 0) {
        [mutableURLString appendFormat:@":%d", [port integerValue]];
    }
    
    if (database && [database length] > 0 && [host length] > 0) {
        [mutableURLString appendFormat:@"/%@", [database stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]]];
    }
    
    return [NSString stringWithString:mutableURLString];
}

#pragma mark -

@interface DBDatabaseParameterFormatter : NSFormatter
@end

@implementation DBDatabaseParameterFormatter

- (NSString *)stringForObjectValue:(id)obj {
    if (![obj isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    return [obj stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
}

- (BOOL)getObjectValue:(__autoreleasing id *)obj forString:(NSString *)string errorDescription:(NSString *__autoreleasing *)error {
    if(obj) {
        *obj = string;
    }
    
    return YES;
}

- (BOOL)isPartialStringValid:(NSString *)partialString newEditingString:(NSString *__autoreleasing *)newString errorDescription:(NSString *__autoreleasing *)error {
    static NSCharacterSet *_illegalDatabaseParameterCharacterSet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _illegalDatabaseParameterCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" ,:;@!#$%&^'()[]{}\"\\/|"];
    });
    
    return [partialString rangeOfCharacterFromSet:_illegalDatabaseParameterCharacterSet].location == NSNotFound;
}

@end

#pragma mark -

@interface DBRemovePasswordURLValueTransformer : NSValueTransformer
@end

@implementation DBRemovePasswordURLValueTransformer

+ (Class)transformedValueClass {
    return [NSURL class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}

- (id)transformedValue:(id)value {
    if (!value) {
        return nil;
    }
    
    NSURL *url = (NSURL *)value;
    
    return [NSURL URLWithString:DBURLStringFromComponents([url scheme], [url host], [url user], nil, [url port], [url path])];
}

@end

#pragma mark -

@interface DBConnectionConfigurationViewController ()
@property (readwrite, nonatomic, getter = isConnecting) BOOL connecting;

- (void)bindURLParameterTextField:(NSTextField *)textField;
@end

@implementation DBConnectionConfigurationViewController
@synthesize delegate = _delegate;
@synthesize connectionURL = _connectionURL;
@synthesize connecting = _connecting;
@dynamic isConnecting;
@synthesize URLField = _URLField;
@synthesize schemePopupButton = _schemePopupButton;
@synthesize hostnameField = _hostnameField;
@synthesize usernameField = _usernameField;
@synthesize passwordField = _passwordField;
@synthesize portField = _portField;
@synthesize databaseField = _databaseField;
@synthesize connectButton = _connectButton;
@synthesize connectionProgressIndicator = _connectionProgressIndicator;

- (void)awakeFromNib {
    for (NSTextField *field in [NSArray arrayWithObjects:self.URLField, self.schemePopupButton, self.hostnameField, self.usernameField, self.passwordField, self.portField, self.databaseField, nil]) {
        [self bindURLParameterTextField:field];
    }
    
    for (NSString *path in [[NSBundle mainBundle] pathsForResourcesOfType:@"bundle" inDirectory:@"../PlugIns/Adapters"]) {
        NSBundle *bundle = [NSBundle bundleWithPath:path];
        [bundle loadAndReturnError:nil];
        
        if ([[bundle principalClass] conformsToProtocol:@protocol(DBAdapter)]) {
            [self.schemePopupButton addItemWithTitle:[[bundle principalClass] primaryURLScheme]];
        }
    }
    
    self.hostnameField.formatter = [[DBDatabaseParameterFormatter alloc] init];
    self.usernameField.formatter = [[DBDatabaseParameterFormatter alloc] init];
    self.databaseField.formatter = [[DBDatabaseParameterFormatter alloc] init];
    
    // TODO Check against registered adapters to detect appropriate URL on pasteboard
    NSURL *pasteboardURL = [NSURL URLWithString:[[NSPasteboard generalPasteboard] stringForType:NSPasteboardTypeString]];
    if (pasteboardURL && ![[pasteboardURL scheme] hasPrefix:@"http"]) {
        self.connectionURL = pasteboardURL;
    } else {
        self.connectionURL = [[NSUserDefaults standardUserDefaults] URLForKey:kInductionPreviousConnectionURLKey];
    }
    
    [self.URLField becomeFirstResponder];
}

- (void)bindURLParameterTextField:(NSTextField *)textField {
    if ([textField isEqual:self.URLField]) {
        [textField bind:@"objectValue" toObject:self withKeyPath:@"connectionURL" options:[NSDictionary dictionaryWithObject:NSStringFromClass([DBRemovePasswordURLValueTransformer class]) forKey:NSValueTransformerNameBindingOption]];
    } else if ([textField isEqual:self.schemePopupButton]) {
        [textField bind:@"selectedObject" toObject:self withKeyPath:@"connectionURL.scheme" options:nil];
    } else if ([textField isEqual:self.hostnameField]) {
        [textField bind:@"objectValue" toObject:self withKeyPath:@"connectionURL.host" options:nil];
    } else if ([textField isEqual:self.usernameField]) {
        [textField bind:@"objectValue" toObject:self withKeyPath:@"connectionURL.user" options:nil];
    } else if ([textField isEqual:self.passwordField]) {
        [textField bind:@"objectValue" toObject:self withKeyPath:@"connectionURL.password" options:nil];
    } else if ([textField isEqual:self.portField]) {
        [textField bind:@"objectValue" toObject:self withKeyPath:@"connectionURL.port" options:nil];
    } else if ([textField isEqual:self.databaseField]) {
        [textField bind:@"objectValue" toObject:self withKeyPath:@"connectionURL.path" options:nil];
    }
}

#pragma mark - IBAction

- (void)connect:(id)sender {    
    NSLog(@"URL: %@", self.connectionURL);
    
    self.connecting = YES;

    for (NSString *path in [[NSBundle mainBundle] pathsForResourcesOfType:@"bundle" inDirectory:@"../PlugIns/Adapters"]) {
        NSBundle *bundle = [NSBundle bundleWithPath:path];
        [bundle loadAndReturnError:nil];
        
        if ([[bundle principalClass] conformsToProtocol:@protocol(DBAdapter)]) {
            id <DBAdapter> adapter = (id <DBAdapter>)[bundle principalClass];
            if ([adapter canConnectToURL:self.connectionURL]) {
                [adapter connectToURL:self.connectionURL success:^(id <DBConnection> connection) {
                    [[NSUserDefaults standardUserDefaults] setURL:self.connectionURL forKey:kInductionPreviousConnectionURLKey];
                    [self.delegate connectionConfigurationControllerDidConnectWithConnection:connection];
                } failure:^(NSError *error){
                    self.connecting = NO;
                    
                    [self presentError:error modalForWindow:self.view.window delegate:nil didPresentSelector:nil contextInfo:nil];
                }];
                
                break;
            }
        }
    }
}

- (void)setConnecting:(BOOL)connecting {
    [self willChangeValueForKey:@"isConnecting"];
    _connecting = connecting;
    [self didChangeValueForKey:@"isConnecting"];
    
    if ([self isConnecting]) {
        [self.connectionProgressIndicator startAnimation:self];
    } else {
        [self.connectionProgressIndicator stopAnimation:self];
    }
}

#pragma mark - NSTextFieldDelegate

- (void)controlTextDidBeginEditing:(NSNotification *)notification {
    NSTextField *textField = [notification object];
    [textField unbind:@"objectValue"];
}

- (void)controlTextDidChange:(NSNotification *)notification {
    NSTextField *textField = [notification object];
    
    if ([textField isEqual:self.URLField]) {
        NSURL *url = [NSURL URLWithString:[self.URLField stringValue]];
        
        NSString *scheme = [url scheme];
        if (!scheme) {
            scheme = [[self.schemePopupButton selectedCell] title];
        }
        
        NSString *password = [url password];
        if (!password) {
            password = [self.passwordField objectValue];
        }
        
        self.connectionURL = [NSURL URLWithString:DBURLStringFromComponents(scheme, [url host], [url user], password, [url port], [url path])];
    } else {
        self.connectionURL = [NSURL URLWithString:DBURLStringFromComponents([[self.schemePopupButton selectedCell] title], [self.hostnameField stringValue], [self.usernameField stringValue], [self.passwordField stringValue], [NSNumber numberWithInteger:[self.portField integerValue]], [self.databaseField stringValue])];
    }
}

- (void)controlTextDidEndEditing:(NSNotification *)notification {
    NSTextField *textField = [notification object];
    
    if ([textField isEqual:self.URLField]) {
        NSURL *url = [NSURL URLWithString:[self.URLField stringValue]];
        self.connectionURL = [NSURL URLWithString:DBURLStringFromComponents([[self.schemePopupButton selectedCell] title], [self.hostnameField stringValue], [self.usernameField stringValue], [self.passwordField stringValue], [NSNumber numberWithInteger:[self.portField integerValue]], [self.databaseField stringValue])];
        
        if ([[url scheme] isEqualToString:@"postgres"]) {
            [[self.portField cell] setPlaceholderString:@"5432"];
        } else if ([[url scheme] isEqualToString:@"mysql"]) {
            [[self.portField cell] setPlaceholderString:@"3306"];
        } else if ([[url scheme] isEqualToString:@"mongodb"]) {
            [[self.portField cell] setPlaceholderString:@"27017"];
        }
    }
    
    [self bindURLParameterTextField:textField];
}


@end
