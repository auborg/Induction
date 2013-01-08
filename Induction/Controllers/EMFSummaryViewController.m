//
//  EMFSummaryViewController.m
//  Induction
//
//  Created by Mattt Thompson on 2012/09/21.
//
//

#import "EMFSummaryViewController.h"

@interface EMFSummaryViewController ()

@end

@implementation EMFSummaryViewController

- (void)awakeFromNib {
    self.valueTextField.stringValue = NSStringFromDBValueType(self.valueType);
}

@end
