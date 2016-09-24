//
//  ViewController.m
//  FloatButton
//
//  Created by Hoolai on 16/8/2.
//  Copyright © 2016年 wsj_proj. All rights reserved.
//

#import "ViewController.h"
#import "FloatingViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    FloatingViewController* floatVc = [[FloatingViewController alloc] init];
    [self addChildViewController:floatVc];
    self.view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:floatVc.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
