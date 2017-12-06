//
//  CasesView.h
//  病例Demo
//
//  Created by 郭勇 on 2017/6/26.
//  Copyright © 2017年 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CasesView;

@protocol  CasesViewDelegate <UIScrollViewDelegate>

@optional

/**
 * 点击了添加按钮的时候调用
 */
- (void)casesViewDidClickAddBtn:(CasesView *)casesView;


/**
 * 点击了删除图片按钮的时候调用
 *
 * @param casesView 将委托对象传出
 * @param index 所要删除的图片的索引
 */
- (void)casesView:(CasesView *)casesView didClickDeleteBtnWithIndex:(NSInteger)index;
@end

@interface CasesView : UIScrollView

/**
 * 添加一张图片到view上
 *
 * @param image  新添加的图片
 */
- (void)addImage:(UIImage *)image;

/**
 * 删除一张图片
 *
 * @param index 图片在数组中的索引
 */
- (void)removeImageWithIndex:(NSInteger)index;

@property (nonatomic, weak) id <CasesViewDelegate> delegate;
@end
