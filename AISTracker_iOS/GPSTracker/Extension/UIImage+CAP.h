//
//  UIImage+CAP.h
//  GPSTracker
//
//  Created by user on 9/27/16.
//  Copyright © 2016 capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CAP)
- (void)setImageWithSignature:(NSData *)signature placeholderImage:(UIImage *)placeholder;
@end
