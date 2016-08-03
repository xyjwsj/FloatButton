//
//  FloatingViewController.m
//  FloatButton
//
//  Created by Hoolai on 16/8/2.
//  Copyright © 2016年 wsj_proj. All rights reserved.
//

#import "FloatingViewController.h"
#import "UIDragButton.h"
#import "UIFloatShowView.h"

// 屏幕高度
#define ScreenH [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define ScreenW [UIScreen mainScreen].bounds.size.width
// 悬浮按钮的尺寸
#define floatSize 40

@interface FloatingViewController ()<UIDragButtonDelegate>

/**
 *  悬浮的window
 */
@property(strong,nonatomic)UIWindow *window;

/**
 *  悬浮的按钮
 */
@property(strong,nonatomic)UIDragButton *button;


/**
 *  展示View
 */
@property(strong, nonatomic) UIFloatShowView* showView;

@end

@implementation FloatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 将视图尺寸设置为0，防止阻碍其他视图元素的交互
    self.view.frame = CGRectZero;
    // 延时显示悬浮窗口
    [self performSelector:@selector(createButton) withObject:nil afterDelay:1];
}

/**
 *  创建悬浮窗口
 */
- (void)createButton
{
    // 悬浮按钮
    _button = [UIDragButton buttonWithType:UIButtonTypeCustom];
    _button.backgroundColor = [UIColor redColor];
    _button.layer.cornerRadius = floatSize/2;
//    [_button setImage:[UIImage imageNamed:@"add_button"] forState:UIControlStateNormal];
//    // 按钮图片伸缩充满整个按钮
//    _button.imageView.contentMode = UIViewContentModeScaleToFill;
    _button.frame = CGRectMake(0, 0, floatSize, floatSize);
    // 按钮点击事件
    //[_button addTarget:self action:@selector(floatBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    // 按钮点击事件代理
    _button.btnDelegate = self;
    // 初始选中状态
    _button.selected = NO;
    // 禁止高亮
    _button.adjustsImageWhenHighlighted = NO;
    _button.rootView = self.view.superview;
    
    // 悬浮窗
    _window = [[UIWindow alloc]initWithFrame:CGRectMake(ScreenW-floatSize, ScreenH/2, floatSize, floatSize)];
    _window.windowLevel = UIWindowLevelAlert+1;
    _window.backgroundColor = [UIColor orangeColor];
    _window.layer.cornerRadius = floatSize/2;
    _window.layer.masksToBounds = YES;
    // 将按钮添加到悬浮按钮上
    [self createView];
    [_window addSubview:_button];
    //显示window
    [_window makeKeyAndVisible];
}

- (void)createView {
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:4];
    for (int i = 0; i < 5; i++) {
        FloatModel* model = [[FloatModel alloc] init];
        model.viewCallback=^(NSInteger index) {
            NSLog(@"%@", @(index));
        };
        model.title = [NSString stringWithFormat:@"test%d", i];
        model.showIndex = i;
        [array addObject:model];
    }
    _showView = [[UIFloatShowView alloc] initWithFrame:CGRectMake(floatSize, 0, _window.frame.size.height, _window.frame.size.height) floatModels:array];
    
    [_window addSubview:_showView];
}

/**
 *  悬浮按钮点击
 */
- (void)dragButtonClicked:(UIButton *)sender {
    // 按钮选中关闭切换
    
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"add_rotate"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.4 animations:^{
            CGRect windowFrame = _window.frame;
            if (windowFrame.origin.x < 10) {
                windowFrame.origin.x = 0;
            } else {
                windowFrame.origin.x = ScreenW - floatSize;
            }
            
            CGRect btnFrame = _button.frame;
            btnFrame.origin.x = 0;
            _button.frame = btnFrame;
            
            windowFrame.size.width = floatSize;
            _window.frame = windowFrame;
            
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [sender setImage:[UIImage imageNamed:@"add_button"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.4 animations:^{
            CGFloat animationW = _showView.frame.size.width + floatSize/2 + 5;
            CGFloat animationX = animationW;
            CGRect frame = _window.frame;
            if (frame.origin.x > ScreenW/2) {
                animationX = -animationW;
            }
            
            CGRect showViewFrame = _showView.frame;
            
            CGRect windowFrame = _window.frame;
            windowFrame.size.width = frame.size.width + animationW;
            if (animationX < 0) {
                windowFrame.origin.x = windowFrame.origin.x + animationX;
                
                CGRect btnFrame = _button.frame;
                btnFrame.origin.x = windowFrame.size.width - floatSize;
                _button.frame = btnFrame;
                
                showViewFrame.origin.x = floatSize/2;
                _showView.frame = showViewFrame;
            } else {
                showViewFrame.origin.x = floatSize + 5;
                _showView.frame = showViewFrame;
            }
            _window.frame = windowFrame;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    sender.selected = !sender.selected;
    // 关闭悬浮窗
    //[_window resignKeyWindow];
    //_window = nil;
    
}

@end