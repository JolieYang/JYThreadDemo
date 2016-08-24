//
//  JYNSThreadViewController.m
//  JYThreadDemo
//
//  Created by Jolie_Yang on 16/8/22.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

// https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/Multithreading/CreatingThreads/CreatingThreads.html#//apple_ref/doc/uid/10000057i-CH15-SW19

// Threads can also be used to divide a large job into several smaller jobs, which can lead to performance increases on multi-core computers. 多线程可以将一个大的任务分解成多个小的任务，在多核系统中可以提高性能。
// NSThread.h
// 相对轻量级的多线程开发 需要管理线程的生命周期，线程同步对数据加锁有一定的数据开销(多个线程访问同一数据前，需加锁)

// 初始化生成线程：
// 1).类方法detachNewThreadSelector:toTarget:withObject: // 创建一个分离(detach)线程,分离线程即线程退出后系统会自动回收线程资源,也意味着代码中无需显示的开启线程; selector 线程的入口点
// 2). 初始化方法 initWithTarget: selector: withObject // 然后需调用start  OS X10.5以前使用NSThread对象会获取到一个线程，虽然可以配置和获取线程属性，但此时线程已经在运行，主要是用来监测已经在运行的线程。OS X10.5以后，可创建NSThread对象实例并通过start方法生成一个相应的新线程,该特性主要是支持在开启线程前可以配备线程属性
// 配置线程属性:
// 1) 配置线程堆栈大小 stackSize

// -main [todo] ?? 也不是很懂
// [toread] http://blog.csdn.net/jiantiantian/article/details/13622821 http://blog.sina.com.cn/s/blog_7b9d64af01019j2n.html  --23rd,August,2016

#import "JYNSThreadViewController.h"

#define FLOWER_URL @"http://img.blog.csdn.net/20160822174348226" // 图片比较大，1M多
#define CAT_URL @"http://img.blog.csdn.net/20160823161814146" // 图片小一点,19kb

@interface JYNSThreadViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *catImageView;

@property (nonatomic, strong) NSThread *thread;

@end

@implementation JYNSThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)creatThread {
    // m1
    [NSThread detachNewThreadSelector:@selector(downloadPicture:) toTarget:self withObject:nil];
    // m2
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(downloadPicture:) object:nil];
    // 配置线程属性
    thread.stackSize = 12; // 堆栈大小
    thread.name = @"threadName"; // 设置接收器的名称
    thread.qualityOfService = NSQualityOfServiceUserInteractive;// 接收器的优先级
    [thread start];
    
    // m3
    NSThread *mainThread = [NSThread mainThread];
    [self performSelector:@selector(downloadPicture:) onThread:mainThread withObject:nil waitUntilDone:YES];//   you should not use the method for time critical or frequent communication between threads 最好不要在紧急的时间节点或需频繁进行线程处理时调用该方法 ?: 所以其实我也不是很懂生命时候会用到这个，如果是在主线程，performSelectorOnMainThread跟这个有什么区别
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 加载图片
- (IBAction)loadPictureAction:(id)sender {
    [self loadingImageView: self.imageView];
//    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(downloadPicture:) object:FLOWER_URL];
//    [thread start];
    
    // 线程状态  isExecuting 正在执行 isFinished 执行完毕 isCancel 是否取消
    // 线程开启后，执行cancel后 isExecuting YES; isCancel YES; isFinished NO // isExecuting为什么为YES
    // 再点击加载图片 isExecuting YES;isCancel NO; isFinished NO
    if ([self.thread isExecuting]) {
        return;
    }
    
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(downloadPicture:) object:FLOWER_URL];
    [self.thread start];
}
- (IBAction)cancelLoadPictureAction:(id)sender {
    [self.thread cancel];
//    [NSThread exit]; // 点击取消加载按钮则界面会停止响应  分析： 应为是在主线程中执行，那如何在self.thread中执行呢
    //  When you detach new thread, These UI specific methods execute only on main thread so the exit/cancel applies to the main thread which is obviously wrong. --stackoverflow
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        [NSThread exit];
//    });
    
//    [NSThread detachNewThreadSelector:@selector(exitThread) toTarget:self withObject:nil];

}

// stackoverflow中 http://stackoverflow.com/questions/7401268/how-to-cancel-or-stop-nsthread?rq=1 Maulik 说可以使用[NSThread exit]
// "It seems like you exit from mainthread maybe. But check adding of subviews, may be you just use wrong object" ? 仍旧无法理解如何使用exit 停止线程，并且exit官方文档说是终止当前线程，所以思路应该是先获取到self.thread，然后再进行操作，可是这要怎么实现呢

- (void)exitThread {
    [NSThread exit];
}
// 加载图片－Cat
- (IBAction)loadAnotherPictureAction:(id)sender {
    [self loadingImageView: self.catImageView];
    [NSThread detachNewThreadSelector:@selector(downloadPicture:) toTarget:self withObject:CAT_URL];
}

- (void)loadingImageView:(UIImageView *)imageView {
    imageView.image = [UIImage imageNamed:@"loading_image"];
}

- (void)downloadPicture:(NSString *)urlString {
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    // 需在主线程中进行UI更新
    if ([urlString isEqualToString:CAT_URL]) {
        [self performSelectorOnMainThread:@selector(updateCatImage:) withObject:image waitUntilDone:NO];
    } else {
        [self performSelectorOnMainThread:@selector(updateImage:) withObject:image waitUntilDone:NO];// waitUntilDone当前线程是否阻塞直到selector执行完毕,注意:当前线程如果为主线程，则设置改参数为YES无效。［todo]? 不是很懂,崔江涛在博客中说这个属性代表"是否在线程任务完成后执行" YES/NO有什么区别，测试的时候没发现啊
    }
}
- (void)updateImage:(UIImage *)image {
    self.imageView.image = image;
}
- (void)updateCatImage:(UIImage *)image {
    self.catImageView.image = image;
}

@end
