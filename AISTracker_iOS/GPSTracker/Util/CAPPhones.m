//
//  CAPPhones.m
//  GPSTracker
//
//  Created by WeifengYao on 27/2/2017.
//  Copyright © 2017 capelabs. All rights reserved.
//

#import "CAPPhones.h"
#import <sys/utsname.h>

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <arpa/inet.h>


@implementation CAPPhones
+ (NSString *)phoneModel {
    return [UIDevice currentDevice].model;
}

+ (NSString *)phoneName {
    return [UIDevice currentDevice].name;
}

+ (NSString *)phoneType {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (NSString *)parsePhoneType:(NSString *)type {
    if ([type isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([type isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([type isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([type isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([type isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([type isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (GSM+CDMA)";
    if ([type isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (GSM)";
    if ([type isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (GSM+CDMA)";
    if ([type isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (GSM)";
    if ([type isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (GSM+CDMA)";
    if ([type isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([type isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([type isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([type isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([type isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([type isEqualToString:@"iPhone9,1"]) return @"国行/日版/港行iPhone 7";
    if ([type isEqualToString:@"iPhone9,2"]) return @"港行/国行iPhone 7 Plus";
    if ([type isEqualToString:@"iPhone9,3"]) return @"美版/台版iPhone 7";
    if ([type isEqualToString:@"iPhone9,4"]) return @"美版/台版iPhone 7 Plus";
    if ([type isEqualToString:@"iPhone10,1"]) return @"国行(A1863)/日行(A1906)iPhone 8";
    if ([type isEqualToString:@"iPhone10,4"]) return @"美版(Global/A1905)iPhone 8";
    if ([type isEqualToString:@"iPhone10,2"]) return @"国行(A1864)/日行(A1898)iPhone 8 Plus";
    if ([type isEqualToString:@"iPhone10,5"]) return @"美版(Global/A1897)iPhone 8 Plus";
    if ([type isEqualToString:@"iPhone10,3"]) return @"国行(A1865)/日行(A1902)iPhone X";
    if ([type isEqualToString:@"iPhone10,6"]) return @"美版(Global/A1901)iPhone X";
    
    if ([type isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if ([type isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if ([type isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if ([type isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if ([type isEqualToString:@"iPod5,1"]) return @"iPod Touch (5 Gen)";
    
    if ([type isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([type isEqualToString:@"iPad1,2"]) return @"iPad 3G";
    if ([type isEqualToString:@"iPad2,1"]) return @"iPad 2 (WiFi)";
    if ([type isEqualToString:@"iPad2,2"]) return @"iPad 2";
    if ([type isEqualToString:@"iPad2,3"]) return @"iPad 2 (CDMA)";
    if ([type isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([type isEqualToString:@"iPad2,5"]) return @"iPad Mini (WiFi)";
    if ([type isEqualToString:@"iPad2,6"]) return @"iPad Mini";
    if ([type isEqualToString:@"iPad2,7"]) return @"iPad Mini (GSM+CDMA)";
    if ([type isEqualToString:@"iPad3,1"]) return @"iPad 3 (WiFi)";
    if ([type isEqualToString:@"iPad3,2"]) return @"iPad 3 (GSM+CDMA)";
    if ([type isEqualToString:@"iPad3,3"]) return @"iPad 3";
    if ([type isEqualToString:@"iPad3,4"]) return @"iPad 4 (WiFi)";
    if ([type isEqualToString:@"iPad3,5"]) return @"iPad 4";
    if ([type isEqualToString:@"iPad3,6"]) return @"iPad 4 (GSM+CDMA)";
    if ([type isEqualToString:@"iPad4,1"]) return @"iPad Air (WiFi)";
    if ([type isEqualToString:@"iPad4,2"]) return @"iPad Air (Cellular)";
    if ([type isEqualToString:@"iPad4,4"]) return @"iPad Mini 2 (WiFi)";
    if ([type isEqualToString:@"iPad4,5"]) return @"iPad Mini 2 (Cellular)";
    if ([type isEqualToString:@"iPad4,6"]) return @"iPad Mini 2";
    if ([type isEqualToString:@"iPad4,7"]) return @"iPad Mini 3";
    if ([type isEqualToString:@"iPad4,8"]) return @"iPad Mini 3";
    if ([type isEqualToString:@"iPad4,9"]) return @"iPad Mini 3";
    if ([type isEqualToString:@"iPad5,1"]) return @"iPad Mini 4 (WiFi)";
    if ([type isEqualToString:@"iPad5,2"]) return @"iPad Mini 4 (LTE)";
    if ([type isEqualToString:@"iPad5,3"]) return @"iPad Air 2";
    if ([type isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
    if ([type isEqualToString:@"iPad6,3"]) return @"iPad Pro 9.7";
    if ([type isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7";
    if ([type isEqualToString:@"iPad6,7"]) return @"iPad Pro 12.9";
    if ([type isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9";
    if ([type isEqualToString:@"iPad6,11"]) return @"iPad 5 (WiFi)";
    if ([type isEqualToString:@"iPad6,12"]) return @"iPad 5 (Cellular)";
    if ([type isEqualToString:@"iPad7,1"]) return @"iPad Pro 12.9 inch 2nd gen (WiFi)";
    if ([type isEqualToString:@"iPad7,2"]) return @"iPad Pro 12.9 inch 2nd gen (Cellular)";
    if ([type isEqualToString:@"iPad7,3"]) return @"iPad Pro 10.5 inch (WiFi)";
    if ([type isEqualToString:@"iPad7,4"]) return @"iPad Pro 10.5 inch (Cellular)";
    
    if ([type isEqualToString:@"AppleTV2,1"]) return @"Apple TV 2";
    if ([type isEqualToString:@"AppleTV3,1"]) return @"Apple TV 3";
    if ([type isEqualToString:@"AppleTV3,2"]) return @"Apple TV 3";
    if ([type isEqualToString:@"AppleTV5,3"]) return @"Apple TV 4";
    
    if ([type isEqualToString:@"i386"]) return @"Simulator";
    if ([type isEqualToString:@"x86_64"]) return @"Simulator";
    
    return type;
}

+ (NSString *)systemName {
    return [UIDevice currentDevice].systemName;
}

+ (NSString *)systemVersion {
    return [UIDevice currentDevice].systemVersion;
    //return [NSString stringWithFormat:@"%@ %@", [[UIDevice currentDevice] systemVersion], [[UIDevice currentDevice] systemName]]
}

+ (BOOL)isiPhoneX {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *type = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSLog(@"phone type: %@", type);
//    return YES;
    return ([type isEqualToString:@"iPhone10,3"] || [type isEqualToString:@"iPhone10,6"]);
}

+ (BOOL)isChineseLanguage {
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(@"language: %@", language);
    return [language hasPrefix:@"zh-"];
}

+ (unsigned long long)totalPhoneSize {
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error:&error];
    if (dictionary) {
        NSNumber *sizeNumber = [dictionary objectForKey:NSFileSystemSize];
        return [sizeNumber unsignedLongLongValue];
    } else {
        NSLog(@"ERROR: obtaining phone total size failed %@", error);
        return 0;
    }
}

+ (unsigned long long)freePhoneSize {
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error:&error];
    if (dictionary) {
        NSNumber *freeNumber = [dictionary objectForKey:NSFileSystemFreeSize];
        return [freeNumber unsignedLongLongValue];
    } else {
        NSLog(@"ERROR: obtaining phone free size failed %@", error);
        return 0;
    }
}

+ (void)call:(NSString *)phoneNumber {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNumber]];
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:url options:[NSDictionary dictionary] completionHandler:^(BOOL success) {
        }];
    } else {
        [application openURL:url];
    }
}

+ (void)mailto:(NSString *)email {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", email]];
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:url options:[NSDictionary dictionary] completionHandler:^(BOOL success) {
        }];
    } else {
        [application openURL:url];
    }
}

+ (NSString *)macAddress {
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return [outstring uppercaseString];
}

+ (NSString *)deviceIPAddresses {
    
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    
    NSMutableArray *ips = [NSMutableArray array];
    
    int BUFFERSIZE = 4096;
    
    struct ifconf ifc;
    
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    
    struct ifreq *ifr, ifrcopy;
    
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            
            ifr = (struct ifreq *)ptr;
            int len = sizeof(struct sockaddr);
            
            if (ifr->ifr_addr.sa_len > len) {
                len = ifr->ifr_addr.sa_len;
            }
            
            ptr += sizeof(ifr->ifr_name) + len;
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            ifrcopy = *ifr;
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            
            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;
            
            NSString *ip = [NSString  stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            [ips addObject:ip];
        }
    }
    
    close(sockfd);
    NSString *deviceIP = @"";
    
    for (int i=0; i < ips.count; i++) {
        if (ips.count > 0) {
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
        }
    }
    return deviceIP;
}

+ (NSString *)getUUIDString {
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault , uuidRef);
    NSString *uuidString = [(__bridge NSString*)strRef stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(strRef);
    CFRelease(uuidRef);
    return uuidString;
}
@end
