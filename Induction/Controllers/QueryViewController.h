//
//  QueryViewController.h
//  Kirin
//
//  Created by Mattt Thompson on 12/01/27.
//  Copyright (c) 2012年 Heroku. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DBDatabaseViewController;
@class DBResultSetViewController;
@class NoodleLineNumberView;

@interface QueryViewController : NSViewController

@property (strong) IBOutlet DBDatabaseViewController *databaseViewController;
@property (strong) IBOutlet DBResultSetViewController *resultsTableViewController;
@property (strong) IBOutlet NSBox *contentBox;
@property (strong) IBOutlet NSTextView *textView;
@property (strong) IBOutlet NoodleLineNumberView *lineNumberView;

- (IBAction)execute:(id)sender;

@end
