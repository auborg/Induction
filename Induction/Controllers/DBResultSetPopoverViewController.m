//
//  DBResultSetPopoverViewController.m
//  Induction
//
//  Created by Mattt Thompson on 12/03/19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DBResultSetPopoverViewController.h"

@implementation DBResultSetPopoverViewController
@synthesize textView = _textView;

- (void)awakeFromNib {
    [self.textView setEditable:NO];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    if (representedObject) {
        [self.textView setString:[representedObject description]];
    }
}

@end
