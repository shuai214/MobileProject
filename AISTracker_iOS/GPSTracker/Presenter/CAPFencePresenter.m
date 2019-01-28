//
//  CAPFencePresenter.m
//  GPSTracker
//
//  Created by WeifengYao on 3/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPFencePresenter.h"
#import "CAPFenceService.h"
#import "CAPFenceList.h"
#import "CAPCoreData.h"
@interface CAPFencePresenter()
@property(nonatomic,assign)FenceType type;
@property(nonatomic,strong)NSMutableArray *activeFences;
@end
@implementation CAPFencePresenter

+ (instancetype)sharedCheckFence {
    static id instance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CAPFencePresenter alloc] init];
    });
    return instance;
}
- (void)getFenceList:(CAPDevice *)device deviceLocal:(CLLocationCoordinate2D)coordinate{
    self.activeFences = [NSMutableArray array];
    CAPWeakSelf(self);
    CAPFenceService *fenceService = [[CAPFenceService alloc] init];
    [fenceService fetchFence:device.deviceID reply:^(CAPHttpResponse *response) {
        NSLog(@"%@",response);
        CAPFenceList *fenceList = [CAPFenceList mj_objectWithKeyValues:response.data];
        if (fenceList.result.list.count == 0) {
            weakself.type = FenceTypeUnknow;
        }else{
            for (NSInteger i = 0; i < fenceList.result.list.count; i++) {
                List *list = fenceList.result.list[i];
                if ([list.status isEqualToString:@"1"]) {
                    [self.activeFences addObject:list];
                }
            }
            FenceType type = [self lisetnDeviceFence:coordinate withDevice:device];
        }
    }];
}

- (FenceType)lisetnDeviceFence:(CLLocationCoordinate2D)coordinate withDevice:(CAPDevice *)device{
    
    //第一个坐标
    CLLocation *current=[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    for (NSInteger i = 0;i < self.activeFences.count ; i++){
        List *list = self.activeFences[i];
        //第二个坐标
        CLLocation *before=[[CLLocation alloc] initWithLatitude:list.lat longitude:list.lng];
        // 计算距离
        CLLocationDistance meters=[current distanceFromLocation:before];
        NSInteger time = list.createdAt;
        
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:time];
        NSTimeInterval recordTime = [[NSDate date] timeIntervalSince1970];
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:recordTime];
        NSTimeInterval seconds = [date2 timeIntervalSinceDate:date];
        NSInteger minutes = seconds / 60;
        if([CAPUserDefaults objectForKey:@"uploadTimeInter"]){
            NSString *times = [CAPUserDefaults objectForKey:@"uploadTimeInter"];
           NSInteger integerTimes = [times integerValue];
            UIColor *color = nil;
            NSString *status = nil;
            if(minutes > (integerTimes / 60)){
                if (meters > list.range) {
                    status = CAPLocalizedString(@"message_type_out_fence");
                    color = [UIColor redColor];
                }else{
                    status = CAPLocalizedString(@"message_type_in_fence");
                    color = [UIColor greenColor];
                }
                [gApp showNotifyInfo:[NSString stringWithFormat:@"设备%@%@%@",device.name,status,list.name] backGroundColor:color];
                MQTTInfo *info = [[MQTTInfo alloc] init];
                info.deviceID = device.deviceID;
                info.time = seconds;
                info.message = [NSString stringWithFormat:@"设备%@%@",device.name,status];
                CAPCoreData *coreData = [CAPCoreData coreData];
                [coreData creatResource:@"GPSTracker"];
                [coreData insertData:info];
            }
        }
    }
    return self.type;
}
@end
