//
//  DBConnectionConfigurationViewController.h
//  Kirin
//
//  Created by Mattt Thompson on 12/01/26.
//  Copyright (c) 2012年 Heroku. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DBAdapter.h"

@class EMFConnectionConfigurationViewController;
@class EMFDatabaseParameterFormatter;

@protocol EMFConnectionConfigurationViewControllerProtocol <NSObject>
@required
- (void)connectionConfigurationControllerDidConnectWithConnection:(id <DBConnection>)connection;
@end

@interface EMFConnectionConfigurationViewController : NSViewController <NSTextFieldDelegate>

@property (strong) id <EMFConnectionConfigurationViewControllerProtocol> delegate;

@property (strong) NSURL *connectionURL;
@property (readonly) BOOL isConnecting;

@property (weak) IBOutlet NSTextField *URLField;
@property (weak) IBOutlet NSPopUpButton *schemePopupButton;
@property (weak) IBOutlet NSTextField *hostnameField;
@property (weak) IBOutlet NSTextField *usernameField;
@property (weak) IBOutlet NSTextField *passwordField;
@property (weak) IBOutlet NSTextField *portField;
@property (weak) IBOutlet NSTextField *databaseField;
@property (weak) IBOutlet NSButton *connectButton;
@property (weak) IBOutlet NSProgressIndicator *connectionProgressIndicator;

- (IBAction)connect:(id)sender;

@end
