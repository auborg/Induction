// EMFExportWindowController.m
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
    
    // TODO: Temporary
    [self.TSVToolbarItem setEnabled:NO];
    [self.JSONToolbarItem setEnabled:NO];
    [self.XMLToolbarItem setEnabled:NO];
    
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

- (void)exportViewController:(EMFExportViewController *)viewController didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
}

@end
