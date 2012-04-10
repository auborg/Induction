//
//  SQLiteAdapter.m
//  SQLiteAdapter
//
//  Created by Mattt Thompson on 12/03/05.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SQLiteAdapter.h"

#import <sqlite3.h>

static dispatch_queue_t induction_sqlite_adapter_queue() {
    static dispatch_queue_t _induction_sqlite_adapter_queue;
    if (_induction_sqlite_adapter_queue == NULL) {
        _induction_sqlite_adapter_queue = dispatch_queue_create("com.induction.sqlite.adapter.queue", DISPATCH_QUEUE_SERIAL);
    }
    
    return _induction_sqlite_adapter_queue;
}

NSString * const SQLiteErrorDomain = @"com.heroku.client.postgresql.error";

@implementation SQLiteAdapter

+ (NSString *)localizedName {
    return NSLocalizedString(@"SQLite", nil);
}

+ (NSString *)primaryURLScheme {
    return @"sqlite";
}

+ (BOOL)canConnectToURL:(NSURL *)url {
    return [[NSSet setWithObjects:@"sqlite", @"sqlite3", @"file", nil] containsObject:[url scheme]];    
}

+ (void)connectToURL:(NSURL *)url
             success:(void (^)(id <DBConnection> connection))success
             failure:(void (^)(NSError *error))failure
{    
    dispatch_async(induction_sqlite_adapter_queue(), ^(void) {
        SQLiteConnection *connection = [[SQLiteConnection alloc] initWithURL:url];
        NSError *error = nil;    
        BOOL connected = [connection open:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (connected) {
                if (success) {
                    success(connection);
                }
            } else {
                if (failure) {
                    failure(error);
                }
            }
        });
    });
}

@end

#pragma mark -

@interface SQLiteConnection () {
@public
    sqlite3 *_sqlite3_connection;
@private
    __strong NSURL *_url;
    __strong SQLiteDatabase *_database;
}

@end

@implementation SQLiteConnection
@synthesize url = _url;
@synthesize database = _database;

- (void)dealloc {
    if (_sqlite3_connection) {
        _sqlite3_connection = NULL;
    }
}

- (id)initWithURL:(NSURL *)url {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _url = url;
    
    return self;
}

- (BOOL)open:(NSError *__autoreleasing *)error {
	[self close:nil];
    
    _sqlite3_connection = NULL;
    
    int status = sqlite3_open([[_url absoluteString] UTF8String], &_sqlite3_connection);

    if (status != 0) {
        NSMutableDictionary *mutableUserInfo = [NSMutableDictionary dictionary];
        [mutableUserInfo setValue:NSLocalizedString(@"Connection Error", nil) forKey:NSLocalizedDescriptionKey];
        [mutableUserInfo setValue:[NSString stringWithUTF8String:sqlite3_errmsg(_sqlite3_connection)] forKey:NSLocalizedRecoverySuggestionErrorKey];
        [mutableUserInfo setValue:_url forKey:NSURLErrorKey];
        
        *error = [[NSError alloc] initWithDomain:SQLiteErrorDomain code:sqlite3_errcode(_sqlite3_connection) userInfo:mutableUserInfo];
        
        return NO;
    }
    
    _database = [[SQLiteDatabase alloc] initWithConnection:self name:[_url path] stringEncoding:NSUTF8StringEncoding];
    
    return YES;
}

- (BOOL)close:(NSError *__autoreleasing *)error {
    if (!_sqlite3_connection) {
        return NO;
    }
    
    sqlite3_close(_sqlite3_connection);
    
	return YES;
}

- (BOOL)reset:(NSError *__autoreleasing *)error{
    return NO;
}

- (id <SQLResultSet>)executeSQL:(NSString *)SQL 
                          error:(NSError *__autoreleasing *)error 
{    
    sqlite3_stmt *sqlite3_statement = NULL;
    sqlite3_prepare_v2(_sqlite3_connection, [SQL UTF8String], -1, &sqlite3_statement, NULL);
    
    if (sqlite3_statement) {
        return [[SQLiteResultSet alloc] initWithSQLiteStatement:sqlite3_statement];
    } else {
        return nil;
    }
}

- (id <SQLResultSet>)resultSetByExecutingSQL:(NSString *)SQL 
                                       error:(NSError *__autoreleasing *)error
{
    sqlite3_stmt *sqlite3_statement = NULL;
    sqlite3_prepare_v2(_sqlite3_connection, [SQL UTF8String], -1, &sqlite3_statement, NULL);
    
    if (sqlite3_statement) {
        return [[SQLiteResultSet alloc] initWithSQLiteStatement:sqlite3_statement];
    }
    
    return nil;
}

