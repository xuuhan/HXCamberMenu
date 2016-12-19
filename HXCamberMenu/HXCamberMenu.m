//
//  HXCamberMenu.m
//  HXCamberMenu
//
//  Created by 韩旭 on 2016/12/19.
//  Copyright © 2016年 韩旭. All rights reserved.
//
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height;

#import "HXCamberMenu.h"

@interface HXCamberMenu()
///外圆
@property (nonatomic, weak) UIImageView *circleView;
///内圆
@property (nonatomic, weak) UIImageView *insertView;
///内圆外圆距离
@property (nonatomic, assign) CGFloat circleMargin;

@property (nonatomic, assign) CGFloat moveNum;
///移动值
@property (nonatomic, assign) CGFloat moveX;
///移动结束
@property (nonatomic, assign, getter=isEndMove) BOOL endMove;
///外圆半径
@property (nonatomic, assign) CGFloat radius;
///subViewX
@property (nonatomic, assign) CGFloat subViewX;
///子视图数组
@property (nonatomic, strong) NSArray *subViewArray;
///滑动手势
@property (nonatomic, strong) UIPanGestureRecognizer *pgr;
///界面中保持按钮的个数
@property (nonatomic, assign) int showBtnCount;
//第一触碰点
@property (nonatomic, assign) CGPoint beginPoint;
//第二触碰点
@property (nonatomic, assign) CGPoint movePoint;

@end

@implementation HXCamberMenu

#pragma mark -- 初始化

- (instancetype)initWithRadius:(CGFloat)radius andCenterPoint:(CGPoint)centerPoint andOutsideCirCleImage:(UIImage *)outsideCirCleImage andInsideCircleImage:(UIImage *)insideCirCleImage andInsideCircleMargin:(CGFloat)circleMargin{
    
    self = [super initWithFrame:CGRectMake(centerPoint.x - radius, centerPoint.y - radius, radius * 2, radius * 2)];
    
    if(self){
        ///记录半径
        self.radius = radius;
        ///记录距离
        self.circleMargin = circleMargin;
        ///外圆
        UIImageView *outsideCircle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, radius * 2, radius * 2)];
        
        [self addSubview:outsideCircle];
        
        self.circleView = outsideCircle;
        
        if (outsideCirCleImage) {
            outsideCircle.image = outsideCirCleImage;
        }
        
        outsideCircle.backgroundColor = [UIColor clearColor];
        
        outsideCircle.layer.cornerRadius = radius;
        
        outsideCircle.layer.masksToBounds = YES;
        
        outsideCircle.userInteractionEnabled=YES;
        
        ///内圆
        UIImageView *insertView = [[UIImageView alloc] initWithFrame:CGRectMake(0 + circleMargin, 0 + circleMargin, radius * 2 - circleMargin * 2, radius * 2 - circleMargin * 2)];
        
        NSLog(@"%f-%f-%f-%f",insertView.frame.origin.x,insertView.frame.origin.y,insertView.frame.size.width,insertView.frame.size.height);
        
        self.insertView = insertView;
        
        [self addSubview:insertView];
        
        insertView.backgroundColor = [UIColor colorWithRed:30.0/255.0 green:137.0/255.0 blue:237.0/255.0 alpha:1];
        
        if (insideCirCleImage) {
            insertView.image = insideCirCleImage;
        }
        
        insertView.backgroundColor = [UIColor clearColor];
        
        insertView.layer.cornerRadius = radius - circleMargin;
        
        insertView.layer.masksToBounds = YES;
        
        self.insertView.userInteractionEnabled=YES;
        
        self.subViewX = centerPoint.x - radius;
    }
    
    return self;
}

#pragma mark -- 添加子视图
- (void)addSubViewWithSubViewArray:(NSArray *)viewArray withShowBtnCount:(int)count{
    if (viewArray.count == 0) {
        return;
    }
    
    self.subViewArray = viewArray;
    self.showBtnCount = count;
    
    for (NSInteger i=0; i<self.subViewArray.count; i++) {
        UIButton *button=self.subViewArray[i];
        
        [self.circleView addSubview:button];
    }
    
    [self layoutBtn];
    
    //加转动手势
    UIPanGestureRecognizer *pgr =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(zhuanPgr:)];
    
    self.pgr = pgr;
    
    [self.circleView addGestureRecognizer:pgr];
}


