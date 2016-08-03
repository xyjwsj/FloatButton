//
//  UIDragButton.m
//  FloatButton
//
//  Created by Hoolai on 16/8/2.
//  Copyright © 2016年 wsj_proj. All rights reserved.
//

#import "UIDragButton.h"
// 屏幕高度
#define ScreenH [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define ScreenW [UIScreen mainScreen].bounds.size.width

@interface UIDragButton()

/**
 *  开始按下的触点坐标
 */
@property (nonatomic, assign)CGPoint startPos;

@end

@implementation UIDragButton

// 枚举四个吸附方向
typedef enum {
    LEFT,
    RIGHT,
    TOP,
    BOTTOM
}Dir;

/**
 *  开始触摸，记录触点位置用于判断是拖动还是点击
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    // 获得触摸在根视图中的坐标
    UITouch *touch = [touches anyObject];
    _startPos = [touch locationInView:_rootView];
}

/**
 *  手指按住移动过程,通过悬浮按钮的拖动事件来拖动整个悬浮窗口
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 获得触摸在根视图中的坐标
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:_rootView];
    // 移动按钮到当前触摸位置
    self.superview.center = curPoint;
}

/**
 *  拖动结束后使悬浮窗口吸附在最近的屏幕边缘
 */
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 获得触摸在根视图中的坐标
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:_rootView];
    // 通知代理,如果结束触点和起始触点极近则认为是点击事件
    if (pow((_startPos.x - curPoint.x),2) + pow((_startPos.y - curPoint.y),2) < 1) {
        [self.btnDelegate dragButtonClicked:self];
        return;//点击后不吸附
    }
    // 与四个屏幕边界距离
    CGFloat left = curPoint.x;
    CGFloat right = ScreenW - curPoint.x;
//    CGFloat top = curPoint.y;
//    CGFloat bottom = ScreenH - curPoint.y;
    // 计算四个距离最小的吸附方向
    Dir minDir = LEFT;
    CGFloat minDistance = left;
    if (right < minDistance) {
        minDistance = right;
        minDir = RIGHT;
    }
//    if (top < minDistance) {
//        minDistance = top;
//        minDir = TOP;
//    }
//    if (bottom < minDistance) {
//        minDir = BOTTOM;
//    }
    // 开始吸附
    switch (minDir) {
        case LEFT:
            [self animationWithPoint:CGPointMake(self.superview.frame.size.width/2, self.superview.center.y)];
            break;
        case RIGHT:
            [self animationWithPoint:CGPointMake(ScreenW - self.superview.frame.size.width/2, self.superview.center.y)];
            break;
        case TOP:
            [self animationWithPoint:CGPointMake(self.superview.center.x, self.superview.frame.size.height/2)];
            break;
        case BOTTOM:
            [self animationWithPoint:CGPointMake(self.superview.center.x, ScreenH - self.superview.frame.size.height/2)];
            break;
        default:
            break;
    }
}

- (void)animationWithPoint:(CGPoint)point {
    CGFloat btnBottom = point.y + self.frame.size.height/2;
    CGFloat btnTop = point.y - self.frame.size.height/2;
    if (btnBottom > ScreenH) {
        point.y = ScreenH - self.frame.size.height/2;
    }
    if (btnTop < 0) {
        point.y = self.frame.size.height/2;
    }
    __block typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.4 animations:^{
        weakSelf.superview.center = point;
    } completion:^(BOOL finished) {
        
    }];
}

@end
