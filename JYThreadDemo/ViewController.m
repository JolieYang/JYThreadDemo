//
//  ViewController.m
//  JYThreadDemo
//
//  Created by Jolie_Yang on 16/8/22.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "ViewController.h"

// https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/Multithreading/Introduction/Introduction.html#//apple_ref/doc/uid/10000057i-CH1-SW1 线程开发

// NSThread
// Operation
// GCD(Grand Central Dispatch)

// About Threaded Programming 介绍线程的相关概念与在程序设计中所扮演的角色
// Thread Management 创建 管理线程
// Run Loops 介绍了辅助线程中的事件处理循环
// Sychronization 线程同步 介绍同步问题与防止多线程导致破坏数据或程序崩溃的工具
// Thread Safety Summary 线程安全

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
