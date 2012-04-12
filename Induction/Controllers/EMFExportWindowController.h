//
//  EMFExportWindowController.h
//  Induction
//
//  Created by Mattt Thompson on 12/04/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class EMFExportCSVViewController;
@class EMFExportViewController;
@protocol DBDataSource;
@protocol DBExplorableDataSource;

@protocol EMFExportViewControllerDelegate <NSObject>
@property (readonly, nonatomic, strong) id <DBDataSource, DBExplorableDataSource> dataSource;

- (void)exportViewControllerDidCancel:(EMFExportViewController *)viewController;
- (void)exportViewController:(EMFExportViewController *)viewController 
          didSaveFileWithURL:(NSURL *)fileURL;
- (void)exportViewController:(EMFExportViewController *)viewController 
            didFailWithError:(NSError *)error;
@end

#pragma mark -

@interface EMFExportWindowController : NSWindowController <EMFExportViewControllerDelegate>

@property (readwrite, nonatomic, strong) id <DBDataSource, DBExplorableDataSource> dataSource;

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
