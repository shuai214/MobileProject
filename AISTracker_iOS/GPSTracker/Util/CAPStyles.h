//
//  CAPViewStyles.h
//  Neptu
//
//  Created by WeifengYao on 13/4/2018.
//  Copyright © 2018 capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAPStyles : NSObject
+ (void)applyStyleForTableCell:(UITableViewCell *)cell;
+ (void)applyStyleForSearchBar:(UISearchBar *)searchBar;
+ (void)applyStyleForNoteEditor:(UITextView *)textView;
@end
