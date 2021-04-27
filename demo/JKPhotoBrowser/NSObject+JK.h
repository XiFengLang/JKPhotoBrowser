//
//  NSObject+JK.h
//  上下文绘图
//
//  Created by 蒋委员长 on 17/2/13.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JK)


/**<  所有的实例变量  */
- (NSArray <NSString *>* )jk_declaredInstanceVariables;

/**<  属性列表  */
- (NSArray<NSString *> *)jk_properties;

/**<  方法列表  */
- (NSArray <NSString *>*)jk_methods;
@end
