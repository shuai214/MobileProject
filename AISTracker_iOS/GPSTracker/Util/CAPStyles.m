//
//  CAPViewStyles.m
//  Neptu
//
//  Created by WeifengYao on 13/4/2018.
//  Copyright © 2018 capelabs. All rights reserved.
//

#import "CAPStyles.h"
#import "CAPColors.h"
#import "CAPImages.h"

@implementation CAPStyles

+ (void)applyStyleForTableCell:(UITableViewCell *)cell {
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [CAPColors white1];
}

+ (void)applyStyleForSearchBar:(UISearchBar *)searchBar {
    UIImage *image = [CAPImages imageFromColor:[CAPColors white] size:searchBar.bounds.size];
    [searchBar setSearchFieldBackgroundImage:image forState:UIControlStateNormal];
    searchBar.showsCancelButton = NO;
    UITextField *searchField = [searchBar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:[CAPColors white3]];
        searchField.layer.cornerRadius = 14.0f;
        searchField.layer.borderColor = nil;
        searchField.layer.borderWidth = 0.0;
        searchField.layer.masksToBounds = YES;
    }
}

+ (void)applyStyleForNoteEditor:(UITextView *)textView {
    textView.layoutManager.allowsNonContiguousLayout = NO;
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    textView.textColor = [CAPColors black];
    textView.backgroundColor = [CAPColors yellow2];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 0;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:16],
                                 NSForegroundColorAttributeName:[CAPColors black],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.typingAttributes = attributes;
}
@end
