//
//  FloatModel.h
//  FloatButton
//
//  Created by Hoolai on 16/8/2.
//  Copyright © 2016年 wsj_proj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FloatViewCallback)(NSInteger index);

@interface FloatModel : NSObject

@property (nonatomic, copy)NSString* imageName;
@property (nonatomic, copy)NSString* title;
@property (nonatomic, assign) NSInteger showIndex;
@property (nonatomic, assign) FloatViewCallback viewCallback;

@end
