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
#import <math.h>

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
/// 当前旋转角度 (用于全圆模式)
@property (nonatomic, assign) CGFloat currentAngle;

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
        
        self.menuMode = HXCamberMenuModeSemiCircular; // Initialize menuMode
        self.currentAngle = 0.0; // Initialize currentAngle
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
    if (self.menuMode == HXCamberMenuModeFullCircular) {
        UIView *view = self.subViewArray[0]; // Assuming all buttons have the same size
        CGFloat buttonWidth = view.frame.size.width;
        CGFloat layoutRadius = self.radius - self.circleMargin / 2 - buttonWidth / 2; // Adjust as needed
        CGFloat angleStep = 2 * M_PI / self.subViewArray.count;

        for (NSInteger i = 0; i < self.subViewArray.count; i++) {
            UIButton *button = [self.subViewArray objectAtIndex:i];
            CGFloat currentButtonAngle = self.currentAngle + i * angleStep;
            
            CGFloat xx = self.radius + layoutRadius * cos(currentButtonAngle);
            CGFloat yy = self.radius + layoutRadius * sin(currentButtonAngle);
            
            if (self.isEndMove) {
                [UIView animateWithDuration:0.3 animations:^{
                    button.center = CGPointMake(xx, yy);
                }];
            } else {
                button.center = CGPointMake(xx, yy);
            }
            NSLog(@"FullCircular - Button %ld center: (%f, %f)", (long)i, xx, yy);
        }
    } else { // HXCamberMenuModeSemiCircular
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
            NSLog(@"SemiCircular - xx:%f---------yy:%f",xx,yy);
        }
    }
}

#pragma mark - 转动手势
-(void)zhuanPgr:(UIPanGestureRecognizer *)pgr
{
    if (self.menuMode == HXCamberMenuModeFullCircular) {
        if (pgr.state == UIGestureRecognizerStateBegan) {
            self.endMove = NO;
            self.beginPoint = [pgr locationInView:self];
        } else if (pgr.state == UIGestureRecognizerStateChanged) {
            self.movePoint = [pgr locationInView:self];
            
            // Calculate rotation angle
            CGFloat anglePrevious = atan2(self.beginPoint.y - self.radius, self.beginPoint.x - self.radius);
            CGFloat angleCurrent = atan2(self.movePoint.y - self.radius, self.movePoint.x - self.radius);
            CGFloat angleDelta = angleCurrent - anglePrevious;
            
            self.currentAngle += angleDelta;
            
            [self layoutBtn];
            self.beginPoint = self.movePoint;
        } else if (pgr.state == UIGestureRecognizerStateEnded || pgr.state == UIGestureRecognizerStateCancelled) {
            self.endMove = YES;
            [self layoutBtn]; // Call layout to apply final animation if any
        }
    } else { // HXCamberMenuModeSemiCircular
        if (!self.subViewArray || self.subViewArray.count == 0) {
            return; // No buttons to move
        }

        UIView *firstButton = [self.subViewArray firstObject];
        CGFloat buttonWidth = firstButton ? firstButton.frame.size.width : 0;

        if (pgr.state == UIGestureRecognizerStateBegan) {
            self.endMove = NO;
            self.beginPoint = [pgr locationInView:self];
        } else if (pgr.state == UIGestureRecognizerStateChanged) {
            self.movePoint = [pgr locationInView:self];
            CGFloat deltaX = self.movePoint.x - self.beginPoint.x;

            if (deltaX > 0) { // Finger moves right
                self.moveNum += fabs(deltaX);
            } else { // Finger moves left
                self.moveNum -= fabs(deltaX);
            }

            // Clamping self.moveNum
            if (self.moveNum > 0) {
                self.moveNum = 0;
            }

            if (self.subViewArray.count > self.showBtnCount && self.showBtnCount > 1) {
                CGFloat maxMoveNum = -((SCREEN_WIDTH - 20 - buttonWidth) / (self.showBtnCount - 1)) * (self.subViewArray.count - self.showBtnCount);
                if (self.moveNum < maxMoveNum) {
                    self.moveNum = maxMoveNum;
                }
            } else {
                 // If not enough items to scroll or showBtnCount is invalid for scrolling, effectively lock moveNum to 0
                self.moveNum = 0;
            }
            
            [self layoutBtn];
            self.beginPoint = self.movePoint;
        } else if (pgr.state == UIGestureRecognizerStateEnded) {
            self.endMove = YES;
            
            // Snapping Logic
            if (self.subViewArray.count > self.showBtnCount && self.showBtnCount > 1) {
                CGFloat itemSlotWidth = (SCREEN_WIDTH - 20 - buttonWidth) / (self.showBtnCount - 1);
                if (itemSlotWidth > 0) { // Avoid division by zero if itemSlotWidth is 0
                    int targetIndex = round(fabs(self.moveNum) / itemSlotWidth);
                    int maxIndex = (int)self.subViewArray.count - self.showBtnCount;
                    if (targetIndex < 0) targetIndex = 0;
                    if (targetIndex > maxIndex) targetIndex = maxIndex;
                    self.moveNum = -itemSlotWidth * targetIndex;
                } else {
                    self.moveNum = 0; // Cannot determine snapping, reset to 0
                }
            } else {
                self.moveNum = 0; // No scrolling needed or possible, reset to 0
            }
            [self layoutBtn];
        }
    }
}

- (NSArray *)subViewArray{
    if (!_subViewArray) {
        _subViewArray = [NSArray array];
    }
    return _subViewArray;
}

- (void)setMenuMode:(HXCamberMenuMode)menuMode {
    if (_menuMode != menuMode) {
        _menuMode = menuMode;
        
        // Reset state for the new mode to ensure clean transition
        if (_menuMode == HXCamberMenuModeFullCircular) {
            self.moveNum = 0.0; // Reset horizontal scroll offset
        } else { // HXCamberMenuModeSemiCircular
            self.currentAngle = 0.0; // Reset rotation angle
        }
        
        // Set endMove to YES to trigger animations if any are present in layoutBtn
        // and to ensure the state is consistent with a completed gesture.
        self.endMove = YES; 
        [self layoutBtn]; // Re-layout the buttons for the new mode
    }
}

@end
