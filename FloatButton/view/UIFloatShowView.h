//
//  UIFloatShowView.h
//  FloatButton
//
//  Created by Hoolai on 16/8/2.
//  Copyright © 2016年 wsj_proj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FloatModel.h"

@interface UIFloatShowView : UIView<UIGestureRecognizerDelegate>

-(instancetype)initWithFrame:(CGRect)frame floatModels:(NSArray<FloatModel*>*)floatSources;

@end
