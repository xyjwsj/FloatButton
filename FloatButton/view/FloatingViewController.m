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
#import "FloatWindow.h"

// 屏幕高度
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define ScreenW [UIScreen mainScreen].bounds.size.width

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
// 屏幕宽度
// 悬浮按钮的尺寸
#define floatSize 40

@interface FloatingViewController ()<UIDragButtonDelegate>

/**
 *  悬浮的window
 */
@property(strong,nonatomic)FloatWindow *window;

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
    
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
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
    _window = [[FloatWindow alloc]init];
//    _window.frame = [self transitionFrame:_window.frame];
    _window.floatFrame = CGRectMake(0, ScreenH/2, floatSize, floatSize);
    _window.frame = _window.floatFrame;
    _window.windowLevel = UIWindowLevelAlert+1;
    _window.backgroundColor = [UIColor orangeColor];
    _window.layer.cornerRadius = floatSize/2;
    _window.layer.masksToBounds = YES;
    // 将按钮添加到悬浮按钮上
    [_window addSubview:_button];
    [self createView];
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

    [_window insertSubview:_showView belowSubview:_button];
}

/**
 *  悬浮按钮点击
 */
- (void)dragButtonClicked:(UIButton *)sender {
    // 按钮选中关闭切换
    __block typeof(self) weakSelf = self;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"add_rotate"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.4 animations:^{
            CGRect contentFrame = _showView.frame;
            CGRect frame = _window.frame;
            CGRect btnFrame = _button.frame;
            if (_button.direction == LEFT) {
                frame.size.width = floatSize;
            }
            
            if (_button.direction == RIGHT) {
                frame.size.width = floatSize;
                frame.origin.x = [weakSelf smallFloat] - floatSize;
                btnFrame.origin.x = 0;
                contentFrame.origin.x = floatSize;
            }
            
            if (_button.direction == TOP) {
                frame.size.height = floatSize;
            }
            
            if (_button.direction == BOTTOM) {
                frame.size.height = floatSize;
                frame.origin.y = [weakSelf bigFloat] - floatSize;
                btnFrame.origin.x = 0;
                contentFrame.origin.x = floatSize/2;
            }
            
            _window.floatFrame = frame;
            [_window layoutSubviews];
            _showView.frame = contentFrame;
            _button.frame = btnFrame;
            
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [sender setImage:[UIImage imageNamed:@"add_button"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.4 animations:^{
            CGRect contentFrame = _showView.frame;
            CGRect frame = _window.frame;
            CGRect btnFrame = _button.frame;
            if (_button.direction == LEFT) {
                frame.size.width += contentFrame.size.width + floatSize/2;
            }
            
            if (_button.direction == RIGHT) {
                frame.size.width += contentFrame.size.width + floatSize/2;
                frame.origin.x -= (contentFrame.size.width + floatSize/2);
                btnFrame.origin.x = frame.size.width - floatSize;
                contentFrame.origin.x = floatSize/2;
            }
            
            if (_button.direction == TOP) {
                frame.size.height += contentFrame.size.width + floatSize/2;
            }
            
            if (_button.direction == BOTTOM) {
                frame.size.height += contentFrame.size.width + floatSize/2;
                frame.origin.y -= (contentFrame.size.width + floatSize/2);
                btnFrame.origin.x = frame.size.height - floatSize;
                contentFrame.origin.x = floatSize/2;
            }
            
            _window.floatFrame = frame;
            [_window layoutSubviews];
            _showView.frame = contentFrame;
            _button.frame = btnFrame;
        } completion:^(BOOL finished) {
            
        }];
    }
    sender.selected = !sender.selected;
    // 关闭悬浮窗
    //[_window resignKeyWindow];
    //_window = nil;
    
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    __block typeof(self) weakSelf = self;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         NSLog(@"转屏前调入");
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         NSLog(@"转屏后调入");
         [UIView animateWithDuration:0.3 animations:^{             
             CGPoint point = [weakSelf transitionPoint:_window.frame.origin];
             _window.frame = CGRectMake(point.x, point.y, _window.frame.size.width, _window.frame.size.height);
         }];
         
         UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
         if (orientation == UIDeviceOrientationPortrait) {
             _window.transform = CGAffineTransformIdentity;
             _button.direction = LEFT;
         } else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
             _window.transform = CGAffineTransformIdentity;
             _window.transform = CGAffineTransformRotate(CGAffineTransformIdentity, DEGREES_TO_RADIANS(180));
             _button.direction = RIGHT;
         } else if (orientation == UIDeviceOrientationLandscapeLeft) {
            _window.transform = CGAffineTransformIdentity;
            _window.transform = CGAffineTransformRotate(CGAffineTransformIdentity, DEGREES_TO_RADIANS(90));
              _button.direction = TOP;
             
         } else if (orientation == UIDeviceOrientationLandscapeRight) {
             _window.transform = CGAffineTransformIdentity;
             _window.transform = CGAffineTransformRotate(CGAffineTransformIdentity, DEGREES_TO_RADIANS(-90));
             _button.direction = BOTTOM;
         }
         
     }];
    
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
}


/**
 *  获取旋转后的坐标
 默认以竖屏为准
 *
 *  @param CGPoint 需要转换坐标(竖屏)
 *
 *  @return 转换后的坐标
 */
- (CGPoint)transitionPoint:(CGPoint)point {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (orientation == UIDeviceOrientationPortrait) {
        point.x = 0;
        point.y = [self bigFloat]/2;
        
    } else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
        point.x = [self smallFloat] - floatSize;
        point.y = [self bigFloat]/2;
        
    } else if (orientation == UIDeviceOrientationLandscapeLeft) {
        point.x = [self smallFloat]/2;
        point.y = 0;
       
    } else if (orientation == UIDeviceOrientationLandscapeRight) {
        point.x = [self smallFloat]/2;
        point.y = [self bigFloat] - floatSize;
        
    }
    
    return point;
}
- (CGFloat)bigFloat {
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (size.height > size.width) {
        return size.height;
    }
    return size.width;
}

- (CGFloat)smallFloat {
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (size.height < size.width) {
        return size.height;
    }
    return size.width;
}

@end
