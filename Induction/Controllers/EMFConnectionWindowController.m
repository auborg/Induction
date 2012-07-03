//
//  DBConnectionWindowController.m
//  Kirin
//
//  Created by Mattt Thompson on 12/01/26.
//  Copyright (c) 2012年 Heroku. All rights reserved.
//

#import "EMFConnectionWindowController.h"

#import "DBAdapter.h"

@implementation EMFConnectionWindowController
@synthesize connection = _connection;

@synthesize configurationViewController = _configurationViewController;
@synthesize databaseViewController = _databaseViewController;
@synthesize databasesPopUpButton = _databasesPopUpButton;

- (void)awakeFromNib {
    [self.window.toolbar setVisible:NO];
    
    [self.databasesPopUpButton bind:@"content" toObject:self withKeyPath:@"connection.availableDatabases" options:nil];
    [self.databasesPopUpButton bind:@"selectedObject" toObject:self withKeyPath:@"connection.database" options:nil];
//    self.databasesPopUpButton bind:@"hidden" toObject:self withKeyPath:@"connection.availableDatabases" options:nil];
}

- (void)setConnection:(id<DBConnection>)connection {
    [self willChangeValueForKey:@"connection"];
    _connection = connection;
    [self didChangeValueForKey:@"connection"];
    
    self.databaseViewController.database = [(id <DBConnection>)self.connection database];
    
    [self.window setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    [self.window.toolbar setVisible:YES];
    [self.window setContentView:self.databaseViewController.view];
    [self.databaseViewController explore:nil];
}

#pragma mark - IBAction

- (IBAction)databasePopupButtonSelectionDidChange:(id)sender {
    NSLog(@"databasePopupButtonSelectionDidChange:%@", sender);
    id <DBDatabase> database = [[sender selectedItem] representedObject];
    NSLog(@"db: %@", database);
    [self.connection connectToDatabase:database error:nil];
    
    self.databaseViewController.database = [(id <DBConnection>)self.connection database];
//    [self.databaseViewController explore:nil];
}

#pragma mark - NSWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.configurationViewController = [[EMFConnectionConfigurationViewController alloc] initWithNibName:@"EMFConnectionConfigurationView" bundle:nil];
    self.configurationViewController.delegate = self;
    
    [self.window setContentView:self.configurationViewController.view];
    [self.window setContentSize:self.window.frame.size];
}

#pragma mark - DBConnectionConfigurationViewControllerProtocol

- (void)connectionConfigurationController:(EMFConnectionConfigurationViewController *)controller 
                 didConnectWithConnection:(id <DBConnection>)connection
{
    self.connection = connection;
}

@end
