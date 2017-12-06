//
//  CasesView.m
//  病例Demo
//
//  Created by 郭勇 on 2017/6/26.
//  Copyright © 2017年 personal. All rights reserved.
//

#import "CasesView.h"

#define maxColumn 3
#define maxImagesCount 5

@interface CasesView()
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, weak) UIButton *addBtn;
@end
@implementation CasesView
@dynamic delegate;

- (NSMutableArray *)images
{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addBtn];
        self.addBtn = addBtn;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = 10.0f;
    
    CGFloat imageViewW = (self.bounds.size.width - (maxColumn + 1 ) * margin) / maxColumn;
    CGFloat imageViewH = imageViewW;
    CGFloat imageViewY = (self.bounds.size.height - imageViewH) * 0.5f;
    for (NSInteger i = 0; i < self.images.count; i++) {
        CGFloat imageViewX = margin + (imageViewW + margin) * i;
        UIImageView *imageView = self.images[i];
        imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
        
        // 添加删除小按钮
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_gray"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.tag = i;
        CGFloat delBtnW = 15.0;
        CGFloat delBtnH = delBtnW;
        CGFloat delBtnY = 0;
        CGFloat delBtnX = imageViewW - delBtnW;
        deleteBtn.frame = CGRectMake(delBtnX, delBtnY, delBtnW, delBtnH);
        [imageView addSubview:deleteBtn];
    }
    
    if (self.images.count >= maxImagesCount) {
        self.addBtn.hidden = YES;
    } else {
        self.addBtn.hidden = NO;
        if (self.images.count > 0) {
            UIImageView *imageView = [self.images lastObject];
            self.addBtn.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + margin, imageViewY, imageViewW, imageViewH);
        } else {
            self.addBtn.frame = CGRectMake(margin, imageViewY, imageViewW, imageViewH);
        }
    }
    
    if (self.images.count < maxImagesCount) {
        self.contentSize = CGSizeMake(CGRectGetMaxX(self.addBtn.frame), 0);
    } else {
        UIImageView *imageView = [self.images lastObject];
        self.contentSize = CGSizeMake(CGRectGetMaxX(imageView.frame), 0);
        
    }
}

- (void)addImage:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.image = image;
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    [self.images addObject:imageView];
    [self setNeedsDisplay];
}

- (void)removeImageWithIndex:(NSInteger)index
{
    UIImageView *imageView = self.images[index];
    [imageView removeFromSuperview];
    [self.images removeObjectAtIndex:index];
    [self setNeedsDisplay];
}
- (void)addbtnClick:(UIButton *)addBtn
{
    if ([self.delegate respondsToSelector:@selector(casesViewDidClickAddBtn:)]) {
        [self.delegate casesViewDidClickAddBtn:self];
    }
}

- (void)deleteBtnClick:(UIButton *)delBtn
{
    if ([self.delegate respondsToSelector:@selector(casesView:didClickDeleteBtnWithIndex:)]) {
        [self.delegate casesView:self didClickDeleteBtnWithIndex:delBtn.tag];
    }
}
@end
