#import <Foundation/Foundation.h>
#import "DBAdapter.h"

@class RedisResultSet;

@interface RedisAdapter : NSObject <DBAdapter>
@end

#pragma mark -

@interface RedisConnection : NSObject <DBConnection, DBDatabase>
@end

#pragma mark -

@interface RedisDataSource : NSObject <DBDataSource, DBExplorableDataSource, DBQueryableDataSource>

- (id)initWithName:(NSString *)name
              keys:(NSArray *)keys
        connection:(RedisConnection *)connection;

@end

#pragma mark -

@interface RedisResultSet : NSObject <DBResultSet>

- (id)initWithRecords:(NSArray *)records;

@end

#pragma mark -

@interface RedisKeyValuePair : NSObject <DBRecord>

- (id)initWithKey:(NSString *)key
            value:(NSString *)value;

@end

#pragma mark -

@interface RedisRecord : NSObject <DBRecord>

- (id)initWithKey:(NSString *)key
       connection:(RedisConnection *)connection;

@end

#pragma mark -

@interface RedisHash : RedisRecord
@end

@interface RedisList : RedisRecord
@end

@interface RedisSet : RedisRecord
@end

@interface RedisSortedSet : RedisRecord
@end

@interface RedisString : RedisRecord
@end