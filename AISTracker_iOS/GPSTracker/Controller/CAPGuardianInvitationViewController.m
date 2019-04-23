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
    self.title = CAPLocalizedString(@"invitation");
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",self.device.setting.avatarBaseUrl,self.device.setting.avatarPath]] placeholderImage:GetImage(@"ic_default_avatar_new")];
    [self loadDeviceShareInfo];
    [self.okButton setBackgroundColor:[CAPColors red]];
    [self.okButton setTitle:CAPLocalizedString(@"share") forState:UIControlStateNormal];
}

- (void)loadDeviceShareInfo{
    self.deviceLabel.text = [NSString stringWithFormat:@"%@%@",CAPLocalizedString(@"device_id"),self.device.deviceID];
    CAPDeviceService *deviceService = [[CAPDeviceService alloc] init];
    [capgApp showHUD:CAPLocalizedString(@"loading")];
    [deviceService shareDevice:self.device.deviceID reply:^(CAPHttpResponse *response) {
        NSLog(@"%@",response);
        NSDictionary *dict = response.data;
        if ([[response.data objectForKey:@"code"] integerValue] == 200){
            [self creatCodeImage:[dict objectForKey:@"result"]];
            [capgApp hideHUD];
        }else{
            [capgApp hideHUD];
            [CAPAlertView initAlertWithContent:[dict objectForKey:@"message"] okBlock:^{
                
            } alertType:AlertTypeNoClose];
        }
        
    }];
}

- (void)refreshLocalizedString {
    
}

- (IBAction)onOkButtonClicked:(id)sender {
    NSLog(@"111");
    [self sharePicture];
}
//
- (BOOL)sharePicture{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    UIImage *image = self.qrImageView.image;
    [pasteboard setData:UIImageJPEGRepresentation(image, 0.9) forPasteboardType:@"public.jpeg"];
    NSString *contentType =@"image";

    NSString *contentKey = [pasteboard.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSString *urlString = [NSString stringWithFormat:@"line://msg/%@/%@",contentType, contentKey];
    NSURL *url = [NSURL URLWithString:urlString];

    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        return [[UIApplication sharedApplication] openURL:url];
    }else{
        return NO;
    }

}
/*
 固件调整多一些。
 1.绑定设备 -- 设置名字，号码  绑定的时候：先不做绑定，先走下一屏幕的名字，号码，再去绑定用户。
 2.设备的上下线不及时，设备的状态反馈不及时。deviceList 接口返回的消息与mqtt反馈的不一致。
 解决方案：发送一个mqtt请求，3次左右查看设备的状态。
 3.cell和wifi定位 //--- A gps有效 ，V是cell有效。
 
 4.
 */

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
