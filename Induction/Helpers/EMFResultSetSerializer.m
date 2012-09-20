// EMFResultSetTransformer.m
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "EMFResultSetSerializer.h"

@implementation EMFResultSetSerializer

+ (NSString *)CSVFromResultSet:(NSArray *)records
                    withFields:(NSArray *)fields
                stringEncoding:(NSStringEncoding)stringEncoding
{
    return [self tabulatedStringFromRecords:records withFields:fields showHeaders:YES delimiter:@"," enclosingString:nil NULLToken:@"NULL" stringEncoding:stringEncoding];
}


+ (NSString *)TSVFromRecords:(NSArray *)records
                  withFields:(NSArray *)fields
              stringEncoding:(NSStringEncoding)stringEncoding
{
    return [self tabulatedStringFromRecords:records withFields:fields showHeaders:YES delimiter:@"\t" enclosingString:nil NULLToken:@"NULL" stringEncoding:stringEncoding];
}

+ (NSString *)tabulatedStringFromRecords:(NSArray *)records
                              withFields:(NSArray *)fields
                             showHeaders:(BOOL)showHeaders
                               delimiter:(NSString *)delimiter
                         enclosingString:(NSString *)enclosingString
                               NULLToken:(NSString *)NULLToken
                          stringEncoding:(NSStringEncoding)stringEncoding
{    
    NSString *escapeString = [NSString stringWithFormat:@"\\%@", enclosingString];
    NSMutableArray *mutableLines = [NSMutableArray arrayWithCapacity:[records count]];
    
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
    
    [records enumerateObjectsUsingBlock:^(id record, NSUInteger idx, BOOL *stop) {
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

+ (NSString *)JSONFromRecords:(NSArray *)records
                   withFields:(NSArray *)fields
               stringEncoding:(NSStringEncoding)stringEncoding
{
    NSMutableArray *mutableObjects = [NSMutableArray arrayWithCapacity:[records count]];
    [records enumerateObjectsUsingBlock:^(id record, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *mutableKeyedValues = [NSMutableDictionary dictionary];
        [fields enumerateObjectsUsingBlock:^(id field, NSUInteger idx, BOOL *stop) {
            [mutableKeyedValues setValue:[record valueForKey:field] forKey:field];
        }];
        [mutableObjects addObject:mutableKeyedValues];
    }];
    
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:mutableObjects options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
}

+ (NSString *)XMLFromRecords:(NSArray *)records
                  withFields:(NSArray *)fields
              stringEncoding:(NSStringEncoding)stringEncoding
{
    NSXMLElement *recordsElement = [[NSXMLElement alloc] initWithName:@"records"];
    [records enumerateObjectsUsingBlock:^(id record, NSUInteger idx, BOOL *stop) {
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
