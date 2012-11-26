// EMFDatabaseViewController.m
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

#import "EMFDatabaseViewController.h"

#import "EMFResultSetViewController.h"
#import "EMFQueryViewController.h"
#import "EMFVisualizeViewController.h"

#import "EMFPaginator.h"

#import "DBAdapter.h"
#import "SQLAdapter.h"

static NSUInteger const kExploreDefaultPageSize = 1000;

@interface EMFDatabaseViewController ()
@property (strong, nonatomic, readwrite) NSArray *sourceListNodes;
@property (readonly) NSRange currentPageRange;

@end

@implementation EMFDatabaseViewController {
    NSUInteger _pageSize;
    NSUInteger _currentPage;
    EMFPaginator *_paginator;
}

- (void)awakeFromNib {
    self.queryBox.contentView = self.queryViewController.view;
    self.resultSetBox.contentView = self.resultSetViewController.view;
    self.visualizeBox.contentView = self.visualizeViewController.view;
    
    self.queryViewController.resultsViewController = self.resultSetViewController;
    
    // TODO: I'm sure there's a correct way to do this
    [[self.resultSetViewController.outlineView enclosingScrollView] setNextResponder:self];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NSOutlineViewSelectionDidChangeNotification object:self.resultSetViewController.outlineView queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        NSOutlineView *outlineView = notification.object;
        self.visualizeViewController.representedObject = outlineView.selectedRowIndexes;
    }];
    
    @try {
        [self.dataSourceOutlineView expandItem:nil expandChildren:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
}

- (NSRange)currentPageRange {
    return NSMakeRange(_currentPage * _pageSize, _pageSize);
}

- (void)setDatabase:(id <DBDatabase>)database {
    _database = database;    
    
    NSMutableArray *mutableNodes = [NSMutableArray array];
    [[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [_database numberOfDataSourceGroups])] enumerateIndexesUsingBlock:^(NSUInteger groupIndex, BOOL *stop) {
        NSString *group = [_database dataSourceGroupAtIndex:groupIndex];
        NSTreeNode *groupRootNode = [NSTreeNode treeNodeWithRepresentedObject:group];
        
        [[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [_database numberOfDataSourcesInGroup:group])] enumerateIndexesUsingBlock:^(NSUInteger dataSourceIndex, BOOL *stop) {
            id <DBDataSource> dataSource = [_database dataSourceInGroup:group atIndex:dataSourceIndex];
            NSTreeNode *dataSourceNode = [NSTreeNode treeNodeWithRepresentedObject:dataSource];
            [[groupRootNode mutableChildNodes] addObject:dataSourceNode];
        }];
        [mutableNodes addObject:groupRootNode];
    }];
    
    self.sourceListNodes = [NSArray arrayWithArray:mutableNodes];
    [self.dataSourceOutlineView expandItem:nil expandChildren:YES];    
}

#pragma mark - NSOutlineViewDelegate

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    NSOutlineView *outlineView = [notification object];
    
    id <DBDataSource> dataSource = [[[outlineView itemAtRow:[outlineView selectedRow]] representedObject] representedObject];
    
    self.queryViewController.representedObject = dataSource;
    
    _paginator = [[EMFPaginator alloc] initWithNumberOfIndexes:[(id <DBDataSource>)dataSource numberOfRecords] pageSize:kExploreDefaultPageSize];
    
    [(id <DBExplorableDataSource>)dataSource fetchResultSetForRecordsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:[_paginator currentRange]] success:^(id <DBResultSet> resultSet) {
        self.resultSetViewController.representedObject = resultSet;
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    NSString *identifier = [[(NSTreeNode *)item childNodes] count] > 0 ? @"HeaderCell" : @"DataCell";
    return [outlineView makeViewWithIdentifier:identifier owner:self];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item {
    return [[(NSTreeNode *)item childNodes] count] > 0;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item {
    return ![self outlineView:outlineView isGroupItem:item];
}

#pragma mark - NSSplitViewDelegate

- (void)splitViewDidResizeSubviews:(NSNotification *)notification {
    NSSplitView *splitView = (NSSplitView *)self.view;
    NSRect frame = [[splitView.subviews objectAtIndex:0] frame];
    NSSize minSize = [self.databasesToolbarItem minSize];
    [self.databasesToolbarItem setMinSize:NSMakeSize(frame.size.width - 12.0f, minSize.height)];
}

- (BOOL)splitView:(NSSplitView *)splitView shouldCollapseSubview:(NSView *)subview forDoubleClickOnDividerAtIndex:(NSInteger)dividerIndex {
    return YES;
}

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview {
    return ![subview isKindOfClass:[NSSplitView class]];
}

- (BOOL)splitView:(NSSplitView *)splitView shouldHideDividerAtIndex:(NSInteger)dividerIndex {
    return YES;
}

@end
