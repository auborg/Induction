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

#import "SMTabBar.h"
#import "SMTabBarItem.h"
#import "DMPaletteContainer.h"
#import "DMPaletteSectionView.h"

@implementation EMFVisualizeViewController {
    DMPaletteContainer *_paletteContainer;
}

- (void)awakeFromNib {
    SMTabBarItem *item0 = [[SMTabBarItem alloc] initWithImage:nil tag:0];
    SMTabBarItem *item1 = [[SMTabBarItem alloc] initWithImage:nil tag:1];

    self.tabBar.items = @[item0, item1];
    
    
    _paletteContainer = [[DMPaletteContainer alloc] initWithFrame:self.statisticsBox.bounds];
    
    DMPaletteSectionView *summarySectionView = [[DMPaletteSectionView alloc] initWithContentView:[[NSView alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, 200.0f, 200.0f)] andTitle:NSLocalizedString(@"Summary", nil)];
    _paletteContainer.sectionViews = @[summarySectionView];
    
    self.statisticsBox.contentView = _paletteContainer;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];    
}

@end
