//
//  JYNSThreadViewController.m
//  JYThreadDemo
//
//  Created by Jolie_Yang on 16/8/22.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

// https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/Multithreading/CreatingThreads/CreatingThreads.html#//apple_ref/doc/uid/10000057i-CH15-SW19

// NSThread.h
// 相对轻量级的多线程开发 需要管理线程的生命周期，线程同步对数据加锁有一定的数据开销(多个线程访问同一数据前，需加锁)

// 初始化生成线程：
// 1).类方法detachNewThreadSelector:toTarget:withObject: // 创建一个分离线程,分离线程即线程退出后系统会自动回收线程资源,也意味着代码中无需显示的开启线程; selector 线程的入口点
// 2). 初始化方法 initWithTarget: selector: withObject // 然后需调用start  OS X10.5以前使用NSThread会立即生成一个线程，虽然可以配置和获取线程属性，但此时线程已经在运行。OS X10.5以后，创建NSThread对象并不会立即生成一个相应的新线程,该特性主要是支持在开启线程前可以配备线程属性


// -main ??
#import "JYNSThreadViewController.h"

#define PICTURE_URL @"http://img.blog.csdn.net/20160822174348226"

@interface JYNSThreadViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation JYNSThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)creatThread {
    // m1
    [NSThread detachNewThreadSelector:@selector(downloadAnotherPicture) toTarget:self withObject:nil];
    // m2
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(downloadPicture) object:nil];
    [thread start];
    
    // m3
    NSThread *mainThread = [NSThread mainThread];
    NSThread *currentThread = [NSThread currentThread];
    [self performSelector:@selector(downloadPicture) onThread:mainThread withObject:nil waitUntilDone:YES];//   you should not use the method for time critical or frequent communication between threads 最好不要在紧急的时间节点或需频繁进行线程处理时调用该方法
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 加载图片
- (IBAction)loadPictureAction:(id)sender {
    [self performSelectorInBackground:@selector(downloadPicture) withObject:nil];
}

- (void)downloadPicture {
    NSURL *url = [[NSURL alloc] initWithString:PICTURE_URL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    self.imageView.image = image;
}

- (void)downloadAnotherPicture {
    
}
@end
