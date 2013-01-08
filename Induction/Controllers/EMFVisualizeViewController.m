// EMFVisualizeViewController.m
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

#import "EMFVisualizeViewController.h"

#import "DBAdapter.h"
#import "EMFResultSetViewController.h"
#import "EMFSummaryViewController.h"

#import "SMTabBar.h"
#import "SMTabBarItem.h"
#import "DMPaletteContainer.h"
#import "DMPaletteSectionView.h"

#import "DBAdapter.h"

@implementation EMFVisualizeViewController {
    DMPaletteContainer *_paletteContainer;
}

- (void)awakeFromNib {
    SMTabBarItem *item0 = [[SMTabBarItem alloc] initWithImage:[NSImage imageNamed:@"detail.png"] tag:0];
    SMTabBarItem *item1 = [[SMTabBarItem alloc] initWithImage:[NSImage imageNamed:@"chart.png"] tag:1];

    self.tabBar.items = @[item0, item1];
    
    
    _paletteContainer = [[DMPaletteContainer alloc] initWithFrame:self.statisticsBox.bounds];
    
    self.statisticsBox.contentView = _paletteContainer;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    if (![representedObject conformsToProtocol:@protocol(DBResultSet)]) {
        return;
    }

    NSMutableArray *mutableSectionViews = [NSMutableArray array];
    NSIndexSet *fieldIndexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, [representedObject numberOfFields])];
    [fieldIndexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSString *identifier = [representedObject identifierForTableColumnAtIndex:idx];
        EMFSummaryViewController *summaryViewController = [[EMFSummaryViewController alloc] initWithNibName:@"EMFSummaryView" bundle:nil];
        summaryViewController.valueType = [representedObject valueTypeForTableColumnAtIndex:idx];
        DMPaletteSectionView *sectionView = [[DMPaletteSectionView alloc] initWithContentView:summaryViewController.view andTitle:identifier];
        [mutableSectionViews addObject:sectionView];
    }];
    _paletteContainer.sectionViews = mutableSectionViews;
    self.statisticsBox.contentView = _paletteContainer;
}

@end