- (void)executeSQL:(NSString *)SQL
           success:(void (^)(id <SQLResultSet> resultSet, NSTimeInterval elapsedTime))success
           failure:(void (^)(NSError *error))failure
{
    dispatch_async(induction_sqlite_adapter_queue(), ^(void) {
        sqlite3_stmt *sqlite3_statement = NULL;
        CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
        sqlite3_prepare_v2(_sqlite3_connection, [SQL UTF8String], -1, &sqlite3_statement, NULL);
        CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
        
        SQLiteResultSet *resultSet = nil;
        NSError *error = nil;
        if (sqlite3_statement) {
            resultSet = [[SQLiteResultSet alloc] initWithSQLiteStatement:sqlite3_statement];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (error) {
                if (failure) {
                    failure(error);
                }
            } else {
                if (success) {
                    success(resultSet, (endTime - startTime));
                }
            }
        });
    });
}

- (NSArray *)availableDatabases {    
    return [NSArray array];
}

@end

#pragma mark -

@interface SQLiteDatabase () {
@private
    __strong SQLiteConnection *_connection;
    __strong NSString *_name;
    __strong NSArray *_tables;
    NSStringEncoding _stringEncoding;
}
@end

@implementation SQLiteDatabase
@synthesize connection = _connection;
@synthesize name = _name;
@synthesize stringEncoding = _stringEncoding;
@synthesize tables = _tables;

- (id)initWithConnection:(id<SQLConnection>)connection name:(NSString *)name stringEncoding:(NSStringEncoding)stringEncoding 
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _connection = connection;
    _name = name;
    _stringEncoding = NSUTF8StringEncoding;
    
    SQLiteResultSet *resultSet = [_connection executeSQL:@"SELECT name FROM (SELECT * FROM sqlite_master UNION ALL SELECT * FROM sqlite_temp_master) WHERE type == 'table' AND name NOT LIKE 'sqlite_%' ORDER BY name ASC" error:nil];
    NSString *fieldName = [[[resultSet fields] lastObject] name];
    NSMutableArray *mutableTables = [NSMutableArray array];
    [[resultSet tuples] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SQLiteTable *table = [[SQLiteTable alloc] initWithDatabase:self name:[(SQLiteTuple *)obj valueForKey:fieldName] stringEncoding:NSUTF8StringEncoding];
        [mutableTables addObject:table];
    }];
    
    _tables = mutableTables;
    
    return self;
}

- (NSString *)description {
    return _name;
}

- (NSDictionary *)metadata {
    return nil;
}

- (NSUInteger)numberOfDataSourceGroups {
    return 1;
}

- (NSString *)dataSourceGroupAtIndex:(NSUInteger)index {
    return NSLocalizedString(@"Tables", nil);
}

- (NSUInteger)numberOfDataSourcesInGroup:(NSString *)group {
    return [_tables count];
}

- (id <DBDataSource>)dataSourceInGroup:(NSString *)group atIndex:(NSUInteger)index {
    return [_tables objectAtIndex:index];
}

@end

#pragma mark -

@interface SQLiteTable () {
@private
    __strong SQLiteDatabase *_database;
    __strong NSString *_name;
    NSStringEncoding _stringEncoding;
}
@end

@implementation SQLiteTable
@synthesize name = _name;
@synthesize stringEncoding = _stringEncoding;

- (id)initWithDatabase:(id<SQLDatabase>)database 
                  name:(NSString *)name 
        stringEncoding:(NSStringEncoding)stringEncoding
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _database = database;
    _name = name;
    _stringEncoding = stringEncoding;
    
    return self;
}

- (NSString *)description {
    return _name;
}

- (NSUInteger)numberOfRecords {
    return [[[[[[_database connection] resultSetByExecutingSQL:[NSString stringWithFormat:@"SELECT COUNT(*) as count FROM %@", _name] error:nil] recordsAtIndexes:[NSIndexSet indexSetWithIndex:0]] lastObject] valueForKey:@"count"] integerValue]; 
}

