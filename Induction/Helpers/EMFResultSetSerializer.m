//
//  EMFResultSetTransformer.m
//  Induction
//
//  Created by Mattt Thompson on 12/04/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EMFResultSetSerializer.h"

@implementation EMFResultSetSerializer

+ (NSString *)CSVFromResultSet:(id <DBResultSet>)resultSet
          fromRecordsAtIndexes:(NSIndexSet *)recordsIndexSet
                    withFields:(NSArray *)fields
                stringEncoding:(NSStringEncoding)stringEncoding
{
    return [self tabulatedStringFromResultSet:resultSet fromRecordsAtIndexes:recordsIndexSet withFields:fields showHeaders:YES delimiter:@"," enclosingString:nil NULLToken:@"NULL" stringEncoding:stringEncoding];
}


+ (NSString *)TSVFromResultSet:(id <DBResultSet>)resultSet
          fromRecordsAtIndexes:(NSIndexSet *)recordsIndexSet
                    withFields:(NSArray *)fields
                stringEncoding:(NSStringEncoding)stringEncoding
{
    return [self tabulatedStringFromResultSet:resultSet fromRecordsAtIndexes:recordsIndexSet withFields:fields showHeaders:YES delimiter:@"\t" enclosingString:nil NULLToken:@"NULL" stringEncoding:stringEncoding];
}

+ (NSString *)tabulatedStringFromResultSet:(id <DBResultSet>)resultSet
                      fromRecordsAtIndexes:(NSIndexSet *)recordsIndexSet
                                withFields:(NSArray *)fields
                               showHeaders:(BOOL)showHeaders
                                 delimiter:(NSString *)delimiter
                           enclosingString:(NSString *)enclosingString
                                 NULLToken:(NSString *)NULLToken
                            stringEncoding:(NSStringEncoding)stringEncoding
{    
    NSString *escapeString = [NSString stringWithFormat:@"\\%@", enclosingString];
    NSMutableArray *mutableLines = [NSMutableArray arrayWithCapacity:[recordsIndexSet count]];
    
    if (showHeaders) {
        NSMutableArray *mutableValues = [NSMutableArray arrayWithCapacity:[fields count]];
        [fields enumerateObjectsUsingBlock:^(id field, NSUInteger idx, BOOL *stop) {
            NSString *value = field;
            if (enclosingString) {
                value = [value stringByReplacingOccurrencesOfString:enclosingString withString:escapeString];
                value = [NSString stringWithFormat:@"\"%@\"", value];
            }
            [mutableValues addObject:value];
        }];
        
        [mutableLines addObject:[mutableValues componentsJoinedByString:delimiter]];
    }
    
    [[resultSet recordsAtIndexes:recordsIndexSet] enumerateObjectsUsingBlock:^(id record, NSUInteger idx, BOOL *stop) {
        NSMutableArray *mutableValues = [NSMutableArray arrayWithCapacity:[fields count]];
        [fields enumerateObjectsUsingBlock:^(id field, NSUInteger idx, BOOL *stop) {
            NSString *value = [[record valueForKey:field] description] ?: NULLToken;
            if (enclosingString) {
                value = [value stringByReplacingOccurrencesOfString:enclosingString withString:escapeString];
                value = [[enclosingString stringByAppendingString:value] stringByAppendingString:enclosingString];
            }
            [mutableValues addObject:value];
        }];
        
        [mutableLines addObject:[mutableValues componentsJoinedByString:delimiter]];
    }];
    
    return [mutableLines componentsJoinedByString:@"\n"];
}

+ (NSString *)JSONFromResultSet:(id <DBResultSet>)resultSet
           fromRecordsAtIndexes:(NSIndexSet *)recordsIndexSet
                     withFields:(NSArray *)fields
                 stringEncoding:(NSStringEncoding)stringEncoding
{
    NSMutableArray *mutableRecords = [NSMutableArray arrayWithCapacity:[recordsIndexSet count]];
    [[resultSet recordsAtIndexes:recordsIndexSet] enumerateObjectsUsingBlock:^(id record, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *mutableKeyedValues = [NSMutableDictionary dictionary];
        [fields enumerateObjectsUsingBlock:^(id field, NSUInteger idx, BOOL *stop) {
            [mutableKeyedValues setValue:[record valueForKey:field] forKey:field];
        }];
        [mutableRecords addObject:mutableKeyedValues];
    }];
        
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:mutableRecords options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
}

+ (NSString *)XMLFromResultSet:(id <DBResultSet>)resultSet
          fromRecordsAtIndexes:(NSIndexSet *)recordsIndexSet
                    withFields:(NSArray *)fields
                stringEncoding:(NSStringEncoding)stringEncoding
{
    NSXMLElement *recordsElement = [[NSXMLElement alloc] initWithName:@"records"];
    [[resultSet recordsAtIndexes:recordsIndexSet] enumerateObjectsUsingBlock:^(id record, NSUInteger idx, BOOL *stop) {
        NSXMLElement *recordElement = [[NSXMLElement alloc] initWithName:@"record"];
        [fields enumerateObjectsUsingBlock:^(id field, NSUInteger idx, BOOL *stop) {
            [recordElement addChild:[[NSXMLElement alloc] initWithName:field stringValue:[record valueForKey:field]]];
        }];
        [recordsElement addChild:recordElement];
    }];
    
    NSXMLElement *rootElement = [recordsElement childCount] == 1 ? [[recordsElement children] lastObject] : recordsElement;
    [rootElement detach];
    
    return [[NSXMLDocument documentWithRootElement:rootElement] description];
}

@end
