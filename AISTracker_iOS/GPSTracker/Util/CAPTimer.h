//


#import <Foundation/Foundation.h>

@interface CAPTimer : NSObject

+ (void)initWithGCD:(int)timeValue beginState:(void (^)())begin endState:(void (^)(int seconds))end;

@end
