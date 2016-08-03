//
//  UIFloatShowView.m
//  FloatButton
//
//  Created by Hoolai on 16/8/2.
//  Copyright © 2016年 wsj_proj. All rights reserved.
//

#import "UIFloatShowView.h"

@implementation UIFloatShowView {
    NSArray<FloatModel*>* sources;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame floatModels:(NSArray<FloatModel *> *)floatSources {
    if (self = [super initWithFrame:frame]) {
        sources = floatSources;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    CGFloat viewHeight = self.frame.size.height;
    CGFloat currentX = 0;
    CGFloat totalW = 0;
    for (int i = 0; i < sources.count; i++) {
        UIView* view = [self getBtnView:viewHeight index:i];
        CGRect frame = view.frame;
        frame.origin.x = currentX;
        view.frame = frame;
        currentX += frame.size.width + 1;
        [self addSubview:view];
        totalW += frame.size.width + 1;
    }
    
    CGRect selfFrame = self.frame;
    selfFrame.size.width = totalW;
    self.frame = selfFrame;
}

- (UIView*)getBtnView:(CGFloat)totalHeight index:(NSInteger)index{
    
    CGFloat imageWidth = 4 * totalHeight/5;
    CGFloat titleHeight = totalHeight / 5;
    
    FloatModel* model = [self modelOfIndex:index];
    
    UIView* btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, totalHeight)];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
    imageView.backgroundColor = [UIColor greenColor];
    [btnView addSubview:imageView];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageWidth, imageWidth, titleHeight)];
    label.text = model.title;
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    [btnView addSubview:label];
    
    UIGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    UIView* tapView = [[UIView alloc] initWithFrame:btnView.frame];
    tapView.tag = index;
    [btnView addSubview:tapView];
    tapView.userInteractionEnabled = YES;
    [tapView addGestureRecognizer:tap];
    
    return btnView;
}

- (void)tap:(UIGestureRecognizer*)gesture {
    NSInteger index = gesture.view.tag;
    FloatModel* model = [self modelOfIndex:index];
    if (model.viewCallback) {
        model.viewCallback(index);
    }
}

- (FloatModel*)modelOfIndex:(NSInteger)index {
    for (FloatModel* model in sources) {
        if (model.showIndex == index) {
            return model;
        }
    }
    return nil;
}

@end
