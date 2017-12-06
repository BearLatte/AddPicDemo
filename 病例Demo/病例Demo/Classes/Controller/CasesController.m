//
//  CasesController.m
//  病例Demo
//
//  Created by 郭勇 on 2017/6/26.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "CasesController.h"
#import "CasesView.h"

@interface CasesController ()<CasesViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) CasesView *casesView;
@end

@implementation CasesController
- (CasesView *)casesView
{
    if (!_casesView) {
        _casesView = [[CasesView alloc] init];
        _casesView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 100);
        _casesView.delegate = self;
    }
    return _casesView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    NSMutableArray *array = [NSMutableArray array];
    for (id subview in self.casesView.subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)subview;
            [array addObject:imageView.image];
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.row == 0) {
        [cell.contentView addSubview:self.casesView];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.casesView.bounds.size.height;
}

#pragma mark - CasesViewDelegate
- (void)casesViewDidClickAddBtn:(CasesView *)casesView
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:@"请选择图片源" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openAlbum];
    }];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:album];
    [alert addAction:camera];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)casesView:(CasesView *)casesView didClickDeleteBtnWithIndex:(NSInteger)index
{
    [casesView removeImageWithIndex:index];
}

- (void)openAlbum
{
    UIImagePickerController *picVC = [[UIImagePickerController alloc] init];
    picVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picVC.delegate = self;
    [self presentViewController:picVC animated:YES completion:nil];

}

- (void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera ]) {
        UIImagePickerController *picVC = [[UIImagePickerController alloc] init];
        picVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        picVC.delegate = self;
        [self presentViewController:picVC animated:YES completion:nil];
    }else
    {
        NSLog(@"本设备暂时不支持相机功能");
    }
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 销毁相册视图
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 取出选中的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    [self.casesView addImage:image];
}
@end
