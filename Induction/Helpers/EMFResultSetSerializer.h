//
//  EMFResultSetTransformer.h
//  Induction
//
//  Created by Mattt Thompson on 12/04/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBAdapter.h"

@interface EMFResultSetSerializer : NSObject

+ (NSString *)CSVFromResultSet:(id <DBResultSet>)resultSet
          fromRecordsAtIndexes:(NSIndexSet *)recordsIndexSet
                    withFields:(NSArray *)fields
                   showHeaders:(BOOL)showHeaders
               enclosingString:(NSString *)enclosingString
                stringEncoding:(NSStringEncoding)stringEncoding;

+ (NSString *)TSVFromResultSet:(id <DBResultSet>)resultSet
          fromRecordsAtIndexes:(NSIndexSet *)recordsIndexSet
                    withFields:(NSArray *)fields
                   showHeaders:(BOOL)showHeaders
               enclosingString:(NSString *)enclosingString
                stringEncoding:(NSStringEncoding)stringEncoding;

+ (NSString *)JSONFromResultSet:(id <DBResultSet>)resultSet
           fromRecordsAtIndexes:(NSIndexSet *)recordsIndexSet
                     withFields:(NSArray *)fields
                 stringEncoding:(NSStringEncoding)stringEncoding;

+ (NSString *)XMLFromResultSet:(id <DBResultSet>)resultSet
          fromRecordsAtIndexes:(NSIndexSet *)recordsIndexSet
                    withFields:(NSArray *)fields
                stringEncoding:(NSStringEncoding)stringEncoding;

@end
