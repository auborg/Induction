//
//  DBDatabaseViewController.h
//  Kirin
//
//  Created by Mattt Thompson on 12/01/26.
//  Copyright (c) 2012年 Heroku. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DBAdapter.h"

@class EMFExploreTableViewController;
@class EMFQueryViewController;
@class EMFVisualizeViewController;
@class SQLResultsTableViewController;

enum _DBDatabaseViewTabs {
    ExploreTab,
    QueryTab,
    VisualizeTab,
} DBDatabaseViewTabs;

@interface EMFDatabaseViewController : NSViewController <NSOutlineViewDelegate>

@property (strong, nonatomic) id <DBDatabase> database;
@property (strong, nonatomic, readonly) NSArray *sourceListNodes;

@property (weak, nonatomic) IBOutlet NSToolbar *toolbar;
@property (weak, nonatomic) IBOutlet NSOutlineView *outlineView;
@property (weak, nonatomic) IBOutlet NSTabView *tabView;

@property (strong, nonatomic) IBOutlet EMFExploreTableViewController *exploreViewController;
@property (strong, nonatomic) IBOutlet EMFQueryViewController *queryViewController;
@property (strong, nonatomic) IBOutlet EMFVisualizeViewController *visualizeViewController;

- (IBAction)explore:(id)sender;
- (IBAction)query:(id)sender;
- (IBAction)visualize:(id)sender;

@end
