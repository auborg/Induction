// EMFVisualizeViewController.m
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

#import "EMFVisualizeViewController.h"

#import "DBAdapter.h"
#import "EMFResultSetViewController.h"

@implementation EMFVisualizeViewController

- (void)awakeFromNib {    
    [self.webView setUIDelegate:self];
    [self.webView setResourceLoadDelegate:self];
    [self.webView setFrameLoadDelegate:self];
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"visualize" ofType:@"html" inDirectory:@"HTML"]];
    [[self.webView mainFrame] loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    [[self.webView mainFrame] loadHTMLString:[representedObject description] baseURL:nil];
}

#pragma mark - IBAction

#pragma mark - WebKit

/* this message is sent to the WebView's frame load delegate 
 when the page is ready for JavaScript.  It will be called just after 
 the page has loaded, but just before any JavaScripts start running on the
 page.  This is the perfect time to install any of your own JavaScript
 objects on the page.
 */
- (void)webView:(WebView *)webView windowScriptObjectAvailable:(WebScriptObject *)windowScriptObject {
	NSLog(@"%@ received %@", self, NSStringFromSelector(_cmd));
    [windowScriptObject setValue:self forKey:@"console"];
}



/* sent to the WebView's ui delegate when alert() is called in JavaScript.
 If you call alert() in your JavaScript methods, it will call this
 method and display the alert message in the log.  In Safari, this method
 displays an alert that presents the message to the user.
 */
- (void)webView:(WebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message {
	NSLog(@"%@ received %@ with '%@'", self, NSStringFromSelector(_cmd), message);
}



/* the following three methods are used to determine 
 what methods on our object are exposed to JavaScript */


/* This method is called by the WebView when it is deciding what
 methods on this object can be called by JavaScript.  The method
 should return NO the methods we would like to be able to call from
 JavaScript, and YES for all of the methods that cannot be called
 from JavaScript.
 */
+ (BOOL)isSelectorExcludedFromWebScript:(SEL)selector {
	NSLog(@"%@ received %@ for '%@'", self, NSStringFromSelector(_cmd), NSStringFromSelector(selector));
    if (selector == @selector(doOutputToLog:)
        || selector == @selector(changeJavaScriptText:)
        || selector == @selector(reportSharedValue)) {
        return NO;
    }
    return YES;
}



/* This method is called by the WebView to decide what instance
 variables should be shared with JavaScript.  The method should
 return NO for all of the instance variables that should be shared
 between JavaScript and Objective-C, and YES for all others.
 */
+ (BOOL)isKeyExcludedFromWebScript:(const char *)property {
	NSLog(@"%@ received %@ for '%s'", self, NSStringFromSelector(_cmd), property);
//	if (strcmp(property, "sharedValue") == 0) {
//        return NO;
//    }
    return NO;
}



/* This method converts a selector value into the name we'll be using
 to refer to it in JavaScript.  here, we are providing the following
 Objective-C to JavaScript name mappings:
 'doOutputToLog:' => 'log'
 'changeJavaScriptText:' => 'setscript'
 With these mappings in place, a JavaScript call to 'console.log' will
 call through to the doOutputToLog: Objective-C method, and a JavaScript call
 to console.setscript will call through to the changeJavaScriptText:
 Objective-C method.  
 
 Comments for the webScriptNameForSelector: method in WebScriptObject.h talk more
 about the default name conversions performed from Objective-C to JavaScript names.
 You can overrride those defaults by providing your own translations in your
 webScriptNameForSelector: method.
 */
+ (NSString *) webScriptNameForSelector:(SEL)sel {
	NSLog(@"%@ received %@ with sel='%@'", self, NSStringFromSelector(_cmd), NSStringFromSelector(sel));
    if (sel == @selector(doOutputToLog:)) {
		return @"log";
    } else if (sel == @selector(changeJavaScriptText:)) {
		return @"setscript";
        /*
         NOTE:  for the console.report method, we do not need to perform a name translation
         because the Objective-C method name is already the same as the method name
         we will be using in JavaScript.  We have left this part commented out to show
         that the name translation here would be redundant.
         
         } else if (sel == @selector(report)) {
         return @"report";
         
         */
	} else {
		return nil;
	}

    return nil;
}



/* Here is our Objective-C implementation for the JavaScript console.log() method.
 */
- (void) doOutputToLog: (NSString*) theMessage {
	NSLog(@"%@ received %@ with message=%@", self, NSStringFromSelector(_cmd), theMessage);
    
    /* write the message to the log */
    NSLog(@"LOG: %@", theMessage);
    
}

@end
