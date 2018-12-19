//
//  UIImage+Size.m
//  GPSTracker
//
//  Created by Weifeng on 11/15/16.
//  Copyright © 2016 Capelabs. All rights reserved.
//

#import "UIImage+Size.h"

@implementation UIImage (Size)

- (UIImage *)resizeImage {
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(self.size.height / 2 , self.size.width / 2, self.size.height / 2, self.size.width / 2)];
}
@end
