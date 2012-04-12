//
//  EMFExportCSVViewController.m
//  Induction
//
//  Created by Mattt Thompson on 12/04/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EMFExportCSVViewController.h"
#import "DBAdapter.h"
#import "EMFResultSetSerializer.h"

@interface EMFExportedField ()
- (id)initWithName:(NSString *)name;
@end

@implementation EMFExportedField
@synthesize enabled = _enabled;
@synthesize name = _name;
@synthesize displayName = _displayName;

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _enabled = YES;
    _name = name;
    _displayName = name;
    
    return self;
}

@end

#pragma mark -

@implementation EMFExportCSVViewController
@synthesize tablesPopUpButton;
@synthesize fieldsTableView;
@synthesize fieldsArrayController;
@synthesize optionsBoxView;
@synthesize optionShowHeadersCheckBoxButton;
@synthesize optionDelimiterComboBox;
@synthesize optionEnclosingStringComboBox;
@synthesize optionNULLRepresentationComboBox;

- (void)awakeFromNib {
    [self.delegate.dataSource fetchResultSetForRecordsAtIndexes:[NSIndexSet indexSetWithIndex:0] success:^(id<DBResultSet> resultSet) {
        NSMutableArray *mutableFields = [NSMutableArray arrayWithCapacity:[resultSet numberOfFields]];
        [[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [resultSet numberOfFields])] enumerateIndexesUsingBlock:^(NSUInteger fieldIndex, BOOL *stop) {
            EMFExportedField *field = [[EMFExportedField alloc] initWithName:[resultSet identifierForTableColumnAtIndex:fieldIndex]];
            [mutableFields addObject:field];
        }];
        
        self.representedObject = mutableFields;
        
    } failure:^(NSError *error) {
        [self.delegate exportViewController:self didFailWithError:error];
    }];
}

#pragma mark - IBAction

- (IBAction)cancel:(id)sender {
    [self.delegate exportViewControllerDidCancel:self];
}

- (IBAction)save:(id)sender {
    NSSavePanel *savePanel = [NSSavePanel savePanel];    
    [savePanel beginSheetModalForWindow:self.view.window completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSURL *fileURL = [savePanel URL];
            NSIndexSet *resultIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.delegate.dataSource numberOfRecords])];
            [self.delegate.dataSource fetchResultSetForRecordsAtIndexes:resultIndexSet success:^(id<DBResultSet> resultSet) {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
                    NSString *CSV = [EMFResultSetSerializer tabulatedStringFromResultSet:resultSet fromRecordsAtIndexes:resultIndexSet withFields:[[self.fieldsArrayController.arrangedObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"enabled == YES"]] valueForKeyPath:@"name"] showHeaders:(self.optionShowHeadersCheckBoxButton.state == NSOnState) delimiter:[self.optionDelimiterComboBox stringValue] enclosingString:[self.optionEnclosingStringComboBox stringValue] NULLToken:[self.optionNULLRepresentationComboBox stringValue] stringEncoding:NSUTF8StringEncoding];
                    
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        [CSV writeToURL:[savePanel URL] atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    });
                });
                
            } failure:^(NSError *error) {
                [self.delegate exportViewController:self didFailWithError:error];
            }];
            
            [self.delegate exportViewController:self didSaveFileWithURL:fileURL];
        }
    }];
}

@end
