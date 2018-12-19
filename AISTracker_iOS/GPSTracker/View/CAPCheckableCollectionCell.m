//
//  CAPCheckableCollectionCell.m
//  Ruyi
//
//  Created by user on 8/21/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "CAPCheckableCollectionCell.h"

@interface CAPCheckableCollectionCell ()

@end

@implementation CAPCheckableCollectionCell
- (IBAction)onContentButtonClicked:(id)sender {
    [self onCheckButtonClicked:sender];
}

- (IBAction)onCheckButtonClicked:(id)sender {
    NSLog(@"onCheckButtonClicked");
    self.checkButton.selected = !self.checkButton.selected;
    if(self.delegate) {
        [self.delegate onCollectionCellSelectionChanged:self];
    }
}

@end
