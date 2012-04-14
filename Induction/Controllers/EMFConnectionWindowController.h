//
//  DBConnectionWindowController.h
//  Kirin
//
//  Created by Mattt Thompson on 12/01/26.
//  Copyright (c) 2012年 Heroku. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "EMFConnectionConfigurationViewController.h"
#import "EMFDatabaseViewController.h"

#import "DBAdapter.h"

@interface EMFConnectionWindowController : NSWindowController  <EMFConnectionConfigurationViewControllerProtocol>

@property (strong, nonatomic) id <DBConnection> connection;

@property (strong, nonatomic) EMFConnectionConfigurationViewController *configurationViewController;
@property (strong, nonatomic) IBOutlet EMFDatabaseViewController *databaseViewController;
@property (weak) IBOutlet NSPopUpButton *databasesPopUpButton;

- (IBAction)databasePopupButtonSelectionDidChange:(id)sender;

@end
