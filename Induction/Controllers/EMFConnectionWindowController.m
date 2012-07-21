// EMFConnectionWindowController.m
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
    
    if ([(id <DBConnection>)self.connection database]) {
        self.databaseViewController.database = [(id <DBConnection>)self.connection database];
    }
    
    [self.window setCollectionBehavior:NSWindowCollectionBehaviorFullScreenPrimary];
    [self.window.toolbar setVisible:YES];
    [self.window setContentView:self.databaseViewController.view];
    [self.databaseViewController explore:nil];
}

#pragma mark - IBAction

- (IBAction)databasePopupButtonSelectionDidChange:(id)sender {
    id <DBDatabase> database = [[sender selectedItem] representedObject];
    [self.connection connectionBySelectingDatabase:database];
        
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
