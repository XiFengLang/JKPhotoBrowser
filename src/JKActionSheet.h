//
//  JKActionSheet.h
//  JKActionSheet
//
//  Created by 蒋鹏 on 17/2/14.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKPhoneBrowserFunction.h"

NS_ASSUME_NONNULL_BEGIN

@interface JKAction : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSMutableDictionary * ext;
@property (nonatomic, copy, nullable) void (^selectionHandler)(JKAction * action);

+ (instancetype)actionWithTitle:(NSString *)title
               selectionHandler:(void (^ _Nullable)(JKAction * action))selectionHandler;

@end












@interface JKActionSheet : UIControl

/// conatiner顶部圆角
@property (nonatomic, assign) CGFloat topCornerRadius;

@property (nonatomic, strong, readonly) NSMutableArray <JKAction *>* dataArray;

@property (nonatomic, copy, nullable) void (^cancelHandler)(void);


- (instancetype)initWithFrame:(CGRect)frame actions:(NSArray <JKAction *>*)actions;
- (void)showInView:(UIView *)view animated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
