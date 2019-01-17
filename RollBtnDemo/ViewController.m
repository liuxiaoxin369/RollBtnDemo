//
//  ViewController.m
//  RollBtnDemo
//
//  Created by qzwh on 2019/1/17.
//  Copyright © 2019年 qianjinjia. All rights reserved.
//

#import "ViewController.h"
#import "ZSRollBtn.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ZSRollBtn *rollBtn = [[ZSRollBtn alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50) titleArr:@[@"标题一", @"标题二", @"标题三", @"标题四", @"标题五", @"标题六", @"标题七", @"标题八", @"标题九", @"标题十"]];
    [rollBtn clickBtnWithIndex:^(NSInteger index) {
        NSLog(@"当前点击按钮的下标：%ld", index);
    }];
    [self.view addSubview:rollBtn];
}


@end
