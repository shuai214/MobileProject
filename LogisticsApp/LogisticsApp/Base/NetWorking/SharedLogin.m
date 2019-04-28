//
//  SharedLogin.m
//  ChinaScpetDistributor
//
//  Created by 曹帅 on 2018/9/27.
//  Copyright © 2018年 capaipai. All rights reserved.
//

#import "SharedLogin.h"
#import "HttpRequest.h"
@implementation SharedLogin
static SharedLogin* _instance = nil;
+(instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    return _instance ;
}

+(id) allocWithZone:(struct _NSZone *)zone
{
    return [SharedLogin shareInstance] ;
}

-(id) copyWithZone:(struct _NSZone *)zone
{
    return [SharedLogin shareInstance] ;
}
- (void)login{
    NSString *loginUrl = [NSString stringWithFormat:@"%@%@",APP_URL,LOGIN_URL];
    NSString *userName = [CSAccountTool getUserName];
    if (userName.length <= 0) return;
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    NSString *str1 = [CSAccountTool getPassword];
    NSString *pwd = [str1 aci_encryptWithAES];
    [mDic setObject:[CSAccountTool getUserName] forKey:@"username"];
    [mDic setObject:pwd forKey:@"password"];
    [mDic setObject:@"true" forKey:@"login"];
    [mDic setObject:@"true" forKey:@"mobileLogin"];
    HttpRequest *request = [HttpRequest sharedInstance];
    [request postWithURLString:loginUrl parameters:mDic success:^(id responseObject) {
        id jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (jsonDic == nil) return ;
        NSData *jsonData = [jsonDic[@"data"] dataUsingEncoding:NSUTF8StringEncoding];
        id dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dict);
        if ([dict isKindOfClass:[NSDictionary class]]) {
            [CSSessionManager saveSession:dict[@"sessionId"]];
            self.uid = dict[@"id"];
            self.name = dict[@"name"];
            self.sessionid = dict[@"sessionId"];
            NSString *signKey = dict[@"signKey"];
            self.md5_KEY = [signKey aci_decryptWithAES];
            if (![ValidationSignature validationSignature:jsonDic]) return;
        }
    } failure:^(NSError *error) {
        
    }];
//    dispatch_async(dispatch_queue_create(0, 0), ^{
//        [MyRequest POST:loginUrl withParameters:mDic CacheTime:10 isLoadingView:@"" success:^(id responseObject, BOOL succe, id jsonDic) {
//            if (jsonDic == nil) return ;
//            NSData *jsonData = [jsonDic[@"data"] dataUsingEncoding:NSUTF8StringEncoding];
//            id dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//            NSLog(@"%@",dict);
//            if ([dict isKindOfClass:[NSDictionary class]]) {
//                [CSSessionManager saveSession:dict[@"sessionId"]];
//                self.uid = dict[@"id"];
//                self.name = dict[@"name"];
//                self.sessionid = dict[@"sessionId"];
//                NSString *signKey = dict[@"signKey"];
//                self.md5_KEY = [signKey aci_decryptWithAES];
//                if (![ValidationSignature validationSignature:jsonDic]) return;
//            }
//        } failure:^(NSError *error) {
//            
//        }];
//    });
}
@end
