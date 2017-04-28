//
//  ViewController.m
//  YYPageController
//
//  Created by sky　 on 2017/4/28.
//  Copyright © 2017年 yy. All rights reserved.
//






#import "ViewController.h"
#import "YYPageViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (IBAction)clickAction:(id)sender {
    YYPageViewController *pageVC = [YYPageViewController new];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:pageVC   ];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
