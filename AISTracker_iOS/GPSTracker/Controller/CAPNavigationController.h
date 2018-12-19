//
//  CAPNavigationController.h
//  Ruyi
//
//  Created by user on 7/12/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CAPPopOnBackButtonDelegate
- (BOOL)shouldPopOnBackButton;
@end

@interface CAPNavigationController : UINavigationController
@property (nonatomic, assign) BOOL supportLandscape;

@property (nonatomic, weak) id<CAPPopOnBackButtonDelegate> popDelegate;
@end
