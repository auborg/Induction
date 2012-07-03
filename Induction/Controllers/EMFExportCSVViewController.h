// EMFExportCSVViewController.h
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
#import "EMFExportViewController.h"

@interface EMFExportedField : NSObject
@property (assign, getter = isEnabled) BOOL enabled;
@property (strong) NSString *name;
@property (strong) NSString *displayName;
@end

#pragma mark -

@interface EMFExportCSVViewController : EMFExportViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSPopUpButton *tablesPopUpButton;

@property (weak) IBOutlet NSTableView *fieldsTableView;
@property (strong) IBOutlet NSArrayController *fieldsArrayController;
@property (weak) IBOutlet NSBox *optionsBoxView;
@property (weak) IBOutlet NSButton *optionShowHeadersCheckBoxButton;
@property (weak) IBOutlet NSComboBox *optionDelimiterComboBox;
@property (weak) IBOutlet NSComboBox *optionEnclosingStringComboBox;
@property (weak) IBOutlet NSComboBox *optionNULLRepresentationComboBox;

- (IBAction)cancel:(id)sender;

@end
