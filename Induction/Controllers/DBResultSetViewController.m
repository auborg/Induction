//
//  DBDataSourceTableViewController.m
//  Kirin
//
//  Created by Mattt Thompson on 12/02/15.
//  Copyright (c) 2012年 Heroku. All rights reserved.
//

#import "DBResultSetViewController.h"
#import "EMFExportWindowController.h"

#import "DateCell.h"

#import "EMFResultSetSerializer.h"

static CGFloat const kDBResultSetOutlineViewDefaultFontSize = 12.0f;
static CGFloat const kDBResultSetOutlineViewMinimumFontSize = 8.0f;
static CGFloat const kDBResultSetOutlineViewMaximumFontSize = 36.0f;
static NSString * const kDBResultSetOutlineViewFontSize = @"com.induction.result-set.font-size";

@interface NSOutlineView (Induction)
@property (assign) CGFloat fontSize;

- (void)resetFontSize;
- (void)replaceOutlineTableColumnWithTableColumn:(NSTableColumn *)tableColumn;
@end

@implementation NSOutlineView (Induction)

- (CGFloat)fontSize {
    if ([self.tableColumns count] > 0) {
        return [[[[self outlineTableColumn] dataCell] font] pointSize];
    }
    
    return kDBResultSetOutlineViewDefaultFontSize;
}

- (void)setFontSize:(CGFloat)fontSize {
    self.rowHeight = self.rowHeight - (self.fontSize - fontSize);
    for (NSTableColumn *tableColumn in self.tableColumns) {
        [[tableColumn dataCell] setFont:[NSFont systemFontOfSize:fontSize]];
    }
    
    [[NSUserDefaults standardUserDefaults] setFloat:fontSize forKey:kDBResultSetOutlineViewFontSize];
    
    [self setNeedsDisplay];
}

- (void)resetFontSize {
    CGFloat fontSize = [[NSUserDefaults standardUserDefaults] floatForKey:kDBResultSetOutlineViewFontSize];
    if (fontSize == 0.0f) {
        fontSize = kDBResultSetOutlineViewDefaultFontSize;
    }
    
    self.fontSize = fontSize;
}

- (void)replaceOutlineTableColumnWithTableColumn:(NSTableColumn *)tableColumn {
    NSTableColumn *outlineTableColumn = [self outlineTableColumn];
    [self setOutlineTableColumn:tableColumn];
    [self removeTableColumn:outlineTableColumn];
}
@end

#pragma mark -

@interface DBResultSetViewController () {
@private
    __strong NSArray *_records;
    
    __strong EMFExportWindowController *_exportWindowController;
}

@property (readonly) NSArray *selectedRecords;
@property (readonly) id <DBRecord> clickedRecord;
@property (readonly) id clickedValue;

- (void)doubleClick:(id)sender;

@end

@implementation DBResultSetViewController
@synthesize outlineView = _outlineView;
@synthesize popover = _popover;

