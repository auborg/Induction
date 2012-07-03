// AppDelegate.m
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
#endif
}


- (IBAction)newWindow:(id)sender {
    EMFConnectionWindowController *connectionController = [[EMFConnectionWindowController alloc] initWithWindowNibName:@"EMFConnectionWindow"];
    [connectionController showWindow:self];
}

@end
