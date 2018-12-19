//
//  CAPFeedback.h
//  GPSTracker
//
//  Created by WeifengYao on 7/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPBaseJSON.h"

@interface CAPFeedback : CAPBaseJSON
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *contact;
@end
