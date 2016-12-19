# HXCamberMenu
滑动弧形菜单
![image](https://github.com/xuuhan/HXCamberMenu/blob/master/Assets.xcassets/menu1.gif)

#import "HXCamberMenu.h"

初始化方法 
 @param radius 外圆半径
 @param centerPoint 外圆中心点
 @param outsideCirCleImage 外圆图片
 @param insideCirCleImage 内圆图片
 @param circleMargin 外圆和内圆距离
 @return self
 
- (instancetype)initWithRadius:(CGFloat)radius andCenterPoint:(CGPoint)centerPoint andOutsideCirCleImage:(UIImage *)outsideCirCleImage andInsideCircleImage:(UIImage *)insideCirCleImage andInsideCircleMargin:(CGFloat)circleMargin;


 添加子视图
 
 @param viewArray 子视图数组
 @param count 屏幕静止时要显示的子视图个数

- (void)addSubViewWithSubViewArray:(NSArray *)viewArray withShowBtnCount:(int)count;



项目比较忙,只是做了简单的封装,功能与效果还有限制与不完善,待闲下来再做完善和封装。