//按钮布局
-(void)layoutBtn{
    
    ///中心点
    CGFloat yy = 0.0;
    CGFloat xx = 0.0;
    CGFloat margin = 0.0;
    ///子视图x中点
    UIView *view = self.subViewArray[0];
    CGFloat subCenterX = view.frame.size.width / 2;
    
    for (NSInteger i=0; i<self.subViewArray.count ;i++) {// 178,245
        
        margin = i * ((SCREEN_WIDTH - 20 - view.frame.size.width)/(self.showBtnCount - 1));
        
        xx = 10 + subCenterX + fabs(self.subViewX) + margin + self.moveNum;
        
        yy = sqrt((self.radius - self.circleMargin / 2) * (self.radius - self.circleMargin / 2) - (xx - self.radius) * (xx - self.radius)) + self.radius;
        
        if (xx >= self.radius - (self.radius - self.circleMargin / 2) && xx <= self.radius + (self.radius - self.circleMargin / 2)) {
            
            UIButton *button=[self.subViewArray objectAtIndex:i];
            NSLog(@"~~~~~~~%@",button);
            if (self.isEndMove) {
                [UIView animateWithDuration:0.3 animations:^{
                    button.center=CGPointMake(xx , yy);
                }];
            } else{
                button.center=CGPointMake(xx , yy);
            }
        }
        NSLog(@"xx:%f---------yy:%f",xx,yy);
    }
}

#pragma mark - 转动手势
-(void)zhuanPgr:(UIPanGestureRecognizer *)pgr
{
    
    UIView *subView = self.subViewArray[0];
    
    CGFloat subViewW = subView.frame.size.width;
    
    if(pgr.state==UIGestureRecognizerStateBegan){
        
        self.endMove = NO;
        
        self.beginPoint=[pgr locationInView:self];
        
    }else if (pgr.state==UIGestureRecognizerStateChanged){
        self.movePoint= [pgr locationInView:self];
        
        self.moveX = sqrt(fabs(self.movePoint.x - self.beginPoint.x) * fabs(self.movePoint.x - self.beginPoint.x) + fabs(self.movePoint.y - self.beginPoint.y) * fabs(self.movePoint.y - self.beginPoint.y));
        
        if (self.movePoint.x>self.beginPoint.x) {
            self.moveNum += self.moveX;
        } else{
            self.moveNum -= self.moveX;
        }
        
        if (self.moveNum > 0) {
            self.moveNum = 0;
        }
        
        if (self.moveNum < -((SCREEN_WIDTH - 20 - subViewW)/(self.showBtnCount - 1)) * (self.subViewArray.count - self.showBtnCount)) {
            self.moveNum = -((SCREEN_WIDTH - 20 - subViewW)/(self.showBtnCount - 1)) * (self.subViewArray.count - self.showBtnCount);
        }
        
        [self layoutBtn];
        
        self.beginPoint = self.movePoint;
        
    }else if (pgr.state==UIGestureRecognizerStateEnded){
        
        self.endMove = YES;
        
        NSLog(@"--------%f------%f",self.moveNum,- (SCREEN_WIDTH - 20 - subViewW) / 4);
        
        for (int i = 0; i < self.subViewArray.count - self.showBtnCount + 1; i ++) {
            if (self.moveNum > - (SCREEN_WIDTH - 20 - subViewW) / (self.showBtnCount - 1) + subViewW / 2 + 10 -(SCREEN_WIDTH - 20 - subViewW) / (self.showBtnCount - 1) * i){
                self.moveNum = -(SCREEN_WIDTH - 20 - subViewW) / (self.showBtnCount - 1) * i;
                break;
            }
        }
        
        [self layoutBtn];
        
    }
}

- (NSArray *)subViewArray{
    if (!_subViewArray) {
        _subViewArray = [NSArray array];
    }
    return _subViewArray;
}


@end
