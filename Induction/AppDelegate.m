//
//  AppDelegate.m
//  NoSQL
//
//  Created by Mattt Thompson on 12/01/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "EMFConnectionWindowController.h"

#ifndef SPARKLE
#import <Sparkle/Sparkle.h>
#endif

@implementation AppDelegate
@synthesize window = _window;

- (void)awakeFromNib {
    EMFConnectionWindowController *connectionController = [[EMFConnectionWindowController alloc] initWithWindowNibName:@"EMFConnectionWindow"];
    [connectionController showWindow:self];
}

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
#ifndef SPARKLE
    [SUUpdater sharedUpdater];
    [[SUUpdater sharedUpdater] setAutomaticallyChecksForUpdates:YES];
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

- (IBAction)newWindow:(id)sender {
    EMFConnectionWindowController *connectionController = [[EMFConnectionWindowController alloc] initWithWindowNibName:@"EMFConnectionWindow"];
    [connectionController showWindow:self];
}

@end
