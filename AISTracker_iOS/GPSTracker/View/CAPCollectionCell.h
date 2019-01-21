//
//  CAPCollectionCell.h
//  Ruyi
//
//  Created by user on 8/21/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAPCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *currentImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, copy) NSString *representedIdentifier;
@end
