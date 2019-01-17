//
//  CAPGuardianInvitationViewController.m
//  GPSTracker
//
//  Created by WeifengYao on 2/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPGuardianInvitationViewController.h"
#import "CAPDeviceService.h"
@interface CAPGuardianInvitationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@end

@implementation CAPGuardianInvitationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请";
    [self loadDeviceShareInfo];
}

- (void)loadDeviceShareInfo{
    self.deviceLabel.text = [NSString stringWithFormat:@"设备ID:%@",self.device.deviceID];
    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
    [gApp showHUD:@"正在处理,请稍后..."];
    [deviceService shareDevice:self.device.deviceID reply:^(CAPHttpResponse *response) {
        NSLog(@"%@",response);
        NSDictionary *dict = response.data;
        if ([[response.data objectForKey:@"code"] integerValue] == 200){
            [self creatCodeImage:[dict objectForKey:@"result"]];
            [gApp hideHUD];
        }else{
            [gApp hideHUD];
            [CAPAlertView initAlertWithContent:[dict objectForKey:@"message"] okBlock:^{
                
            } alertType:AlertTypeNoClose];
        }
        
    }];
}

- (void)refreshLocalizedString {
    
}

- (IBAction)onOkButtonClicked:(id)sender {
    
}

- (void)creatCodeImage:(NSString *)string{
    //创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //过滤器恢复默认
    [filter setDefaults];
    //将NSString格式转化成NSData格式
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [filter setValue:data forKeyPath:@"inputMessage"];
    //获取二维码过滤器生成的二维码
    CIImage *image = [filter outputImage];
    
    //将获取到的二维码添加到imageview上
    self.qrImageView.image =[self createNonInterpolatedUIImageFormCIImage:image withSize: self.qrImageView.frame.size.height];
}

/**
   *  根据CIImage生成指定大小的UIImage
   *
   *  @param image CIImage
   *  @param size  图片宽度
   */
 - (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size{
     CGRect extent = CGRectIntegral(image.extent);
     CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
     
     // 1.创建bitmap;
     size_t width = CGRectGetWidth(extent) * scale;
     size_t height = CGRectGetHeight(extent) * scale;
     CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
     CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
     CIContext *context = [CIContext contextWithOptions:nil];
     CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
     CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
     CGContextScaleCTM(bitmapRef, scale, scale);
     CGContextDrawImage(bitmapRef, extent, bitmapImage);
     // 2.保存bitmap到图片
     CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
     CGContextRelease(bitmapRef);
     CGImageRelease(bitmapImage);
     return [UIImage imageWithCGImage:scaledImage];
}
@end
