// EMFExploreViewController.m
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

#import "EMFExploreTableViewController.h"
#import "EMFExportWindowController.h"
#import "EMFDatabaseViewController.h"
#import "EMFResultSetViewController.h"

#import "EMFPaginator.h"
#import "DBAdapter.h"

static NSUInteger const kExploreDefaultPageSize = 1000;

@interface EMFExploreTableViewController () {
@private
    __strong EMFExportWindowController *_exportWindowController;
    
    NSUInteger _pageSize;
    NSUInteger _currentPage;
    __strong EMFPaginator *_paginator;
}

@property (readonly) NSRange currentPageRange;

@end

@implementation EMFExploreTableViewController
@synthesize resultSetViewController = _resultSetViewController;
@synthesize contentBox = _contentBox;
@synthesize leftArrowPageButton = _leftArrowPageButton;
@synthesize rightArrowPageButton = _rightArrowPageButton;
@synthesize pageTextField = _pageTextField;

- (void)awakeFromNib {
    self.contentBox.contentView = self.resultSetViewController.view;
    
    // TODO: I'm sure there's a correct way to do this
    [[self.resultSetViewController.outlineView enclosingScrollView] setNextResponder:self];
}

- (NSRange)currentPageRange {
    return NSMakeRange(_currentPage * _pageSize, _pageSize);
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    _paginator = [[EMFPaginator alloc] initWithNumberOfIndexes:[(id <DBDataSource>)self.representedObject numberOfRecords] pageSize:kExploreDefaultPageSize];
    
    [self changePage:nil];
}

#pragma mark - IBAction

- (IBAction)changePage:(id)sender {
    if ([sender isEqual:self.leftArrowPageButton]) {
        [_paginator previousPage];
    } else if ([sender isEqual:self.rightArrowPageButton]) {
        [_paginator nextPage];
    }
    
    [self.leftArrowPageButton setEnabled:[_paginator hasPreviousPage]];
    [self.rightArrowPageButton setEnabled:[_paginator hasNextPage]];
        
    self.pageTextField.stringValue = [_paginator localizedDescriptionOfCurrentRange];
    
    [(id <DBExplorableDataSource>)self.representedObject fetchResultSetForRecordsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:[_paginator currentRange]] success:^(id <DBResultSet> resultSet) {
        self.resultSetViewController.representedObject = resultSet;
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)exportDocument:(id)sender {
    if (!_exportWindowController) {
        _exportWindowController = [[EMFExportWindowController alloc] initWithWindowNibName:@"EMFExportWindow"];
    }
    
    _exportWindowController.dataSource = self.representedObject;
    
    [NSApp beginSheet:_exportWindowController.window modalForWindow:self.view.window modalDelegate:self didEndSelector:@selector(didEndSheet:returnCode:contextInfo:) contextInfo:nil];
}

#pragma mark - NSApp Delegate Methods

- (void)didEndSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    [NSApp endSheet:sheet returnCode:returnCode];
    [sheet orderOut:self];
}

@end
