//
//  JKPhoneBrowserFunction.m
//  JKPhotoBrowser
//
//  Created by 蒋委员长 on 2020/3/11.
//  Copyright © 2020 溪枫狼. All rights reserved.
//

#import "JKPhoneBrowserFunction.h"
#import <stdatomic.h>
#include <sys/mount.h>
#import <sys/utsname.h>


@implementation JKPhoneBrowserFunction

inline UIColor * JKPhotoManager_Color(long hexValue) {
    long hex = hexValue & 0xFFFFFFFF;
    int a = (0xff000000 & hex) >> 24;
    int r = (0x00ff0000 & hex) >> 16;
    int g = (0x0000ff00 & hex) >> 8;
    int b = (0x000000ff & hex) >> 0;
    if (hex <= 0xFFFFFF) {
        return [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1];
    } else {
        return [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a/255.f];
    }
}

inline CGFloat JKPhotoManager_ScreenWidth(void) {
    return MIN(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
}

inline CGFloat JKPhotoManager_ScreenHeight(void) {
    return MAX(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
}

inline UIWindow * JKPhotoManager_KeyWindow(void) {
    NSArray <UIWindow *>* windows = [UIApplication sharedApplication].windows;
    __block UIWindow * visible = nil;
    [windows enumerateObjectsUsingBlock:^(UIWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isKeyWindow && obj.isHidden == false) {
            visible = obj;
            *stop = true;
        }
    }];
    return visible ? visible : windows.lastObject;
}

inline UIUserInterfaceIdiom JKPhotoManager_UserInterfaceIdiom(void) {
    if (@available(iOS 13.0, *)) {
        return [UIDevice.currentDevice userInterfaceIdiom];
    } else {
        return UI_USER_INTERFACE_IDIOM();
    }
}

inline BOOL JKPhotoManager_iPhoneX(void) {
    if (JKPhotoManager_UserInterfaceIdiom() != UIUserInterfaceIdiomPhone) {
        return false;
    } else {
        BOOL isiPhoneX =  [_getDeviceName() hasPrefix:@"iPhone 11"] || [_getDeviceName() hasPrefix:@"iPhone 12"] || [_getDeviceName() hasPrefix:@"iPhone X"];
        if (isiPhoneX) return true;
        
        if (@available(iOS 11.0, *)) {
            if (@available(iOS 13.0, *)) {
                return JKPhotoManager_StatusBarHeight() > 43.f;
            } else {
                CGFloat topPadding = UIApplication.sharedApplication.keyWindow.safeAreaInsets.top;
                return topPadding > 20.f;
            }
        } else {
            return false;
        }
    }
}

inline CGFloat JKPhotoManager_StatusBarHeight(void) {
    if (@available(iOS 13.0, *)) {
        return CGRectGetHeight(JKPhotoManager_KeyWindow().windowScene.statusBarManager.statusBarFrame);
    } else {
        return CGRectGetHeight(UIApplication.sharedApplication.statusBarFrame);
    }
}

inline CGSize JKPhotoManager_MainScreenSize() {
    return [UIScreen mainScreen].bounds.size;
}



inline CGFloat JKPhotoManager_AdaptiveW(CGFloat width) {
    if (_is_iPad()) {
        return width * JKPhotoManager_ScreenWidth() / 768.0;
    } else {
        return width * JKPhotoManager_ScreenWidth() / 375.0;
    }
}


#pragma mark - Private

static BOOL _is_iPad(void) {
    return JKPhotoManager_UserInterfaceIdiom() == UIUserInterfaceIdiomPad;
}

static NSString * _jk_deviceName;
/// 机型
static NSString * _getDeviceName() {
    if (!_jk_deviceName) {
        struct utsname systemInfo;
        uname(&systemInfo);
        __auto_type platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        _jk_deviceName = _deviceNameWithPlatform(platform);
    }
    return _jk_deviceName;
}

/// https://www.theiphonewiki.com/wiki/Models
/// 2020.10.21更新
static NSString * _deviceNameWithPlatform(NSString * platform) {
    NSDictionary * devicePlatform = @{
        @"i386":@"iPhone Simulator",
        @"x86_64":@"iPhone Simulator",
    };
    if (JKPhotoManager_UserInterfaceIdiom() == UIUserInterfaceIdiomPad) {
        devicePlatform = @{
            @"i386":@"iPhone Simulator",
            @"x86_64":@"iPhone Simulator",
            
            @"iPad1,1":@"iPad 1",
            @"iPad2,1":@"iPad 2",
            @"iPad2,2":@"iPad 2",
            @"iPad2,3":@"iPad 2",
            @"iPad2,4":@"iPad 2",
            @"iPad3,1":@"iPad (3rd)",
            @"iPad3,2":@"iPad (3rd)",
            @"iPad3,3":@"iPad (3rd)",
            @"iPad3,4":@"iPad (4th)",
            @"iPad3,5":@"iPad (4th)",
            @"iPad3,6":@"iPad (4th)",
            @"iPad4,1":@"iPad Air",
            @"iPad4,2":@"iPad Air",
            @"iPad4,3":@"iPad Air",
            @"iPad5,3":@"iPad Air 2",
            @"iPad5,4":@"iPad Air 2",
            @"iPad6,7":@"iPad Pro (12.9-inch)",
            @"iPad6,8":@"iPad Pro (12.9-inch)",
            @"iPad6,3":@"iPad Pro (9.7-inch)",
            @"iPad6,4":@"iPad Pro (9.7-inch)",
            @"iPad6,11":@"iPad (5th)",
            @"iPad6,12":@"iPad (5th)",
            @"iPad7,1":@"iPad Pro (12.9-inch) (2nd)",
            @"iPad7,2":@"iPad Pro (12.9-inch) (2nd)",
            @"iPad7,3":@"iPad Pro (10.5-inch)",
            @"iPad7,4":@"iPad Pro (10.5-inch)",
            @"iPad7,5":@"iPad (6th)",
            @"iPad7,6":@"iPad (6th)",
            @"iPad7,11":@"iPad (7th)",
            @"iPad7,12":@"iPad (7th)",
            @"iPad11,6":@"iPad (8th)",
            @"iPad11,7":@"iPad (8th)",
            
            @"iPad8,1":@"iPad Pro (11-inch)",
            @"iPad8,2":@"iPad Pro (11-inch)",
            @"iPad8,3":@"iPad Pro (11-inch)",
            @"iPad8,4":@"iPad Pro (11-inch)",
            @"iPad8,9":@"iPad Pro (11-inch) (2nd)",
            @"iPad8,10":@"iPad Pro (11-inch) (2nd)",
            
            @"iPad8,5":@"iPad Pro (12.9-inch) (3rd)",
            @"iPad8,6":@"iPad Pro (12.9-inch) (3rd)",
            @"iPad8,7":@"iPad Pro (12.9-inch) (3rd)",
            @"iPad8,8":@"iPad Pro (12.9-inch) (3rd)",
            @"iPad8,11":@"iPad Pro (12.9-inch) (4th)",
            @"iPad8,12":@"iPad Pro (12.9-inch) (4th)",
            
            @"iPad11,3":@"iPad Air (3rd)",
            @"iPad11,4":@"iPad Air (3rd)",
            @"iPad13,1":@"iPad Air (4th)",
            @"iPad13,2":@"iPad Air (4th)",
            
            @"iPad2,5":@"iPad Mini",
            @"iPad2,6":@"iPad Mini",
            @"iPad2,7":@"iPad Mini",
            @"iPad4,4":@"iPad Mini 2",
            @"iPad4,5":@"iPad Mini 2",
            @"iPad4,6":@"iPad Mini 2",
            @"iPad4,7":@"iPad Mini 3",
            @"iPad4,8":@"iPad Mini 3",
            @"iPad4,9":@"iPad Mini 3",
            @"iPad5,1":@"iPad Mini 4",
            @"iPad5,2":@"iPad Mini 4",
            @"iPad11,1":@"iPad Mini (5th)",
            @"iPad11,2":@"iPad Mini (5th)",
        };
        
    } else if (JKPhotoManager_UserInterfaceIdiom() == UIUserInterfaceIdiomPhone) {
        devicePlatform = @{
            @"i386":@"iPhone Simulator",
            @"x86_64":@"iPhone Simulator",
            
            @"iPhone13,1":@"iPhone 12 mini",
            @"iPhone13,2":@"iPhone 12",
            @"iPhone13,3":@"iPhone 12 Pro",
            @"iPhone13,4":@"iPhone 12 Pro Max",
            
            @"iPhone9,1":@"iPhone 7",
            @"iPhone9,3":@"iPhone 7",
            @"iPhone9,2":@"iPhone 7 Plus",
            @"iPhone9,4":@"iPhone 7 Plus",
            
            @"iPhone10,1":@"iPhone 8",
            @"iPhone10,4":@"iPhone 8",
            @"iPhone10,2":@"iPhone 8 Plus",
            @"iPhone10,5":@"iPhone 8 Plus",
            
            @"iPhone10,3":@"iPhone X",
            @"iPhone10,6":@"iPhone X",
            @"iPhone11,8":@"iPhone XR",
            @"iPhone11,2":@"iPhone XS",
            @"iPhone11,6":@"iPhone XS Max",
            @"iPhone11,4":@"iPhone XS Max",
            @"iPhone12,1":@"iPhone 11",
            @"iPhone12,3":@"iPhone 11 Pro",
            @"iPhone12,5":@"iPhone 11 Pro Max",
            
            @"iPhone7,2":@"iPhone 6",
            @"iPhone7,1":@"iPhone 6 Plus",
            @"iPhone8,1":@"iPhone 6s",
            @"iPhone8,2":@"iPhone 6s Plus",
            
            @"iPhone8,4":@"iPhone SE",
            @"iPhone12,8":@"iPhone SE (2nd)",
            
            @"iPhone5,1":@"iPhone 5",
            @"iPhone5,2":@"iPhone 5",
            @"iPhone5,3":@"iPhone 5c",
            @"iPhone5,4":@"iPhone 5c",
            @"iPhone6,1":@"iPhone 5s",
            @"iPhone6,2":@"iPhone 5s",
            
            @"iPhone1,1":@"iPhone 2G",
            @"iPhone1,2":@"iPhone 3G",
            @"iPhone2,1":@"iPhone 3GS",
            @"iPhone3,1":@"iPhone 4",
            @"iPhone3,2":@"iPhone 4",
            @"iPhone3,3":@"iPhone 4",
            @"iPhone4,1":@"iPhone 4S",
        };
    }
    NSString * result = [devicePlatform objectForKey:platform];
    if (result && result.length) {
        return result;
    }
    return platform;
}


@end
