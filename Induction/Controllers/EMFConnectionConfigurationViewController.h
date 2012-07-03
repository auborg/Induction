// EMFConnectionConfigurationViewController.h
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

#import <Cocoa/Cocoa.h>
#import "DBAdapter.h"

@class EMFConnectionConfigurationViewController;
@class EMFDatabaseParameterFormatter;

@protocol EMFConnectionConfigurationViewControllerProtocol <NSObject>
@required
- (void)connectionConfigurationController:(EMFConnectionConfigurationViewController *)controller 
                 didConnectWithConnection:(id <DBConnection>)connection;
@end

@interface EMFConnectionConfigurationViewController : NSViewController <NSTextFieldDelegate>

@property (strong) id <EMFConnectionConfigurationViewControllerProtocol> delegate;

@property (strong) NSURL *connectionURL;
@property (readonly) BOOL isConnecting;

@property (weak) IBOutlet NSTextField *URLField;
@property (weak) IBOutlet NSPopUpButton *schemePopupButton;
@property (weak) IBOutlet NSTextField *hostnameField;
@property (weak) IBOutlet NSTextField *usernameField;
@property (weak) IBOutlet NSTextField *passwordField;
@property (weak) IBOutlet NSTextField *portField;
@property (weak) IBOutlet NSTextField *databaseField;
@property (weak) IBOutlet NSButton *connectButton;
@property (weak) IBOutlet NSProgressIndicator *connectionProgressIndicator;

- (IBAction)connect:(id)sender;

@end
