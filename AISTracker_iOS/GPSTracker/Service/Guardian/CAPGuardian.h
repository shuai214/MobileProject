//
//  CAPGuardian.h
//  GPSTracker
//
//  Created by WeifengYao on 7/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPBaseJSON.h"

@interface CAPGuardianProfile : CAPBaseJSON
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatarPath;
@property (nonatomic, copy) NSString *avatarBaseURL;
@property (nonatomic, copy) NSString *locale;
@property (nonatomic, copy) NSString *gender;
@end

@interface CAPGuardian : CAPBaseJSON
@property (nonatomic, copy) NSString *guardianID;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, strong) CAPGuardianProfile *profile;
@end
