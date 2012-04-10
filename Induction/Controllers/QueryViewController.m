//
//  QueryViewController.m
//  Kirin
//
//  Created by Mattt Thompson on 12/01/27.
//  Copyright (c) 2012年 Heroku. All rights reserved.
//

#import "QueryViewController.h"

#import "DBDatabaseViewController.h"
#import "DBResultSetViewController.h"
#import "DBAdapter.h"

#import "NoodleLineNumberView.h"

@implementation QueryViewController {
    __strong NoodleLineNumberView *_lineNumberView;
}

@synthesize databaseViewController = _databaseViewController;
@synthesize resultsTableViewController = _resultsTableViewController;
@synthesize contentBox = _contentBox;
@synthesize textView = _textView;
@synthesize lineNumberView = _lineNumberView;

- (void)awakeFromNib {
    self.textView.font = [NSFont userFixedPitchFontOfSize:18.0f];
    
    self.contentBox.contentView = self.resultsTableViewController.view;
    
    _lineNumberView = [[NoodleLineNumberView alloc] initWithScrollView:[self.textView enclosingScrollView]];
    _lineNumberView.backgroundColor = [NSColor whiteColor];
    [[self.textView enclosingScrollView] setVerticalRulerView:_lineNumberView];
    [[self.textView enclosingScrollView] setHasHorizontalRuler:NO];
    [[self.textView enclosingScrollView] setHasVerticalRuler:YES];
    [[self.textView enclosingScrollView] setRulersVisible:YES];	
}

#pragma mark - IBAction

- (IBAction)execute:(id)sender {
    [(id <DBQueryableDataSource>)self.representedObject fetchResultSetForQuery:[self.textView string] success:^(id<DBResultSet> resultSet, NSTimeInterval elapsedTime) {
        self.resultsTableViewController.representedObject = resultSet;
    } failure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