- (void)awakeFromNib {
    [self.outlineView setNextResponder:self];
    [self setNextResponder:[self.outlineView enclosingScrollView]];
    
    [self.outlineView resetFontSize];
    [self.outlineView setDoubleAction:@selector(doubleClick:)];
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (NSArray *)selectedRecords {
    return [_records objectsAtIndexes:[self.outlineView selectedRowIndexes]];
}

- (id <DBRecord>)clickedRecord {
    if ([self.outlineView clickedRow] >= 0) {
        return [_records objectAtIndex:[self.outlineView clickedRow]];
    }
    
    return nil;
}

- (id)clickedValue {
    id <DBRecord> record = self.clickedRecord;
    if (record && [self.outlineView clickedColumn] >= 0) {
        return [record valueForKey:[[self.outlineView.tableColumns objectAtIndex:[self.outlineView clickedColumn]] identifier]];
    }
    
    return nil;
}

#pragma mark - NSViewController

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    if (!representedObject) {
        _records = [NSArray array];
        [self.outlineView reloadData];
        
        return;
    }
    
    NSArray *tableColumns = [[self.outlineView tableColumns] mutableCopy];
    for (NSTableColumn *tableColumn in tableColumns) {
        if (![tableColumn isEqual:[self.outlineView outlineTableColumn]]) {
            [self.outlineView removeTableColumn:tableColumn];
        }
    }
    
    NSIndexSet *columnIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.representedObject numberOfFields])];
    [columnIndexSet enumerateIndexesUsingBlock:^(NSUInteger columnIndex, BOOL *stop) {
        NSTableColumn *tableColumn = [[NSTableColumn alloc] initWithIdentifier:[(id <DBResultSet>)self.representedObject identifierForTableColumnAtIndex:columnIndex]];
        [[tableColumn headerCell] setTitle:[tableColumn identifier]];
        [tableColumn setEditable:NO];
        [[tableColumn dataCell] setFont:[[[self.outlineView outlineTableColumn] dataCell] font]];

        if ([(id <DBResultSet>)self.representedObject respondsToSelector:@selector(valueTypeForTableColumnAtIndex:)]) {
            DBValueType type = [(id <DBResultSet>)self.representedObject valueTypeForTableColumnAtIndex:columnIndex];
            if (type != DBStringValue) {
                switch (type) {
                    case DBBooleanValue: {
                        NSButtonCell *buttonCell = [[NSButtonCell alloc] init];
                        [buttonCell setButtonType:NSSwitchButton];
                        [buttonCell setAllowsMixedState:NO];
                        [buttonCell setTitle:nil];
                        [buttonCell setImagePosition:NSImageOnly];
                        [tableColumn setDataCell:buttonCell]; 
                        break;
                    }
                    case DBDecimalValue:
                    case DBIntegerValue:
                        [[[tableColumn dataCell] formatter] setNumberStyle:NSNumberFormatterDecimalStyle];
                        [[tableColumn dataCell] setAlignment:NSRightTextAlignment];
                        break;
                    case DBDateValue: {
                        
                        static NSDateFormatter * _DBResultSetDateFormatter = nil;
                        static dispatch_once_t onceToken;
                        dispatch_once(&onceToken, ^{
                            _DBResultSetDateFormatter = [[NSDateFormatter alloc] init];
                            [_DBResultSetDateFormatter setDateStyle:NSDateFormatterMediumStyle];
                            [_DBResultSetDateFormatter setTimeStyle:NSDateFormatterNoStyle];
                        });
                        
                        [[tableColumn dataCell] setFormatter:_DBResultSetDateFormatter];
                        break;
                    };
                    case DBDateTimeValue: {
                        DateCell *dateCell = [[DateCell alloc] init];
                        [tableColumn setDataCell:dateCell];
                        break;
                    }
                    default:
                        break;
                }
            }
        }
        
        if ([(id <DBResultSet>)self.representedObject respondsToSelector:@selector(sortDescriptorPrototypeForTableColumnAtIndex:)]) {
            [tableColumn setSortDescriptorPrototype:[(id <DBResultSet>)self.representedObject sortDescriptorPrototypeForTableColumnAtIndex:columnIndex]];
        }
        
        [self.outlineView addTableColumn:tableColumn];
        
        if (columnIndex == 0) {
            [self.outlineView replaceOutlineTableColumnWithTableColumn:tableColumn];
        }
    }];
    
    _records = [(id <DBResultSet>)self.representedObject recordsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [(id <DBResultSet>)self.representedObject numberOfRecords])]];
    
    NSSortDescriptor *outlineTableColumnSortDescriptorPrototype = [[self.outlineView outlineTableColumn] sortDescriptorPrototype];
    if (outlineTableColumnSortDescriptorPrototype) {
        [self.outlineView setSortDescriptors:[NSArray arrayWithObject:outlineTableColumnSortDescriptorPrototype]];
    }
    
    [self.outlineView reloadData];
    [self.outlineView expandItem:nil expandChildren:YES];
    
    for (NSTableColumn *tableColumn in self.outlineView.tableColumns) {
        if ([tableColumn respondsToSelector:@selector(sizeToCells)]) {
            [tableColumns performSelector:@selector(sizeToCells)];
        }
    }
}

#pragma mark - IBAction

- (IBAction)doubleClick:(id)sender {
    if (self.clickedValue) {
        self.popover.contentViewController.representedObject = self.clickedValue;
        [self.popover showRelativeToRect:[self.outlineView frameOfCellAtColumn:[self.outlineView clickedColumn] row:[self.outlineView clickedRow]] ofView:self.outlineView preferredEdge:NSMaxYEdge];
    }
}

- (IBAction)copy:(id)sender {
    [self copyAsTSV:sender];
}

