// EMFPaginator.m
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

#import "EMFPaginator.h"

@interface EMFPaginator () {
@private
    NSRange _maximumRange;
    NSUInteger _pageSize;
    NSUInteger _currentPage;
}
@end

@implementation EMFPaginator
@synthesize currentPage = _currentPage;

- (id)initWithNumberOfIndexes:(NSUInteger)numberOfIndexes
                     pageSize:(NSUInteger)pageSize
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _maximumRange = NSMakeRange(0, numberOfIndexes);
    _pageSize = MIN(pageSize, numberOfIndexes);
    _currentPage = 0;
    
    return self;
}

- (NSString *)localizedDescriptionOfCurrentRange {
    if (_maximumRange.length == 0) {
        return @"";
    }
    
    return [NSString stringWithFormat:NSLocalizedString(@"%lu — %lu", @"Pagination Range Format"), [self currentRange].location, NSMaxRange([self currentRange])];
}

- (NSUInteger)numberOfIndexes {
    return NSMaxRange(_maximumRange);
}

- (NSRange)currentRange {
    return NSIntersectionRange(NSMakeRange(_currentPage * _pageSize, _pageSize), _maximumRange);
}

- (BOOL)hasPreviousPage {
    return _currentPage > 0;
}

- (NSRange)previousPage {
    [self willChangeValueForKey:@"currentPage"];
    _currentPage = MAX(_currentPage - 1, 0); 
    [self didChangeValueForKey:@"currentPage"];
    
    return [self currentRange];
}

- (BOOL)hasNextPage {
    return NSMaxRange([self currentRange]) < NSMaxRange(_maximumRange);
}

- (NSRange)nextPage {
    [self willChangeValueForKey:@"currentPage"];
    _currentPage = MIN(_currentPage + 1, ceil([self numberOfIndexes] / _pageSize)); 
    [self didChangeValueForKey:@"currentPage"];
    
    return [self currentRange];
}

@end
