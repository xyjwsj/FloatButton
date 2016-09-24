//
//  UIDragButton.m
//  FloatButton
//
//  Created by Hoolai on 16/8/2.
//  Copyright © 2016年 wsj_proj. All rights reserved.
//

#import "UIDragButton.h"

@interface UIDragButton()

/**
 *  开始按下的触点坐标
 */
@property (nonatomic, assign)CGPoint startPos;

@end

@implementation UIDragButton


/**
 *  开始触摸，记录触点位置用于判断是拖动还是点击
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    // 获得触摸在根视图中的坐标
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:_rootView];
    _startPos = point;
}

/**
 *  手指按住移动过程,通过悬浮按钮的拖动事件来拖动整个悬浮窗口
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.selected) {        
        // 获得触摸在根视图中的坐标
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:_rootView];
        // 移动按钮到当前触摸位置
        self.superview.center = [self transitionPoint:point];
    }

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
    
    CGPoint transPoint = [self transitionPoint:curPoint];
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    _direction = LEFT;
    if (orientation == UIDeviceOrientationPortrait) {
        if (transPoint.x <= [self smallFloat]/2) {
            _direction = LEFT;
        } else {
            _direction = RIGHT;
        }
    } else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
        if (transPoint.x <= [self smallFloat]/2) {
            _direction = RIGHT;
        } else {
            _direction = LEFT;
        }
    } else if (orientation == UIDeviceOrientationLandscapeLeft) {
        if (transPoint.y <= [self bigFloat]/2) {
            _direction = TOP;
        } else {
            _direction = BOTTOM;
        }
    } else if (orientation == UIDeviceOrientationLandscapeRight) {
        if (transPoint.y <= [self bigFloat]/2) {
            _direction = TOP;
        } else {
            _direction = BOTTOM;
        }
    }
    
   
    // 开始吸附
    switch (_direction) {
        case LEFT:
            [self animationWithPoint:CGPointMake(0, self.superview.frame.origin.y)];
            break;
        case RIGHT:
            [self animationWithPoint:CGPointMake([self smallFloat] - self.superview.frame.size.width, self.superview.frame.origin.y)];
            break;
        case TOP:
            [self animationWithPoint:CGPointMake(self.superview.frame.origin.x, 0)];
            break;
        case BOTTOM:
            [self animationWithPoint:CGPointMake(self.superview.frame.origin.x, [self bigFloat] - self.superview.frame.size.height)];
            break;
        default:
            break;
    }
}

- (void)animationWithPoint:(CGPoint)point {
    
    __block typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.4 animations:^{
        
        //矫正浮窗越界
        CGPoint tempPoint = point;
        if (tempPoint.x < 0) {
            tempPoint.x = 0;
        }
        if (tempPoint.y < 0) {
            tempPoint.y = 0;
        }
        if (tempPoint.x + self.frame.size.width > [self smallFloat]) {
            tempPoint.x = [self smallFloat] - self.frame.size.width;
        }
        if (tempPoint.y + self.frame.size.height > [self bigFloat]) {
            tempPoint.y = [self bigFloat] - self.frame.size.height;
        }
        
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation == UIDeviceOrientationPortrait) {
            
        } else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
            
        } else if (orientation == UIDeviceOrientationLandscapeLeft) {
            
        } else if (orientation == UIDeviceOrientationLandscapeRight) {
            
        }
        
        CGRect frame = CGRectMake(tempPoint.x, tempPoint.y, self.frame.size.width, self.frame.size.height);
        weakSelf.superview.frame = frame;
    } completion:^(BOOL finished) {
    }];
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
        
    } else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
        point.x = [self smallFloat] - point.x;
        point.y = [self bigFloat] - point.y;
    } else if (orientation == UIDeviceOrientationLandscapeLeft) {
        CGFloat tempX = point.x;
        point.x = [self smallFloat] - point.y;
        point.y = tempX;
    } else if (orientation == UIDeviceOrientationLandscapeRight) {
        CGFloat tempX = point.x;
        point.x = point.y;
        point.y = [self bigFloat] - tempX;
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
