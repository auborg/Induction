//
//  EMFExportWindowController.m
//  Induction
//
//  Created by Mattt Thompson on 12/04/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EMFExportWindowController.h"
#import "EMFExportViewController.h"
#import "EMFExportCSVViewController.h"

#import "DBAdapter.h"

@implementation EMFExportWindowController
@synthesize dataSource = _dataSource;
@synthesize exportCSVViewController = _exportCSVViewController;
@synthesize CSVToolbarItem = _CSVToolbarItem;
@synthesize TSVToolbarItem = _TSVToolbarItem;
@synthesize JSONToolbarItem = _JSONToolbarItem;
@synthesize XMLToolbarItem = _XMLToolbarItem;

- (void)awakeFromNib {
    self.exportCSVViewController.delegate = self;
    
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

#pragma mark - EMFExportViewControllerDelegate

- (void)exportViewControllerDidCancel:(EMFExportViewController *)viewController {
    [NSApp endSheet:self.window];
}

- (void)exportViewController:(EMFExportViewController *)viewController 
          didSaveFileWithURL:(NSURL *)fileURL 
{    
    [NSApp endSheet:self.window];
}

@end
