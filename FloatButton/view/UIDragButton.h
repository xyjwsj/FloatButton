//
//  UIDragButton.h
//  FloatButton
//
//  Created by Hoolai on 16/8/2.
//  Copyright © 2016年 wsj_proj. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  代理按钮的点击事件
 */
@protocol UIDragButtonDelegate <NSObject>

- (void)dragButtonClicked:(UIButton *)sender;

@end

@interface UIDragButton : UIButton

/**
 *  悬浮窗所依赖的根视图
 */
@property (nonatomic, strong)UIView *rootView;

/**
 *  UIDragButton的点击事件代理
 */
@property (nonatomic, weak)id<UIDragButtonDelegate>btnDelegate;

@end