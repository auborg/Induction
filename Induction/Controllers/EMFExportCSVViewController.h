//
//  EMFExportCSVViewController.h
//  Induction
//
//  Created by Mattt Thompson on 12/04/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EMFExportViewController.h"

@interface EMFExportedField : NSObject
@property (assign, getter = isEnabled) BOOL enabled;
@property (strong) NSString *name;
@property (strong) NSString *displayName;
@end

#pragma mark -

@interface EMFExportCSVViewController : EMFExportViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSPopUpButton *tablesPopUpButton;

@property (weak) IBOutlet NSTableView *fieldsTableView;
@property (strong) IBOutlet NSArrayController *fieldsArrayController;
@property (weak) IBOutlet NSBox *optionsBoxView;
@property (weak) IBOutlet NSButton *optionShowHeadersCheckBoxButton;
@property (weak) IBOutlet NSComboBox *optionDelimiterComboBox;
@property (weak) IBOutlet NSComboBox *optionEnclosingStringComboBox;
@property (weak) IBOutlet NSComboBox *optionNULLRepresentationComboBox;

- (IBAction)cancel:(id)sender;

@end
