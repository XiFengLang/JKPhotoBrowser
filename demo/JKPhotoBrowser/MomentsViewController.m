//
//  MomentsViewController.m
//  JKPhotoBrowser
//
//  Created by 蒋鹏 on 17/2/20.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "MomentsViewController.h"
#import "MomentsTableViewCell.h"
#import "JKPhotoBrowser.h"

@interface MomentsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray * dataArray;

@end

@implementation MomentsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[MomentsTableViewCell class] forCellReuseIdentifier:JKMomentsCellKey];
    
    self.dataArray = [JKImageModel models];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - TableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


NSString * const JKMomentsCellKey = @"JKMomentsCellKey";
- (MomentsTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MomentsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:JKMomentsCellKey];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configueCellWithImageModels:self.dataArray tableView:tableView atIndexPath:indexPath];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UIScreen mainScreen].bounds.size.width;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 30;
    }return 0.01;
}

@end
