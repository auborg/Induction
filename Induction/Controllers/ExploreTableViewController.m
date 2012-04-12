//
//  ExploreViewController.m
//  Kirin
//
//  Created by Mattt Thompson on 12/01/26.
//  Copyright (c) 2012年 Heroku. All rights reserved.
//

#import "ExploreTableViewController.h"
#import "EMFExportWindowController.h"
#import "DBDatabaseViewController.h"
#import "DBResultSetViewController.h"

#import "DBPaginator.h"
#import "DBAdapter.h"

static NSUInteger const kExploreDefaultPageSize = 256;

@interface ExploreTableViewController () {
@private
    __strong EMFExportWindowController *_exportWindowController;
    
    NSUInteger _pageSize;
    NSUInteger _currentPage;
    __strong DBPaginator *_paginator;
}

@property (readonly) NSRange currentPageRange;

@end

@implementation ExploreTableViewController
@synthesize resultSetViewController = _resultSetViewController;
@synthesize contentBox = _contentBox;
@synthesize leftArrowPageButton = _leftArrowPageButton;
@synthesize rightArrowPageButton = _rightArrowPageButton;
@synthesize pageTextField = _pageTextField;

- (void)awakeFromNib {
    self.contentBox.contentView = self.resultSetViewController.view;
    [self.resultSetViewController setNextResponder:self];
}

- (NSRange)currentPageRange {
    return NSMakeRange(_currentPage * _pageSize, _pageSize);
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    _paginator = [[DBPaginator alloc] initWithNumberOfIndexes:[(id <DBDataSource>)self.representedObject numberOfRecords] pageSize:kExploreDefaultPageSize];
    
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
