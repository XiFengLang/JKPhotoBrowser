//
//  ChatViewController.m
//  JKPhotoBrowser
//
//  Created by 蒋鹏 on 17/2/20.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "ChatViewController.h"
#import "JKImageModel.h"
#import "ChatTableViewCell.h"
#import "JKPhotoBrowser.h"

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource, ChatTableViewCellDelegate, JKPhotoManagerDelegate>

@property (nonatomic, copy) NSArray <JKImageModel *>* dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray * imageModels;

@end

@implementation ChatViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[ChatTableViewCell class] forCellReuseIdentifier:JKChatCellKey];
    self.dataArray = [JKImageModel models];
    
    self.imageModels = [NSMutableArray array];
    
    // *************************绑定JKPhotoModel*********************************
    
    [self.dataArray enumerateObjectsUsingBlock:^(JKImageModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        
        JKPhotoModel * photoModel = [JKPhotoModel modelWithImageView:nil
                                                         smallPicUrl:model.imageUrl
                                                                cell:nil
                                                         contentView:self.tableView];
        [self.imageModels addObject:photoModel];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

#pragma mark - TableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}


NSString * const JKChatCellKey = @"JKChatCellKey";
- (ChatTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:JKChatCellKey];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configueCellWithImageModel:self.dataArray[indexPath.row] indexPath:indexPath];
    cell.delegate = self;
    
    
    // *************************绑定cell和imageView*********************************
    
    JKPhotoModel * photoModel = self.imageModels[indexPath.row];
    photoModel.imageView = cell.imgView;
    photoModel.cell = cell;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JKImageModel * model = self.dataArray[indexPath.row];
    CGSize size = model.imageSize.CGSizeValue;
    CGFloat scale = size.width / size.height;
    if (scale > 1.0) {
        return 200 / scale + 20;
    }
    return 200 + 20;
}



#pragma mark - JKPhotoBrowser

- (void)didClickImageView:(UIImageView *)imageView atIndexPath:(NSIndexPath *)indexPath {
    JKPhotoBrowser().jk_itemArray = self.imageModels;
    JKPhotoBrowser().jk_currentIndex = indexPath.row;
    JKPhotoBrowser().jk_showPageController = YES;
    [[JKPhotoManager sharedManager] jk_showPhotoBrowser];
    JKPhotoBrowser().jk_delegate = self;
}


#pragma mark - JKPhotoManagerDelegate


/**    返回大图URL    */
- (NSString *)jk_bigImageUrlAtIndex:(NSInteger) index {
    JKImageModel * model = self.dataArray[index];
    return model.imageUrl;
}




/**
 将图片保存到相册的结果回调
 
 @param error 结果
 */
- (void)jk_handleImageWriteToSavedPhotosAlbumWithError:(NSError *) error {
    NSLog(@"%@",error);
}


/**
 处理二维码识别
 
 @param QRCodeContent 二维码内容
 */
- (void)jk_handleQRCodeRecognitionResult:(NSString *)QRCodeContent {
    NSLog(@"%@",QRCodeContent);
}

@end
