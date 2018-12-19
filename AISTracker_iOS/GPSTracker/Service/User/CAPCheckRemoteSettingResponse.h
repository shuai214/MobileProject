//
//  CAPCheckRemoteSupportResponse.h
//  Neptu
//
//  Created by WeifengYao on 22/9/2017.
//  Copyright © 2017 capelabs. All rights reserved.
//

#import "CAPResponse.h"
#import "CAPRemoteSetting.h"

@interface CAPCheckRemoteSettingResponse : CAPResponse
//@property (nonatomic, copy) NSString *isDebug;
//@property (nonatomic, assign) BOOL isDebug;
//@property (nonatomic, assign) NSInteger isDebug;
@property (nonatomic, strong) CAPRemoteSetting *result;
@end
