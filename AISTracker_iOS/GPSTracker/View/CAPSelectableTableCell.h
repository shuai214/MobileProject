//
//  CAPSelectableTableCell.h
//  Ruyi
//
//  Created by user on 8/16/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "CAPTableCell.h"

@protocol CAPSelectableTableCellDelegate

-(void)onCellSelectionChanged:(id)sender;

@end

@interface CAPSelectableTableCell : CAPTableCell
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<CAPSelectableTableCellDelegate> delegate;
@end
