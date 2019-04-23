//
//  CAPUserPresenter.m
//  GPSTracker
//
//  Created by WeifengYao on 3/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPUserPresenter.h"
#import "CAPUserCenter.h"
#import "CAPUser.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation CAPUserPresenter

- (BOOL)assureNickname:(NSString *)nickname {
    if(nickname && nickname.length > 1) {
        //TODO
        return YES;
    }
    return NO;
}

- (void)presentAvatar:(UIImageView *)view {
    NSURL *avatarURL = [CAPUserCenter center].avatarURL;
    if(avatarURL) {
        [view sd_setImageWithURL:avatarURL];
    }
}

- (void)presentLanguage:(UIPickerView *)pickerView {
    NSUInteger row = 0;
    NSString *language = [CAPUserCenter center].language;
    if(language && language.length > 0) {
        if([language containsString:@"zh"] || [language containsString:@"CN"]) {
            row = 1;
        } else if([language containsString:@"th"] || [language containsString:@"TH"]) {
            row = 2;
        } else if([language containsString:@"en"] || [language containsString:@"US"]) {
            row = 3;
        }
    }
//    [pickerView selectRow:row inComponent:0 animated:YES];
}

- (void)changeNickname:(NSString *)nickname {
    //TODO
}

- (void)changeAvatar:(CAPFileItem *)file {
    //TODO
}

- (void)changeLanguage:(NSUInteger)selectedRow {
    //TODO
    NSArray *languages = @[@"Unknown", @"zh-CN", @"th-TH", @"en-US"];
    if(selectedRow < languages.count) {
        NSString *language = languages[selectedRow];
        if(![language isEqualToString:[CAPUserCenter center].language]) {
//            [[CAPUserCenter center] changeLanguage:language];
        }
    }
}

- (void)logout {
    //TODO
}

- (NSArray *)getLanguages {
    return @[@"System", @"Chinese", @"English", @"Thailand"];
}

@end
