//
//  CAPImages.h
//  Neptu
//
//  Created by WeifengYao on 20/10/2017.
//  Copyright © 2017 capelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAPImages : NSObject
+ (UIImage *_Nullable)resizeImage:(UIImage *_Nonnull)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;
+ (NSData *_Nullable)thumbDataFromImage:(UIImage *_Nonnull)image;
+ (NSData *_Nullable)thumbDataFromData:(NSData *_Nonnull)imageData;
+ (NSData *_Nullable)thumbDataAtVideoURL:(NSURL *_Nonnull)videoURL;

+ (UIImage *_Nullable)thumbImageFromImage:(UIImage *_Nonnull)image;

+ (UIImage *_Nullable)imageFromColor:(UIColor *_Nonnull)color size:(CGSize)size;

+ (UIImage *_Nullable)maskImage:(UIImage *_Nullable)image withColor:(UIColor *_Nullable)color;

- (UIImage *_Nullable)imageFromBase64:(NSString *_Nonnull)base64String;
@end
