//
//  EMFExportCSVViewController.m
//  Induction
//
//  Created by Mattt Thompson on 12/04/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EMFExportCSVViewController.h"

@implementation EMFExportCSVViewController
@synthesize tablesPopUpButton;
@synthesize valuesTableView;
@synthesize optionsBoxView;
@synthesize optionShowHeadersCheckBoxButton;
@synthesize optionDelimiterTextField;
@synthesize optionEscapeValueTextField;
@synthesize optionCharacterEncodingPopUpButton;
@synthesize optionLineEncodingPopUpButton;

- (void)awakeFromNib {
    
}

#pragma mark - IBAction

- (IBAction)cancel:(id)sender {
    NSLog(@"cancel");
    NSLog(@"View: %@", self.view);
    NSLog(@"Sheet: %@", self.view.window);
    [NSApp endSheet:self.view.window];
}

@end
