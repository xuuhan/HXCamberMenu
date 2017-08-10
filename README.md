# HXCamberMenu
滑动弧形菜单

![image](https://github.com/xuuhan/HXCamberMenu/blob/master/HXCamberMenu/Assets.xcassets/menu.gif)

初始化方法

radius 外圆半径
centerPoint 外圆中心点
outsideCirCleImage 外圆图片
insideCirCleImage 内圆图片
circleMargin 外圆和内圆距离

- (instancetype)initWithRadius:(CGFloat)radius andCenterPoint:(CGPoint)centerPoint andOutsideCirCleImage:(UIImage *)outsideCirCleImage andInsideCircleImage:(UIImage *)insideCirCleImage andInsideCircleMargin:(CGFloat)circleMargin;

添加子视图

viewArray 子视图数组
count 屏幕静止时要显示的子视图个数

- (void)addSubViewWithSubViewArray:(NSArray *)viewArray withShowBtnCount:(int)count;

因为项目比较忙，暂时还没时间做完善，效果和功能还有着明显的限制，待时间充裕再做完善封装

原理地址：http://www.jianshu.com/p/e66f2cd3db14
