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
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    [self.textView insertText:representedObject];
}

@end
