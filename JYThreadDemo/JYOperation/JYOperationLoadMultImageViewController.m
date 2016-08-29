//
//  JYOperationLoadMultImageViewController.m
//  JYThreadDemo
//
//  Created by Jolie_Yang on 16/8/26.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

// 要点：
// 1. 操作队列的基本使用: InvocationOperation/BlockOperation NSOperationQueue -addOperation
// 2.[todo] 线程状态控制  这个明天再研究，今天先到这吧，我要去看看Networking模块了 26th,August,2016
// 3. 队列:主队列和自定义队列(在后台执行)。
// 4. 子类化NSOperation,NSOperation是抽象基类，系统封装了NSBlockOperation和NSInvocationOperation。也可通过继承重写start或者main方法定制operations。start需管理线程状态, main无需管理线程状态，简单但不如start灵活
// 特点： 1) 可添加操作依赖，保证操作的执行顺序。注意：操作依赖需在添加到队列前添加，不要添加循环操作依赖

// Question List:
// ?1. 在JYNSOperationViewController中， 对于一张图片的加载进行暂停，取消操作失败。目前还不知道原因 留着明天解决吧 -- 29th,August,2016

// 小结： 使用NSOperationQueue 整体体验还是非常不错的，不论是NSThread，NSOperationQueue,GCD，苹果在推出更高抽象层级的API时并没有deprecated原先的API ,也就是表明不同的API是有相应的使用场景以及不同的限制。NSThread目前还不是很清楚它独有的使用场景。而OperationQueue与GCD是抽象层级相对高一点的API,基于队列而不是直接操作线程。对开发者真的是友好很多啊。NSOperationQueue是基于GCD的Cocoa抽象(ps: GCD是基于C的抽象API，效率会比较高一点), 其中NSOperationQueue有两点是非常友好的，1. 可以控制特定队列中并发的数目。2. 操作依赖这一特性可以相对友好的控制线程的执行顺序。
// 总结(GCD/NSOperation):
// GCD: 简单的开启线程/回到主线程,效率更高且简单
// NSOperationQueue: 需根据用户需求管理线程时操作依赖能够很好的满足。

#import "JYOperationLoadMultImageViewController.h"

static int image_count = 9;
static NSString * const Base_URL = @"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_";// http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_%i.jpg

@interface JYOperationLoadMultImageViewController ()
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;
@property (weak, nonatomic) IBOutlet UIButton *loadBtn;

@property (nonatomic, strong) NSOperationQueue *opQueue;
@end

@implementation JYOperationLoadMultImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 加载多张图片
- (IBAction)loadImageAction:(id)sender {
    [self loadImageWithMultiOperation];
}
// 加载多张图片--优先加载最后一张图片 [操作依赖]
- (IBAction)loadLastImageFirstAction:(id)sender {
    [self loadLastImageFirstWithMultiOperation];
}
// 暂停
- (IBAction)suspendAction:(id)sender {
    [self.opQueue setSuspended:YES];
}
//取消
- (IBAction)cancelAction:(id)sender {
    [self.opQueue cancelAllOperations];
}
//恢复
- (IBAction)resumeAction:(id)sender {
    [self.opQueue setSuspended:NO];
}

- (void)loadImageWithMultiOperation {
    self.opQueue = [[NSOperationQueue alloc] init];
    self.opQueue.maxConcurrentOperationCount = 5;// 设置最大并发线程数目 [控制并发数目]
    
    for (int i = 0 ; i < image_count; i++) {
        [self.opQueue addOperationWithBlock:^{
            [self loadImageAtIndex:i];
        }];
    }
}

- (void)loadLastImageFirstWithMultiOperation {
    NSOperationQueue *opQueue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *lastBlockOp = [NSBlockOperation blockOperationWithBlock:^{
        [self loadImageAtIndex: image_count - 1];
    }];
    
    for (int i = 0; i < image_count - 1; i++) {
        NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock:^{
            [self loadImageAtIndex:i];
        }];
        [blockOp addDependency: lastBlockOp];
        [opQueue addOperation:blockOp];
    }
    [opQueue addOperation:lastBlockOp];
}

- (void)loadImageAtIndex:(int)index {
    NSData *imageData = [self requestImageDataAtIndex:index];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self updateImageWithData:imageData AtIndex:index];
    }];
}

- (NSData *)requestImageDataAtIndex:(int)index {
    NSString *urlStr = [NSString stringWithFormat:@"%@%i.jpg", Base_URL, index];
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
    return imageData;
}
- (void)updateImageWithData:(NSData *)imageData AtIndex:(int)index {
    UIImageView *imageView = self.imageViews[index];
    imageView.image = [UIImage imageWithData:imageData];
}

@end
