//
//  FloatWindow.m
//  FloatButton
//
//  Created by Hoolai on 2016/9/23.
//  Copyright © 2016年 wsj_proj. All rights reserved.
//

#import "FloatWindow.h"

@implementation FloatWindow

/**
 *  屏幕旋转重新调整坐标系
 */
- (void)layoutSubviews {
    // 事实上这里可以随便给一个cgrect，悬浮窗相对位置并不会变
    self.frame = _floatFrame;
}

@end
