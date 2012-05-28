//
//  AppDelegate.m
//  NoSQL
//
//  Created by Mattt Thompson on 12/01/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "EMFConnectionWindowController.h"

#ifdef SPARKLE
#import <Sparkle/Sparkle.h>
#import "PFMoveApplication.h"
#endif

@implementation AppDelegate
@synthesize window = _window;
@synthesize checkForUpdatesMenuItem = _checkForUpdatesMenuItem;

- (void)awakeFromNib {
    EMFConnectionWindowController *connectionController = [[EMFConnectionWindowController alloc] initWithWindowNibName:@"EMFConnectionWindow"];
    [connectionController showWindow:self];
}

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
#ifdef SPARKLE
	PFMoveToApplicationsFolderIfNecessary();
    [self.checkForUpdatesMenuItem setEnabled:YES];
    [self.checkForUpdatesMenuItem setHidden:NO];
#endif
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return NO;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication 
                    hasVisibleWindows:(BOOL)flag 
{
    if (!flag) {
        [self newWindow:self];
    }
    
    return YES;
}

- (BOOL)application:(NSApplication *)sender 
           openFile:(NSString *)filename
{
    // TODO test for connection before showing window
    EMFConnectionWindowController *connectionController = [[EMFConnectionWindowController alloc] initWithWindowNibName:@"EMFConnectionWindow"];
    [connectionController showWindow:self];
    connectionController.configurationViewController.connectionURL = [NSURL fileURLWithPath:filename];
    [connectionController.configurationViewController connect:self];

    return YES;
}

// TODO: Warn if number of files is large
- (void)application:(NSApplication *)sender 
          openFiles:(NSArray *)filenames
{
    for (NSString *filename in filenames) {
        [self application:sender openFile:filename];
    }
}

#pragma mark - IBAction

- (IBAction)checkForUpdates:(id)sender {
#ifdef SPARKLE
    [[SUUpdater sharedUpdater] setSendsSystemProfile:YES];
    [[SUUpdater sharedUpdater] checkForUpdates:sender];
#endifg
}


- (IBAction)newWindow:(id)sender {
    EMFConnectionWindowController *connectionController = [[EMFConnectionWindowController alloc] initWithWindowNibName:@"EMFConnectionWindow"];
    [connectionController showWindow:self];
}

@end
