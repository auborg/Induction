//
//  DBDataSourceTableViewController.h
//  Kirin
//
//  Created by Mattt Thompson on 12/02/15.
//  Copyright (c) 2012年 Heroku. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

@interface DBResultSetViewController : NSViewController <NSOutlineViewDataSource, NSOutlineViewDelegate, NSPopoverDelegate>

@property (weak, nonatomic) IBOutlet NSOutlineView *outlineView;
@property (weak, nonatomic) IBOutlet NSPopover *popover;

- (IBAction)copyAsJSON:(id)sender;
- (IBAction)copyAsXML:(id)sender;
- (IBAction)copyAsTSV:(id)sender;

- (IBAction)incrementFontSize:(id)sender;
- (IBAction)decrementFontSize:(id)sender;

@end
