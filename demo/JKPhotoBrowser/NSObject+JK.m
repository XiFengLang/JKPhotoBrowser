//
//  NSObject+JK.m
//  上下文绘图
//
//  Created by 蒋委员长 on 17/2/13.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "NSObject+JK.h"
#import <objc/runtime.h>

@implementation NSObject (JK)

- (NSArray<NSString *> *)jk_declaredInstanceVariables{
    NSMutableArray * mutArray = [[NSMutableArray alloc] init];
    
    unsigned int propertiesCount = 0;
    
    Ivar * ivarList = class_copyIvarList(self.class, &propertiesCount);
    for (NSInteger index = 0; index < propertiesCount; index ++) {
        @autoreleasepool {
            Ivar ivar = ivarList[index];
            
            
            const char * ivarCName = ivar_getName(ivar);
            //            const char * ivarTypeEcoding = ivar_getTypeEncoding(ivar);
            
            NSString * ivarOCName = [NSString stringWithUTF8String:ivarCName];
            //            NSString * ivarTypeOCEcoding = [NSString stringWithUTF8String:ivarTypeEcoding];
            
            [mutArray addObject:ivarOCName];
        }
    }
    free(ivarList);
    return mutArray.copy;
}


- (NSArray<NSString *> *)jk_properties {
    
    NSArray * properties = objc_getAssociatedObject(self, _cmd);
    if (nil == properties && 0 == properties.count) {
        properties = [self.class jk_properties];
        objc_setAssociatedObject(self, _cmd, properties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return properties;
}


+ (NSArray <NSString *>*)jk_properties {
    if (self == [NSObject class]) {
        return nil;
    }
    NSMutableArray * mutArray = [[NSMutableArray alloc] init];
//    NSArray * superClassPropeties = [[self superclass] jk_properties];
//    if (superClassPropeties) {
//        [mutArray addObjectsFromArray:superClassPropeties];
//    }
//    
    unsigned int propertiesCount = 0;
    objc_property_t * propertyList = class_copyPropertyList(self.class, &propertiesCount);
    for (NSInteger index = 0; index < propertiesCount; index ++) {
        @autoreleasepool {
            objc_property_t property = propertyList[index];
            const char * propertyCName = property_getName(property);
            
            NSString * propertyOCName = [NSString stringWithUTF8String:propertyCName];
            [mutArray addObject:propertyOCName];
        }
    }
    free(propertyList);
    return mutArray.copy;
}


- (NSArray <NSString *>*)jk_methods {
    NSMutableArray * mutArray = [NSMutableArray array];
    
    unsigned int count = 0;
    Method * methods = class_copyMethodList(self.class, &count);
    for (unsigned int index = 0; index < count; index ++) {
        Method method = methods[index];
        SEL methodName = method_getName(method);
        NSString * name = NSStringFromSelector(methodName);
        [mutArray addObject:name];
    }
    free(methods);
    return mutArray.copy;
}

@end