- (IBAction)copyAsJSON:(id)sender {
    NSString *JSON = [EMFResultSetSerializer JSONFromResultSet:self.representedObject fromRecordsAtIndexes:[self.outlineView selectedRowIndexes] withFields:[[self.outlineView tableColumns] valueForKeyPath:@"identifier"] stringEncoding:NSUTF8StringEncoding];

    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    [pasteboard declareTypes: [NSArray arrayWithObject:NSPasteboardTypeString] owner:nil];
    [pasteboard setString:JSON forType:NSPasteboardTypeString];
}

- (IBAction)copyAsXML:(id)sender {
    NSString *XML = [EMFResultSetSerializer XMLFromResultSet:self.representedObject fromRecordsAtIndexes:[self.outlineView selectedRowIndexes] withFields:[[self.outlineView tableColumns] valueForKeyPath:@"identifier"] stringEncoding:NSUTF8StringEncoding];
    
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    [pasteboard declareTypes: [NSArray arrayWithObject:NSPasteboardTypeString] owner:nil];
    [pasteboard setString:XML forType:NSPasteboardTypeString];
}

- (IBAction)copyAsTSV:(id)sender {
    NSString *TSV = [EMFResultSetSerializer TSVFromResultSet:self.representedObject fromRecordsAtIndexes:[self.outlineView selectedRowIndexes] withFields:[[self.outlineView tableColumns] valueForKeyPath:@"identifier"] showHeaders:YES enclosingString:nil stringEncoding:NSUTF8StringEncoding];

    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    [pasteboard declareTypes: [NSArray arrayWithObjects:NSPasteboardTypeTabularText, NSPasteboardTypeString, nil] owner:nil];
    [pasteboard setString:TSV forType:NSPasteboardTypeTabularText];
    [pasteboard setString:TSV forType:NSPasteboardTypeString];
}

- (IBAction)exportDocument:(id)sender {
    if (!_exportWindowController) {
        _exportWindowController = [[EMFExportWindowController alloc] initWithWindowNibName:@"EMFExportWindow"];
    }
    
    [NSApp beginSheet:_exportWindowController.window modalForWindow:self.view.window modalDelegate:self didEndSelector:@selector(didEndSheet:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction)incrementFontSize:(id)sender {
    [self.outlineView setFontSize:fminf([self.outlineView fontSize] + 1.0f, kDBResultSetOutlineViewMaximumFontSize)];
}

- (IBAction)decrementFontSize:(id)sender {
    [self.outlineView setFontSize:fmaxf([self.outlineView fontSize] - 1.0f, kDBResultSetOutlineViewMinimumFontSize)];
}

#pragma mark - NSApp Delegate Methods

- (void)didEndSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    [NSApp endSheet:sheet returnCode:returnCode];
    [sheet orderOut:self];
}

#pragma mark - NSOutlineViewDataSource

- (id)outlineView:(NSOutlineView *)outlineView 
            child:(NSInteger)index 
           ofItem:(id)item
{
    if (!item) {
        return [_records objectAtIndex:index];
    } else {
        return [[(id <DBRecord>)item children] objectAtIndex:index];
    }
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView 
  numberOfChildrenOfItem:(id)item 
{
    if (!item) {
        return [_records count];
    } else {
        if ([item respondsToSelector:@selector(children)]) {
            return [[(id <DBRecord>)item children] count];
        } else {
            return 0;
        }
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView 
   isItemExpandable:(id)item 
{
    return [self outlineView:outlineView numberOfChildrenOfItem:item] > 0;
}

- (id)outlineView:(NSOutlineView *)outlineView 
objectValueForTableColumn:(NSTableColumn *)tableColumn 
           byItem:(id)item
{
    if (![tableColumn identifier]) {
        return nil;
    }
    
    return [(id <DBRecord>)item valueForKey:[tableColumn identifier]];
}

#pragma mark - NSOutlineViewControllerDelegate

- (void)outlineView:(NSOutlineView *)outlineView 
sortDescriptorsDidChange:(NSArray *)oldDescriptors 
{
    _records = [_records sortedArrayUsingDescriptors:outlineView.sortDescriptors];
    [self.outlineView reloadData];
}

- (void)outlineView:(NSOutlineView *)outlineView 
    willDisplayCell:(id)cell 
     forTableColumn:(NSTableColumn *)tableColumn 
               item:(id)item 
{
    if ([[item valueForKey:[tableColumn identifier]] isEqual:[NSNull null]]) {
        [cell setStringValue:@"NULL"];
    }
}

@end
