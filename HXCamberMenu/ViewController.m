//
//  ViewController.m
//  HXCamberMenu
//
//  Created by 韩旭 on 2016/12/19.
//  Copyright © 2016年 韩旭. All rights reserved.
//

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height;

#import "ViewController.h"
#import "HXCamberMenu.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     输入半径、圆心、外圆图片、内圆图片、外圆与内圆距离
     
     半径要 > 屏幕宽度的一半
     */
    HXCamberMenu *view = [[HXCamberMenu alloc] initWithRadius:440 andCenterPoint:CGPointMake(self.view.frame.size.width / 2, 0) andOutsideCirCleImage:[UIImage imageNamed:@"color1"] andInsideCircleImage:[UIImage imageNamed:@"color2"] andInsideCircleMargin:80];
    
    ///添加子视图数组与界面静止时子视图个数
    [view addSubViewWithSubViewArray:[self btnArrayCreat] withShowBtnCount:5];
    
    [self.view addSubview:view];

}


///按钮数组
- (NSArray *)btnArrayCreat{
    
    NSMutableArray *btnArray = [NSMutableArray array];
    
    for (int i = 0; i < 7; i++) {
        UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        
        button.backgroundColor=[UIColor yellowColor];
        button.layer.cornerRadius= 60/2;
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"第%d个",i + 1] forState:UIControlStateNormal];
        button.tag=100+i;
        [btnArray addObject:button];
    }
    
    return btnArray;
}


@end
