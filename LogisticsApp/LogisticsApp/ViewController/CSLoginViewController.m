//
//  CSLoginViewController.m
//  ChinaScpetDistributor
//
//  Created by 曹帅 on 2018/9/13.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "CSLoginViewController.h"
//#import "CSModifyPwdViewController.h"
#import "MQVerCodeImageView.h"
@interface CSLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (copy, nonatomic)  NSString *modify;
@property (assign, nonatomic) BOOL isValidate;
@property (assign, nonatomic)CGFloat yzLayout;
@property (assign, nonatomic)CGFloat yzLabelLayout;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yanzhengLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mimaLayout;
@property (weak, nonatomic) IBOutlet UIImageView *codeView;

@end

@implementation CSLoginViewController
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//}
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//}
- (IBAction)getValidateCode:(id)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navigationItem.title = @"密码登录";
    self.pwdField.secureTextEntry = YES;
//    //设置一张空的图片
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    //清除边框，设置一张空的图片
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    UIButton *leftBtn = [[UIButton alloc] init];
    if (self.motai.length != 0) {
        [leftBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    }else{
        [leftBtn setImage:[UIImage imageNamed:@"login_back"] forState:UIControlStateNormal];
        [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    }
    
    leftBtn.frame = CGRectMake(0, 0, 33, 33);
    if (@available(ios 11.0,*)) {
        leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
        leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10,0, 0);
    }
    [leftBtn addTarget:self action:@selector(leftBarBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];;
    //创建UIBarButtonSystemItemFixedSpace
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将两个BarButtonItem都返回给NavigationItem
    self.navigationItem.leftBarButtonItems = @[spaceItem,leftBarBtn];
    self.yzLayout = self.yanzhengLayout.constant;
    self.yzLabelLayout = self.mimaLayout.constant;
    self.imgView.hidden = YES;
    self.yanzhengLabel.hidden = YES;
    self.lineView.hidden = YES;
    self.codeView.hidden = YES;
    self.mimaLayout.constant = self.yzLabelLayout / 3;
    self.yanzhengLayout.constant = 0;
    
}

- (void)leftBarBtnClicked:(UIButton *)button{
    if (self.modify.length > 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (self.motai.length != 0) {
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:Login_Nitify object:nil userInfo:nil];
        }];
    }
}
#pragma mark ----- 是否需要输入验证码！！
- (void)heheda{
    [UIView animateWithDuration:0.37 animations:^{
        self.imgView.hidden = NO;
        self.yanzhengLabel.hidden = NO;
        self.lineView.hidden = NO;
        self.codeView.hidden = NO;
        self.mimaLayout.constant = self.yzLabelLayout;
        self.yanzhengLayout.constant = self.yzLayout;
    }];
}

- (IBAction)loginAction:(UIButton *)sender {
    NSLog(@"%@",self.userField.text);
    if (self.userField.text.length <= 0) {
        [LoadingView showAlertHUD:@"请输入用户名" duration:0.37];
        return;
    }
    if (self.pwdField.text.length <= 0)  {
        [LoadingView showAlertHUD:@"请输入密码" duration:0.37];
        return;
    }
    NSString *loginUrl = [NSString stringWithFormat:@"%@%@",APP_URL,LOGIN_URL];
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    NSString *str3 = [self.pwdField.text aci_encryptWithAES];
    [mDic setObject:self.userField.text forKey:@"username"];
    [mDic setObject:str3 forKey:@"password"];
    if (self.isValidate) {
        [mDic setObject:self.yanzhengLabel.text forKey:@"validateCode"];
    }
    [mDic setObject:@"true" forKey:@"login"];
    [mDic setObject:@"true" forKey:@"mobileLogin"];
//    dispatch_async(dispatch_queue_create(0, 0), ^{
        [MyRequest POST:loginUrl withParameters:mDic CacheTime:10 isLoadingView:@"" success:^(id responseObject, BOOL succe, id jsonDic) {
            if (jsonDic == nil) return ;
            if([jsonDic isKindOfClass:[NSDictionary class]]){
                dispatch_queue_t queue = dispatch_get_main_queue();
                dispatch_async(queue, ^{
                    [LoadingView showAlertHUD:jsonDic[@"msg"] duration:0.37];
                });
                NSData *jsonData = [jsonDic[@"data"] dataUsingEncoding:NSUTF8StringEncoding];
                id dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    [CSSessionManager saveSession:dict[@"sessionId"]];
                    [CSAccountTool saveAccount:@[self.userField.text,self.pwdField.text]];
                    SharedLogin *login = [SharedLogin shareInstance];
                    NSString *signKey = dict[@"signKey"];
                    login.md5_KEY = [signKey aci_decryptWithAES];
                    login.uid = dict[@"id"];
                    login.name = dict[@"name"];
                    login.sessionid = dict[@"sessionId"];
                    if ([[jsonDic objectForKey:@"status"] integerValue] == 1003) {
                        if ([[dict objectForKey:@"isValidateCodeLogin"] integerValue] == 1) {
                            [self getValidate];
                            [self heheda];
                            self.isValidate = true;
                        }
                    }else if ([[jsonDic objectForKey:@"status"] integerValue] == 0000){
                        dispatch_async(queue, ^{
                            self.isValidate = NO;
                            if (self.modify.length > 0) {
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            }else{
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                            if (self.motai.length != 0) {
                                [self dismissViewControllerAnimated:YES completion:^{
                                    [[NSNotificationCenter defaultCenter] postNotificationName:Login_Nitify object:login.sessionid userInfo:nil];
                                }];
                            }
                        });
                    }
                    if (![ValidationSignature validationSignature:jsonDic]) return;
                }
                
            }
        } failure:^(NSError *error) {
            
        }];
//    });
}

- (void)getValidate{
    NSString *loginUrl = [NSString stringWithFormat:@"%@%@",APP_URL,Validate_Code];
    [MyRequest POST:loginUrl withParameters:nil CacheTime:10 isLoadingView:@"" success:^(id responseObject, BOOL succe, id jsonDic) {
        UIImage *img = [UIImage imageWithData:responseObject];
        [self.codeView setImage:img];
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)pushModify:(UIButton *)sender {
//    [self.navigationController pushViewController:[CSModifyPwdViewController new] animated:YES];
}


@end
