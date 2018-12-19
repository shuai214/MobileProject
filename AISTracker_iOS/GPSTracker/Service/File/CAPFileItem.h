//
//  CAPFileItem.h
//  GPSTracker
//
//  Created by WeifengYao on 7/11/2018.
//  Copyright © 2018 Capelabs. All rights reserved.
//

#import "CAPBaseJSON.h"

@interface CAPFileItem : CAPBaseJSON
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSUInteger size;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *baseURL;
@property (nonatomic, copy) NSString *deleteURL;
@end
