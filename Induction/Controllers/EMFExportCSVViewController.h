//
//  EMFExportCSVViewController.h
//  Induction
//
//  Created by Mattt Thompson on 12/04/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface EMFExportCSVViewController : NSViewController

@property (weak) IBOutlet NSPopUpButton *tablesPopUpButton;
@property (weak) IBOutlet NSTableView *valuesTableView;

@property (weak) IBOutlet NSBox *optionsBoxView;
@property (weak) IBOutlet NSButton *optionShowHeadersCheckBoxButton;
@property (weak) IBOutlet NSTextField *optionDelimiterTextField;
@property (weak) IBOutlet NSTextField *optionEscapeValueTextField;
@property (weak) IBOutlet NSPopUpButton *optionCharacterEncodingPopUpButton;
@property (weak) IBOutlet NSPopUpButton *optionLineEncodingPopUpButton;

- (IBAction)cancel:(id)sender;

@end
