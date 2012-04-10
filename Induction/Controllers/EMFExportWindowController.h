//
//  EMFExportWindowController.h
//  Induction
//
//  Created by Mattt Thompson on 12/04/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class EMFExportCSVViewController;

@interface EMFExportWindowController : NSWindowController

@property (strong) IBOutlet EMFExportCSVViewController *exportCSVViewController;

@property (weak) IBOutlet NSToolbarItem *CSVToolbarItem;
@property (weak) IBOutlet NSToolbarItem *TSVToolbarItem;
@property (weak) IBOutlet NSToolbarItem *JSONToolbarItem;
@property (weak) IBOutlet NSToolbarItem *XMLToolbarItem;

- (IBAction)selectCSV:(id)sender;
- (IBAction)selectTSV:(id)sender;
- (IBAction)selectJSON:(id)sender;
- (IBAction)selectXML:(id)sender;

@end
