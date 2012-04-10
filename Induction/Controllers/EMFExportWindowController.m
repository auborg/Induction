//
//  EMFExportWindowController.m
//  Induction
//
//  Created by Mattt Thompson on 12/04/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EMFExportWindowController.h"
#import "EMFExportCSVViewController.h"

@implementation EMFExportWindowController
@synthesize exportCSVViewController;
@synthesize CSVToolbarItem;
@synthesize TSVToolbarItem;
@synthesize JSONToolbarItem;
@synthesize XMLToolbarItem;

- (void)awakeFromNib {
     [self selectCSV:self];
}

- (void)windowDidLoad {
    [super windowDidLoad];
}

#pragma mark - IBAction

- (IBAction)selectCSV:(id)sender {
    [self.CSVToolbarItem.toolbar setSelectedItemIdentifier:self.CSVToolbarItem.itemIdentifier];
    [self.window setContentView:self.exportCSVViewController.view];
}

- (IBAction)selectTSV:(id)sender {
    [self.TSVToolbarItem.toolbar setSelectedItemIdentifier:self.TSVToolbarItem.itemIdentifier];
//    [self.window setContentView:self.exportCSVViewController.view];
}

- (IBAction)selectJSON:(id)sender {
    [self.JSONToolbarItem.toolbar setSelectedItemIdentifier:self.JSONToolbarItem.itemIdentifier];
    //    [self.window setContentView:self.exportCSVViewController.view];
}

- (IBAction)selectXML:(id)sender {
    [self.XMLToolbarItem.toolbar setSelectedItemIdentifier:self.XMLToolbarItem.itemIdentifier];
    //    [self.window setContentView:self.exportCSVViewController.view];
}
@end
