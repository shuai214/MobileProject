//
//  CAPSelectableCollectionCell.h
//  Ruyi
//
//  Created by user on 8/21/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "CAPCollectionCell.h"

@protocol CAPSelectableCollectionCellDelegate

-(void)onCollectionCellSelectionChanged:(id)sender;

@end

@interface CAPSelectableCollectionCell : CAPCollectionCell
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) id<CAPSelectableCollectionCellDelegate> delegate;

@end
