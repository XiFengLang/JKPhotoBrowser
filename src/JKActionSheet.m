//
//  JKActionSheet.m
//  JKActionSheet
//
//  Created by 蒋鹏 on 17/2/14.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "JKActionSheet.h"
#import "JKActionSheetCell.h"
#import <Masonry/Masonry.h>

@implementation JKAction

- (NSMutableDictionary *)ext{
    if (!_ext) {
        _ext = [[NSMutableDictionary alloc]init];
    }return _ext;
}

+ (instancetype)actionWithTitle:(NSString *)title selectionHandler:(void (^ _Nullable)(JKAction * _Nonnull))selectionHandler {
    JKAction * action = [[self alloc] init];
    action.title = title;
    action.selectionHandler = selectionHandler;
    return action;
}

@end








@interface JKActionSheet () <UITableViewDelegate, UITableViewDataSource>

/// conatiner高度
@property (nonatomic, assign) CGFloat containerHeight;

/// 底部的容器
@property (nonatomic, strong, readonly) UIView * containerView;

@property (nonatomic, strong) UIView * safeAreaView;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIButton * cancelButton;
@property (nonatomic, strong) UIView * buoyView;


@end

@implementation JKActionSheet


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        /// 避免因圆角而出现透明角的现象
        _safeAreaView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 40,
                                                                 CGRectGetWidth(self.frame), 40)];
        self.safeAreaView.backgroundColor = JKPhotoManager_Color(0xFF1A1A1A);
        [self addSubview:self.safeAreaView];
        
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - self.containerHeight, CGRectGetWidth(self.frame), self.containerHeight)];
        _containerView.backgroundColor = JKPhotoManager_Color(0xFF1A1A1A);
        [self addSubview:self.containerView];
        
        
        [self addTarget:self action:@selector(dismissManually) forControlEvents:(UIControlEventTouchUpInside)];
        self.containerHeight = 150;
    }return self;
}

- (instancetype)initWithFrame:(CGRect)frame actions:(NSArray <JKAction *>*)actions {
    if (self = [self initWithFrame:frame]) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:2];
        [self.dataArray addObjectsFromArray:actions];
        
        CGFloat rowHeight = 40;
        CGFloat tableHeight = self.tableView.rowHeight * actions.count;
        CGFloat topPadding = 22;
        CGRect frame = CGRectMake(0, topPadding, CGRectGetWidth(self.frame), tableHeight);
        
        self.tableView = [[UITableView alloc] initWithFrame:frame style:(UITableViewStyleGrouped)];
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.01)];
        self.tableView.backgroundColor = self.containerView.backgroundColor;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.showsHorizontalScrollIndicator = false;
        self.tableView.showsVerticalScrollIndicator = false;
        self.tableView.scrollEnabled = false;
        self.tableView.sectionHeaderHeight = 0.01;
        self.tableView.sectionFooterHeight = 0.01;
        self.tableView.rowHeight = rowHeight;
        
        [self.containerView addSubview:self.tableView];
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        [self.tableView registerClass:JKActionSheetCell.class forCellReuseIdentifier:@"JKActionSheetCell"];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        
        self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(16, topPadding + tableHeight, CGRectGetWidth(self.frame), 40)];
        self.cancelButton.backgroundColor = JKPhotoManager_Color(0xFF2D2D2D);
        self.cancelButton.layer.cornerRadius = 20;
        self.cancelButton.layer.masksToBounds = true;
        [self.cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
        [self.cancelButton setTitleColor:JKPhotoManager_Color(0xFFC3C5C8) forState:UIControlStateNormal];
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.containerView addSubview:self.cancelButton];
        [self.cancelButton addTarget:self action:@selector(dismissManually) forControlEvents:(UIControlEventTouchUpInside)];
        
        /// 顶部的浮标
        self.buoyView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 20, 10, 40, 4)];
        self.buoyView.layer.cornerRadius = 2;
        self.buoyView.backgroundColor = JKPhotoManager_Color(0xFF3F3F3F);
        self.buoyView.layer.masksToBounds = true;
        [self.containerView addSubview:self.buoyView];
        
        [self.buoyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_offset(0);
            make.top.mas_offset(10);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(4);
        }];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.top.mas_offset(topPadding);
        }];
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(16);
            make.right.mas_offset(-16);
            make.top.equalTo(self.tableView.mas_bottom).offset(10);
            make.bottom.mas_offset(-34);
            make.height.mas_equalTo(40);
        }];
        self.containerHeight = self.tableView.rowHeight * actions.count + 10 + 40 + 34 + topPadding;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    return self;
}


- (void)dismissManually {
    self.cancelHandler ? self.cancelHandler() : NULL;
    [self dismissAnimated:true];
}



#pragma mark - Public

- (void)setTopCornerRadius:(CGFloat)topCornerRadius {
    _topCornerRadius = topCornerRadius;
    self.containerView.layer.cornerRadius = topCornerRadius;
    self.containerView.layer.masksToBounds = true;
}

- (void)setContainerHeight:(CGFloat)containerHeight {
    _containerHeight = containerHeight;
    if (self.superview) {
        [self refreshAnimated:true];
    }
}

- (void)showInView:(UIView *)view animated:(BOOL)animated {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.containerView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), self.containerHeight);
    self.safeAreaView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 40);
    [view addSubview:self];
    [self refreshAnimated:animated];
}


- (void)refreshAnimated:(BOOL)animated {
    dispatch_block_t block = ^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.containerView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - self.containerHeight,
                                              CGRectGetWidth(self.frame), self.containerHeight);
        self.safeAreaView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 40,
                                             CGRectGetWidth(self.frame), 40);
    };
    
    if (animated) {
        [UIView animateWithDuration:0.28 delay:0 options:7<<16 animations:block completion:nil];
    } else {
        block();
    }
}

- (void)dismissAnimated:(BOOL)animated {
    dispatch_block_t block = ^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.containerView.frame = CGRectMake(0, CGRectGetHeight(self.frame),
                                              CGRectGetWidth(self.frame), self.containerHeight);
        self.safeAreaView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), 40);
    };
    
    if (animated) {
        [UIView animateWithDuration:0.28 delay:0 options:7<<16 animations:block completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else {
        block();
        [self removeFromSuperview];
    }
    self.cancelHandler = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JKActionSheetCell * cell = [tableView dequeueReusableCellWithIdentifier:@"JKActionSheetCell"];
    cell.titleLabel.text = self.dataArray[indexPath.row].title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    JKAction * action = self.dataArray[indexPath.row];
    action.selectionHandler ? action.selectionHandler(action) : NULL;
    [self dismissAnimated:true];
}


- (void)dealloc {
    NSLog(@"%@ 已释放",self.class);
}
@end
