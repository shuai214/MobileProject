//
//  GPSTracker
//


#import <UIKit/UIKit.h>

@interface CAPAlertView : UIView
- (instancetype)initWithTitle:(NSString *)title messages:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;
/**
 *  视图显示
 */
-(void)show;
/**
 *  视图隐藏
 */
-(void)dismiss;

@end
