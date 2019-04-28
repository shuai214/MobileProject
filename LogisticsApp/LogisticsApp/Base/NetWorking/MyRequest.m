//
//  MyRequest.m
//  KuaiShouPay
//
//  Created by 曹帅 on 16/12/17.
//  Copyright © 2016年 北京联禾众邦科技有限公司. All rights reserved.
//
#define IsNilString(__String)   (__String==nil || [__String isEqualToString:@"null"] || [__String isEqualToString:@"<null>"])

#import "MyRequest.h"
#import "EGOCache.h"
#import "Reachability.h"
//#import "GDataXMLNode.h"
@implementation MyRequest
+ (void)netWorkingDone{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
+ (AFHTTPSessionManager *)ManagerSetHearderandToken{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    dispatch_queue_t queue = dispatch_get_main_queue();
    //使用异步函数封装三个任务
    dispatch_async(queue, ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;

    //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //    //如果报接受类型不一致请替换一致text/html或别的
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    return manager;
}


+(void)GET:(NSString *)url CacheTime:(NSInteger)CacheTime isLoadingView:(NSString *)loadString success:(SuccessCallBack)success failure:(FailureCallBack)failure
{
    
    url = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    EGOCache *cache = [EGOCache globalCache];
    
    if (![self interStatus]) {
        //无网络
        NSString *interNetError = [url stringByAppendingString:@"interNetError"];
        
        NSData *responseObject = [cache dataForKey:interNetError];
        
        if (responseObject.length != 0) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            success(responseObject,YES,dict);
            [self netWorkingDone];
            return;
        }
    }
    
    AFHTTPSessionManager *manager = [self ManagerSetHearderandToken];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = CacheTime;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    if ([cache hasCacheForKey:url]) {
        
        NSData *responseObject = [cache dataForKey:url];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        success(responseObject,YES,dict);
        
        return;
    }
    
    if (!IsNilString(loadString)) {
        
        [LoadingView showProgressHUD:loadString];
        
    }
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!IsNilString(loadString)) {
            [LoadingView hideProgressHUD];
        }
        id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        BOOL succe = NO;
        success(responseObject,succe,data);
        [self netWorkingDone];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (!IsNilString(loadString)) {
            [LoadingView hideProgressHUD];
        }
        [LoadingView showAlertHUD:@"网络没有连接上" duration:2];
        
        failure(error);
        [self netWorkingDone];
    }];
}

+ (void)POST:(NSString *)url withParameters:(NSDictionary *)parmas CacheTime:(NSInteger)CacheTime isLoadingView:(NSString *)loadString success:(SuccessCallBack)success failure:(FailureCallBack)failure
{
    
    url = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    EGOCache *cache = [EGOCache globalCache];
    
    if (![self interStatus]) {
        
        //无网络
        NSString *interNetError = [url stringByAppendingString:@"interNetError"];
        
        NSData *responseObject = [cache dataForKey:interNetError];
        
        if ((responseObject.length != 0)) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            success(responseObject,YES,dict);
            [self netWorkingDone];

            return;
            
        }
    }
    
    AFHTTPSessionManager *manager = [self ManagerSetHearderandToken];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = CacheTime;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    //获取主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    if ([cache hasCacheForKey:url]) {
        NSData *responseObject = [cache dataForKey:url];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        success(responseObject,YES,dict);
        [self netWorkingDone];
        return;
    }
    
    if (!IsNilString(loadString)) {
       
        //使用异步函数封装三个任务
        dispatch_async(queue, ^{
            [LoadingView showProgressHUD:loadString];
        });
    }
    
    NSString *strJson= nil;
    NSMutableDictionary *json = [NSMutableDictionary dictionary];

    if (parmas != nil) {
        strJson = [self dictionaryToJson:parmas];
        [json setObject:strJson forKey:@"json"];
    }
    [manager POST:url parameters:parmas progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!IsNilString(loadString)) {
            //使用异步函数封装三个任务
            dispatch_async(queue, ^{
                [LoadingView hideProgressHUD];
            });
        }
        BOOL succe = NO;

        id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([data isKindOfClass:[NSArray class]]) {
            NSArray *dictArr = data;
            if (kArrayIsEmpty(dictArr)) {
                succe = NO;
            }else{
                succe = YES;
            }
        }
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict =  data;
            if ([[dict objectForKey:@"code"] isKindOfClass:[NSNumber class]]) {
                if ([[dict valueForKey:@"code"] isEqualToNumber:@100]) {
                    succe = YES;
                } else
                    succe = NO;
            } else if ([[dict objectForKey:@"code"] isKindOfClass:[NSString class]]) {
                if ([[dict valueForKey:@"code"] isEqualToString:@"100"]) {
                    succe = YES;
                } else
                    succe = NO;
            }
        }
       
        NSString *interNetError = [url stringByAppendingString:@"interNetError"];
        [cache setData:responseObject forKey:interNetError];
        
        if (CacheTime && succe){
            
            if (CacheTime == -1) {
                [cache setData:responseObject forKey:url];
            }else{
                [cache setData:responseObject forKey:url withTimeoutInterval:CacheTime];
            }
        }
        success(responseObject,succe,data);
        [self netWorkingDone];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (!IsNilString(loadString)) {
            //使用异步函数封装三个任务
            dispatch_async(queue, ^{
                [LoadingView hideProgressHUD];
            });
        }
        //使用异步函数封装三个任务
        dispatch_async(queue, ^{
            [LoadingView showAlertHUD:@"请求失败" duration:2];
        });
        failure(error);
        [self netWorkingDone];
    }];
}

//同步判断网络状态，可能在部分iOS系统会卡顿iOS9 iOS10没有问题
+(BOOL)interStatus
{
    BOOL status ;
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus status22 = [reach currentReachabilityStatus];
    
    // 判断网络状态
    if (status22 == ReachableViaWiFi) {
        
        status = YES;
        //无线网
    } else if (status22 == ReachableViaWWAN) {
        status = YES;
        //移动网
    } else {
        status = NO;
        
    }
    
    return status;
}

//将参数转成json字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}






@end
