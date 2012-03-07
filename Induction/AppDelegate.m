//
//  AppDelegate.m
//  NoSQL
//
//  Created by Mattt Thompson on 12/01/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "DBConnectionWindowController.h"

@implementation AppDelegate
@synthesize window = _window;

- (void)awakeFromNib {
    DBConnectionWindowController *connectionController = [[DBConnectionWindowController alloc] initWithWindowNibName:@"DBConnectionWindow"];
    [connectionController showWindow:self];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {

}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return YES;
}

- (BOOL)application:(NSApplication *)sender 
           openFile:(NSString *)filename
{
    // TODO test for connection before showing window
    DBConnectionWindowController *connectionController = [[DBConnectionWindowController alloc] initWithWindowNibName:@"DBConnectionWindow"];
    [connectionController showWindow:self];
    connectionController.configurationViewController.connectionURL = [NSURL fileURLWithPath:filename];
    [connectionController.configurationViewController connect:self];

    return YES;
}

- (void)application:(NSApplication *)sender 
          openFiles:(NSArray *)filenames
{
    for (NSString *filename in filenames) {
        [self application:sender openFile:filename];
    }
}

#pragma mark -

- (IBAction)newWindow:(id)sender {
    DBConnectionWindowController *connectionController = [[DBConnectionWindowController alloc] initWithWindowNibName:@"DBConnectionWindow"];
    [connectionController showWindow:self];
}

@end
