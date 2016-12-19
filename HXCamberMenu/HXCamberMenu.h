//
//  HXCamberMenu.h
//  HXCamberMenu
//
//  Created by 韩旭 on 2016/12/19.
//  Copyright © 2016年 韩旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXCamberMenu : UIView

/**
 初始化方法
 
 @param radius 外圆半径
 @param centerPoint 外圆中心点
 @param outsideCirCleImage 外圆图片
 @param insideCirCleImage 内圆图片
 @param circleMargin 外圆和内圆距离
 @return self
 */
- (instancetype)initWithRadius:(CGFloat)radius andCenterPoint:(CGPoint)centerPoint andOutsideCirCleImage:(UIImage *)outsideCirCleImage andInsideCircleImage:(UIImage *)insideCirCleImage andInsideCircleMargin:(CGFloat)circleMargin;


/**
 添加子视图
 
 @param viewArray 子视图数组
 @param count 屏幕静止时要显示的子视图个数
 */
- (void)addSubViewWithSubViewArray:(NSArray *)viewArray withShowBtnCount:(int)count;

@end