- (void)fetchResultSetForRecordsAtIndexes:(NSIndexSet *)indexes 
                                  success:(void (^)(id<DBResultSet>))success 
                                  failure:(void (^)(NSError *))failure 
{
    NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %d OFFSET %d ", _name, [indexes count], [indexes firstIndex]];
    [[_database connection] executeSQL:SQL success:^(id<SQLResultSet> resultSet, NSTimeInterval elapsedTime) {
        if (success) {
            success(resultSet);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark -

- (void)fetchResultSetForQuery:(NSString *)query 
                       success:(void (^)(id<DBResultSet>, NSTimeInterval))success 
                       failure:(void (^)(NSError *))failure 
{
    
    [[_database connection] executeSQL:query success:^(id<SQLResultSet> resultSet, NSTimeInterval elapsedTime) {
        if (success) {
            success(resultSet, elapsedTime);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark -

// TODO
- (void)fetchResultSetForDimension:(NSExpression *)dimension
                          measures:(NSArray *)measures
                           success:(void (^)(id <DBResultSet> resultSet))success
                           failure:(void (^)(NSError *error))failure
{
    return;
}

@end

#pragma mark -

@interface SQLiteField () {
@private
    NSUInteger _index;
    __strong NSString *_name;
    DBValueType _type;
    NSUInteger _size;
}
@end

@implementation SQLiteField
@synthesize index = _index;
@synthesize name = _name;
@synthesize type = _type;
@synthesize size = _size;

+ (SQLiteField *)fieldInSQLiteResult:(void *)result 
                             atIndex:(NSUInteger)fieldIndex 
{
    SQLiteField *field = [[SQLiteField alloc] init];
    field->_index = fieldIndex;
    field->_name = [NSString stringWithUTF8String:sqlite3_column_name(result, (int)fieldIndex)];
    field->_type = DBStringValue;
    
    return field;
}

- (id)objectForBytes:(const char *)bytes 
              length:(NSUInteger)length 
            encoding:(NSStringEncoding)encoding 
{
    return [[NSString alloc] initWithBytes:bytes length:length encoding:encoding];    
}

@end

#pragma mark -

@interface SQLiteTuple () {
@private
    NSUInteger _index;
    __strong NSDictionary *_valuesKeyedByFieldName;
}
@end

@implementation SQLiteTuple
@synthesize index = _index;

- (id)initWithValuesKeyedByFieldName:(NSDictionary *)keyedValues {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _valuesKeyedByFieldName = keyedValues;
    
    return self;
}

- (id)valueForKey:(NSString *)key {
    return [_valuesKeyedByFieldName objectForKey:key];
}

@end

#pragma mark -

@interface SQLiteResultSet () {
@private
    NSUInteger _tuplesCount;
    NSUInteger _fieldsCount;
    __strong NSArray *_fields;
    __strong NSDictionary *_fieldsKeyedByName;
    __strong NSArray *_tuples;
}

- (id)tupleValueForStatement:(void *)statement 
                atFieldIndex:(NSUInteger)fieldIndex;
@end

@implementation SQLiteResultSet
@synthesize fields = _fields;
@synthesize tuples = _tuples;

- (id)initWithSQLiteStatement:(void *)result {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _fieldsCount = sqlite3_column_count(result);
    
    NSMutableArray *mutableFields = [[NSMutableArray alloc] initWithCapacity:_fieldsCount];
    NSIndexSet *fieldIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, _fieldsCount)];
    [fieldIndexSet enumerateIndexesWithOptions:NSEnumerationConcurrent usingBlock:^(NSUInteger fieldIndex, BOOL *stop) {
        SQLiteField *field = [SQLiteField fieldInSQLiteResult:result atIndex:fieldIndex];
        [mutableFields addObject:field];
    }];
    _fields = mutableFields;
    
    NSMutableDictionary *mutableKeyedFields = [[NSMutableDictionary alloc] initWithCapacity:_fieldsCount];
    for (SQLiteField *field in _fields) {
        [mutableKeyedFields setObject:field forKey:field.name];
    }
    _fieldsKeyedByName = mutableKeyedFields;
    
    NSMutableArray *mutableTuples = [[NSMutableArray alloc] init];
    sqlite3_reset(result);
    int code = sqlite3_step(result);
    while (code == SQLITE_ROW) {
        NSMutableDictionary *mutableKeyedTupleValues = [[NSMutableDictionary alloc] initWithCapacity:_fieldsCount];
        for (SQLiteField *field in _fields) {
            id value = [self tupleValueForStatement:result atFieldIndex:[field index]];
            [mutableKeyedTupleValues setObject:value forKey:[field name]];
        }
        SQLiteTuple *tuple = [[SQLiteTuple alloc] initWithValuesKeyedByFieldName:mutableKeyedTupleValues];
        [mutableTuples addObject:tuple];
        code = sqlite3_step(result);
    }
    
    _tuples = mutableTuples;
    _tuplesCount = [_tuples count];
    
    sqlite3_finalize(result);
    
    return self;
}

- (id)tupleValueForStatement:(void *)statement 
                atFieldIndex:(NSUInteger)fieldIndex
{
    const char *bytes = (const char *)sqlite3_column_text(statement, (int)fieldIndex);
    if (bytes == NULL) {
        return [NSNull null];
    } else {
        return [[NSString alloc] initWithUTF8String:bytes];
    }
}

- (NSUInteger)numberOfFields {
    return _fieldsCount;
}

- (NSUInteger)numberOfRecords {
    return _tuplesCount;
}

- (NSArray *)recordsAtIndexes:(NSIndexSet *)indexes {
    return [_tuples objectsAtIndexes:indexes];
}

- (NSString *)identifierForTableColumnAtIndex:(NSUInteger)index {
    SQLiteField *field = [_fields objectAtIndex:index];
    return [field name];
}

- (DBValueType)valueTypeForTableColumnAtIndex:(NSUInteger)index {
    SQLiteField *field = [_fields objectAtIndex:index];
    return [field type];
}

- (NSSortDescriptor *)sortDescriptorPrototypeForTableColumnAtIndex:(NSUInteger)index {
    SQLiteField *field = [_fields objectAtIndex:index];
    if ([field type] == DBStringValue) {
        return [NSSortDescriptor sortDescriptorWithKey:[field name] ascending:YES selector:@selector(localizedStandardCompare:)];
    } else {
        return [NSSortDescriptor sortDescriptorWithKey:[field name] ascending:YES];
    }
}

@end
