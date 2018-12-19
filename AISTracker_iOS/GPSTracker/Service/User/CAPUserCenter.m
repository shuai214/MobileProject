//
//  CAPUserCenter.m
//  GPSTracker
//
//  Created by WeifengYao on 3/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPUserCenter.h"
#import "CAPUserService.h"
#import "CAPNotifications.h"
#import "CAPUserDefaults.h"
#import "CAPCrypto.h"
#import "CAPFetchUserProfileResponse.h"

static NSString* const kLastLoginUser = @"kLastLoginUser";

@interface CAPUserCenter ()
@property (nonatomic, strong) CAPUser *user;
@property (nonatomic, strong) CAPUserService *userService;
@end

@implementation CAPUserCenter

+ (instancetype)center {
    static id instance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    NSLog(@"[%@ setup]", [self class]);
    self.userService = [[CAPUserService alloc] init];
}

- (NSString *)getUserID {
    return self.user.account.userID;
}

- (NSString *)getNickname {
    if(self.user.profile.firstName) {
        return self.user.profile.firstName;
    } else {
        return self.user.account.username;
    }
}

- (NSURL *)getAvatarURL {
    if(self.user.profile.avatarBaseUrl && self.user.profile.avatarPath) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", self.user.profile.avatarBaseUrl, self.user.profile.avatarPath]];
    }
    return nil;
}

- (NSString *)getAccessToken {
    return self.user.oauth.accessToken;
}

- (BOOL) getLogon {
    return (self.user != nil);
}

- (NSUInteger)getDeviceCount {
    return self.user.devices.count;
}

- (NSString *)getLanguage {
    return self.user.setting.language;
}

- (void)fetchProfile {
    NSLog(@"[%@ fetchProfile]", [self class]);
    __weak typeof(self)weakSelf = self;
    [self.userService fetchProfile:^(id response) {
        CAPFetchUserProfileResponse *res = response;
        if(res.isSucceed) {
            if(weakSelf.user) {
                res.result.oauth = weakSelf.user.oauth;
                res.result.lastLoggedAt = weakSelf.user.lastLoggedAt;
                res.result.setting = weakSelf.user.setting;
            }
            weakSelf.user = res.result;
            [weakSelf saveUser];
            [weakSelf notifyUserProfileChange];
        }
    }];
}

- (void)updateNickname:(CAPServiceReply)reply {
    //TODO
}

- (void)updateAvatar:(CAPServiceReply)reply {
    //TODO
}

- (void)updateLanguage:(CAPServiceReply)reply {
    //TODO
}

- (void)logout:(CAPServiceResponse)reply {
    __weak typeof(self)weakSelf = self;
    [self.userService signOut:^(CAPResponse *res) {
        if(res.isSucceed) {
            [weakSelf deleteUser];
            [weakSelf notifyLogout];
        }
        reply(res);
    }];
}

- (void)loadUser {
    NSLog(@"[%@ loadUser]", [self class]);
    NSData *encodedData = [CAPUserDefaults dataForKey:kLastLoginUser];
    if(encodedData) {
        NSData *rawData = [CAPCrypto decryptWithAES256Key:@"cl902" data:encodedData];
        if(rawData) {
            NSError *error;
            CAPUser *user = [[CAPUser alloc] initWithData:rawData error:&error];
            if(error) {
                NSLog(@"ERROR: decode user data %@", error);
            } else {
                self.user = user;
                NSLog(@"Current user: %@", self.user);
                [self notifyLogin];
                [self fetchProfile];
            }
        } else {
            NSLog(@"ERROR:loaded user data is nil");
        }
    } else {
        NSLog(@"[%@ no last login user data]", [self class]);
    }
}

- (void)saveUser {
    [CAPUserDefaults setObject:[self.user toJSONData] forKey:kLastLoginUser];
}

- (void)deleteUser {
    [CAPUserDefaults removeObjectForKey:kLastLoginUser];
}

- (void)notifyLogin {
    [CAPNotifications notify:kNotificationLogin];
}

- (void)notifyLogout {
    [CAPNotifications notify:kNotificationLogout];
}

- (void)notifyUserProfileChange {
    [CAPNotifications notify:kNotificationUserProfileChange];
}

- (void)notifyLanguageChange {
    [CAPNotifications notify:kNotificationLanguageChange];
}

@end

