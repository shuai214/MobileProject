//
//  CAPFileUpload.h
//  GPSTracker
//
//  Created by capaipai@sina.com on 2019/1/24.
//  Copyright © 2019年 Capelabs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAPFileUpload : NSObject
@property(nonatomic,strong)void (^failureBlock)();
@property(nonatomic,strong)void (^successBlockObject)(id object);
- (void)uploadRecording:(id)recordingFile withImageIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
