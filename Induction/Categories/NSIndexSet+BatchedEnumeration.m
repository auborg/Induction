//
//  NSIndexSet+BatchedEnumeration.m
//  Induction
//
//  Created by Mattt Thompson on 12/04/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSIndexSet+BatchedEnumeration.h"

@implementation NSIndexSet (BatchedEnumeration)

- (void)enumerateIndexesChunkedIntoBatchesOfSize:(NSUInteger)batchSize 
                                      usingBlock:(void (^)(NSIndexSet *indexSet, NSUInteger idx))block
{
    if (!block) {
        return;
    }
    
    NSUInteger numberOfBatches = (NSUInteger)ceilf([self count] / (float)batchSize);
    [[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, numberOfBatches)] enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        block([self indexesInRange:NSMakeRange(idx * batchSize, batchSize) options:0 passingTest:^BOOL(NSUInteger idx, BOOL *stop) {
            return YES;
        }], idx);
    }];
}

@end
