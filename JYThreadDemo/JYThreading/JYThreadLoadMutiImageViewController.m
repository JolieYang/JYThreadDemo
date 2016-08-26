//
//  JYThreadLoadMutiImageViewController.m
//  JYThreadDemo
//
//  Created by Jolie_Yang on 16/8/25.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//


// Questin List:
// ?1. 好奇什么时候使用NSThread优于其他两个。经常看到的就是NSThread相对于其他两个轻量，轻量了然后带来了什么呢
// ?2. 文档中提到该方法并不会回收在执行过程中分配的内存和资源。那eixt跟cancel的区别在哪里呢

// 小结：反正用NSThread我个人的感觉是体验真的很不好，第一，线程生命周期需自己管理，但仍然无法很好的控制。第二， 比如cancel中断了一个线程，想线程重启，发现并没有相关的API，提供的操作也很有限啊， 要你何用啊NSThread. 好奇什么时候使用NSThread优于其他两个。经常看到的就是NSThread相对于其他两个轻量，轻量了然后带来了什么呢。 25th,August,2016

#import "JYThreadLoadMutiImageViewController.h"

@implementation JYImageData
@end

@interface JYThreadLoadMutiImageViewController ()
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;
@property (weak, nonatomic) IBOutlet UIButton *loadBtn;

@property (nonatomic, strong) NSMutableArray<NSThread *> *threads;
@end

@implementation JYThreadLoadMutiImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.threads = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 加载图片
- (IBAction)loadMultiImageAction:(id)sender {
    [self loadImagesWithMultiThread];
}
// 停止加载图片
- (IBAction)stopLoadImageAction:(id)sender {
    for (int i = 0 ; i < self.threads.count; i++) {
        NSThread *thread = self.threads[i];
        if (![thread isFinished]) {
            [thread cancel];// ?1.或者cancel后在这个时候线程状态isFinished为False,当loadImagesWithMultiThread中查看该线程状态isFinished竟然为True。甚至还有比较极端的情况，打印了这个线程cancel，但这个线程加载的照片竟然还可以显示出来。反正用NSThread我个人的感觉是体验真的很不好，第一，线程生命周期需自己管理，但仍然无法很好的控制。第二， 比如cancel中断了一个线程，想线程重启，发现并没有相关的API，提供的操作也很有限啊， 要你何用啊NSThread. 好奇什么时候使用NSThread优于其他两个。经常看到的就是NSThread相对于其他两个轻量，轻量了然后带来了什么呢
            NSLog(@"cancel thread:%@", thread);
        }
    }
}

- (JYImageData *)requestImageDataAtIndex:(NSNumber *)index {
    if (index.intValue == 2) {
        // 第二张照片休眠2秒再进行加载
        [NSThread sleepForTimeInterval:2.0];
    }
    
    int i = [index intValue];
    NSString *urlStr = [NSString stringWithFormat:@"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_%i.jpg", i];
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    JYImageData *imageData = [[JYImageData alloc] init];
    imageData.index = i;
    imageData.data = data;
    return imageData;
}
- (void)updateImageViewWithImageData:(JYImageData *)imageData {
    UIImageView *imageView = self.imageViews[imageData.index];
    imageView.image = [UIImage imageWithData:imageData.data];
}
- (void)loadImageAtIndex:(NSNumber *)index {
    JYImageData *imageData = [self requestImageDataAtIndex:index];
    
    if ([[NSThread currentThread] isCancelled]) {
        NSLog(@"exit thread:%@", [NSThread currentThread]);
        [NSThread exit];// "一旦退出就不能再使用start开启。"上网看的这句话，感觉有些奇怪的一句话，一个线程只能start一次，重复start只会崩溃啊。讲的令我以为如果不是退出，比如是cancel就可以再使用start继续线程的感觉。  ?2.[todo] 文档中提到该方法并不会回收在执行过程中分配的内存和资源。那eixt跟cancel的区别在哪里呢
        // 资料：http://www.cocoachina.com/bbs/read.php?tid=50702   不建意使用exit这种方法，通过标志位判断进行线程中止比较合适。一般写多线程的程序，比如线程代码较多，本应该在在线程代码中多写判断的代码。
        NSLog(@"exit aaaa");// ps: 测试了下这句以及后面的已经不会执行了，因而执行完exit不用多次一举再写个return
        return;
    }
    
    [self performSelectorOnMainThread:@selector(updateImageViewWithImageData:) withObject:imageData waitUntilDone:YES];
}

- (void)loadImagesWithMultiThread {
    if (self.threads.count == 9) {
        for (int i = 0; i < self.threads.count; i++) {
            NSThread *thread = self.threads[i];
            if (!thread.isFinished) {
                NSLog(@"thread isUnFinished");
                [thread main];
            }
            
            continue;
        }
        
        return;
    }
    for (int i = 0; i < self.imageViews.count; i++) {
        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(loadImageAtIndex:) object:[NSNumber numberWithInt:i]];
        if (i == 4) {
            thread.threadPriority = 1.0;
        }
        [self.threads addObject:thread];
        [thread start];
    }
}

@end
