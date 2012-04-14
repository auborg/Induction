//
//  QueryViewController.h
//  Kirin
//
//  Created by Mattt Thompson on 12/01/27.
//  Copyright (c) 2012年 Heroku. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class EMFDatabaseViewController;
@class EMFResultSetViewController;
@class NoodleLineNumberView;

@interface EMFQueryViewController : NSViewController

@property (strong) IBOutlet EMFDatabaseViewController *databaseViewController;
@property (strong) IBOutlet EMFResultSetViewController *resultsTableViewController;
@property (strong) IBOutlet NSBox *contentBox;
@property (strong) IBOutlet NSTextView *textView;
@property (strong) IBOutlet NoodleLineNumberView *lineNumberView;

- (IBAction)execute:(id)sender;

@end
