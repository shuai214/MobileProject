//
//  CAPFileUpload.m
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/24.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import "CAPFileUpload.h"
#import <AFNetworking/AFNetworking.h>
@interface CAPFileUpload()
@property (strong, nonatomic) AFHTTPSessionManager *session;
@end
@implementation CAPFileUpload
- (AFHTTPSessionManager *)ManagerSetHearderandToken:(NSString *)access_token{
    self.session = [[AFHTTPSessionManager alloc] init];
    self.session.securityPolicy.allowInvalidCertificates = YES;
    self.session.securityPolicy.validatesDomainName = NO;
    
    AFHTTPRequestSerializer* requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:0];
    requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    requestSerializer.timeoutInterval = 60;
    [requestSerializer setValue:@"1234567890" forHTTPHeaderField:@"App-Key"];
    [requestSerializer setValue:@"1" forHTTPHeaderField:@"App-OS"]; //1-iOS, 2-android, 3-windows
    [requestSerializer setValue:[CAPPhones phoneModel] forHTTPHeaderField:@"App-OS-Model"];
    [requestSerializer setValue:[CAPPhones systemName] forHTTPHeaderField:@"App-OS-SDK"];
    [requestSerializer setValue:[CAPPhones systemVersion] forHTTPHeaderField:@"App-OS-Release"];
    [requestSerializer setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"] forHTTPHeaderField:@"App-Package-Name"];
    [requestSerializer setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"App-Version-Name"];
    [requestSerializer setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forHTTPHeaderField:@"App-Version-Code"];
    [requestSerializer setValue:@"143565456" forHTTPHeaderField:@"App-Install-Time"];
    [requestSerializer setValue:@"143565456" forHTTPHeaderField:@"App-Update-Time"];
    [requestSerializer setValue:[CAPPhones getUUIDString] forHTTPHeaderField:@"App-UDID"];
    [requestSerializer setValue:([CAPPhones isChineseLanguage] ? @"zh-CN" : @"en-US") forHTTPHeaderField:@"App-Language"];
    self.session.requestSerializer = requestSerializer;
    
    AFJSONResponseSerializer* responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:0];
    responseSerializer.removesKeysWithNullValues = YES;
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
    [requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", access_token] forHTTPHeaderField:@"Authorization"];
    self.session.responseSerializer = responseSerializer;
    return self.session;
}
- (void)uploadRecording:(id)recordingFile withImageIndex:(NSInteger)index{
    AFHTTPSessionManager *manager = [self ManagerSetHearderandToken:[CAPUserDefaults objectForKey:@"accessToken"] ? [CAPUserDefaults objectForKey:@"accessToken"]:@""];
    manager.requestSerializer.timeoutInterval = 15.0;
    [manager POST:@"Public/FileUpload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 上传filename
        if ([recordingFile isKindOfClass:[NSString class]]) {
            NSString * fileName = [NSString stringWithFormat:@"file%ld.mp3",(long)index];
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:recordingFile isDirectory:NO] name:@"file" fileName:fileName mimeType:@"audio/mpeg3" error:nil];
        }
        if ([recordingFile isKindOfClass:[UIImage class]]) {
            NSData * imageData = UIImagePNGRepresentation(recordingFile);
            // 上传的参数名
            NSString * Name = [NSString stringWithFormat:@"file"];
            // 上传filename
            NSString * fileName = [NSString stringWithFormat:@"file%ld.jpg",(long)index];
            
            [formData appendPartWithFileData:imageData name:Name fileName:fileName mimeType:@"image.jpg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
        if (self.successBlockObject) {
            self.successBlockObject(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure");
        if (self.failureBlock) {
            self.failureBlock();
        }
    }];
}
//https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=1500&type=restaurant&keyword=cruise&key=YOUR_API_KEY

- (void)getDeviceLoacl:(NSString *)latlng{//key=AIzaSyAD8FC9VKywHNyI6aJZPPb7wsdEQLgqBm4
    NSString *URLString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@&radius=1500&key=AIzaSyAD8FC9VKywHNyI6aJZPPb7wsdEQLgqBm4",latlng];
    AFHTTPSessionManager *manager = [self ManagerSetHearderandToken:[CAPUserDefaults objectForKey:@"accessToken"] ? [CAPUserDefaults objectForKey:@"accessToken"]:@""];
    manager.requestSerializer.timeoutInterval = 15.0;
    [manager GET:URLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        self.successBlockObject(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)getDeviceDetailLoacl:(NSDictionary *)parameter{
    NSString *URLString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/detail/json?reference=%@key=AIzaSyAD8FC9VKywHNyI6aJZPPb7wsdEQLgqBm4",[parameter mj_JSONString]];
    AFHTTPSessionManager *manager = [self ManagerSetHearderandToken:[CAPUserDefaults objectForKey:@"accessToken"] ? [CAPUserDefaults objectForKey:@"accessToken"]:@""];
    manager.requestSerializer.timeoutInterval = 15.0;
    [manager GET:URLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        self.successBlockObject(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)setSOSMobile:(CAPDevice *)device array:(id)array{
    NSString *URLString = [NSString stringWithFormat:@"%@%@%@",gCfg.rootURLString,@"Device/SOS/",device.deviceID];
    AFHTTPSessionManager *manager = [self ManagerSetHearderandToken:[CAPUserDefaults objectForKey:@"accessToken"] ? [CAPUserDefaults objectForKey:@"accessToken"]:@""];
    manager.requestSerializer.timeoutInterval = 15.0;
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT" URLString:URLString parameters:nil error:nil];
    [request addValue:@"application/json"forHTTPHeaderField:@"Content-Type"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:kNilOptions
                                                         error:nil];
    [request setHTTPBody:jsonData];
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *_Nonnull response, id _Nullable responseObject,NSError * _Nullable error){
        self.successBlockObject(responseObject);
    }] resume];
}
@end
