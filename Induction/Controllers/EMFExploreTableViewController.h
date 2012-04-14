//
//  ExploreViewController.h
//  Kirin
//
//  Created by Mattt Thompson on 12/01/26.
//  Copyright (c) 2012年 Heroku. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SQLAdapter.h"

@class EMFResultSetViewController;

@interface EMFExploreTableViewController : NSViewController <NSTableViewDelegate>

@property (strong, nonatomic) IBOutlet EMFResultSetViewController *resultSetViewController;
@property (strong, nonatomic) IBOutlet NSBox *contentBox;

@property (strong, nonatomic) IBOutlet NSButton *leftArrowPageButton;
@property (strong, nonatomic) IBOutlet NSButton *rightArrowPageButton;
@property (strong, nonatomic) IBOutlet NSTextField *pageTextField;

- (IBAction)changePage:(id)sender;

- (IBAction)exportDocument:(id)sender;

@end
