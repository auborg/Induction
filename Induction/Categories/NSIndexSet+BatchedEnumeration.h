//
//  NSIndexSet+BatchedEnumeration.h
//  Induction
//
//  Created by Mattt Thompson on 12/04/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexSet (BatchedEnumeration)

- (void)enumerateIndexesChunkedIntoBatchesOfSize:(NSUInteger)batchSize 
                                      usingBlock:(void (^)(NSIndexSet *indexSet, NSUInteger idx))block;

@end
