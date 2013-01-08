//
//  EMFSummaryViewController.h
//  Induction
//
//  Created by Mattt Thompson on 2012/09/21.
//
//

#import <Cocoa/Cocoa.h>
#import "DBAdapter.h"

@interface EMFSummaryViewController : NSViewController

@property (assign) DBValueType valueType;
@property (weak) IBOutlet NSTextField *valueTextField;

@end
