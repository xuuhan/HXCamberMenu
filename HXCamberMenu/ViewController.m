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

@property (nonatomic, strong) HXCamberMenu *menu;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"弧形", @"圆形"]];
    segment.frame = CGRectMake(20, 40, 200, 30);
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(modeChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];

    [self setupMenuWithType:HXCamberMenuTypeArc];
}

- (void)modeChanged:(UISegmentedControl *)segment {
    HXCamberMenuType type = segment.selectedSegmentIndex == 0 ? HXCamberMenuTypeArc : HXCamberMenuTypeCircle;
    [self setupMenuWithType:type];
}

- (void)setupMenuWithType:(HXCamberMenuType)type {
    [self.menu removeFromSuperview];

    CGFloat radius = type == HXCamberMenuTypeArc ? 440 : MIN(SCREEN_WIDTH, SCREEN_HEIGHT)/2 - 40;
    CGPoint center;
    if (type == HXCamberMenuTypeArc) {
        center = CGPointMake(self.view.frame.size.width / 2, 0);
    } else {
        center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    }

    self.menu = [[HXCamberMenu alloc] initWithRadius:radius andCenterPoint:center andOutsideCirCleImage:[UIImage imageNamed:@"color1"] andInsideCircleImage:[UIImage imageNamed:@"color2"] andInsideCircleMargin:80 menuType:type];

    [self.menu addSubViewWithSubViewArray:[self btnArrayCreat] withShowBtnCount:5];
    [self.view addSubview:self.menu];
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
