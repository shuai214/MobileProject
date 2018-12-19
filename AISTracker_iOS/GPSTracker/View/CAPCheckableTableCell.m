//
//  CAPCheckableTableCell.m
//  Ruyi
//
//  Created by user on 8/21/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import "CAPCheckableTableCell.h"

@implementation CAPCheckableTableCell
- (IBAction)onCheckButtonClicked:(id)sender {
    self.checkButton.selected = !self.checkButton.selected;
    NSLog(@"checked: %d", self.checkButton.selected);
    if(self.delegate) {
        [self.delegate onCellSelectionChanged:self];
    }
}
@end
