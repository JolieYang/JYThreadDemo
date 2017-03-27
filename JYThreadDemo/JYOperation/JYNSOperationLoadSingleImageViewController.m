//
//  JYNSOperationViewController.m
//  JYThreadDemo
//
//  Created by Jolie_Yang on 16/8/26.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

// NSBlockOperation 与 NSInvocationOperation

#import "JYNSOperationLoadSingleImageViewController.h"
#import "JYGCDViewController.h"
#import <objc/runtime.h>

static NSString * const Image_URL = @"http://img.blog.csdn.net/20160823161814146";
static NSString * const Flower_URL = @"http://img.blog.csdn.net/20160822174348226";

typedef NS_ENUM(NSInteger, JYOpearationType) {
    JYOpearationTypeInvocation = 0,
    JYOpearationTypeBlock = 1
};

@interface JYNSOperationLoadSingleImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIButton *invocationBtn;
@property (weak, nonatomic) IBOutlet UIButton *blockBtn;

@property (nonatomic, assign) JYOpearationType type;
@property (nonatomic, strong) NSOperationQueue *invocationQueue;
@property (nonatomic, strong) NSInvocationOperation *operation;
@end

@implementation JYNSOperationLoadSingleImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// 1.使用NSInvocationOperation加载图片
- (IBAction)invocationOperationLoadPictureAction:(id)sender {
    self.type = JYOpearationTypeInvocation;
    [self loadImageWithInvocationOperation];
}
// 暂停
- (IBAction)suspendAction:(id)sender {
    [self.invocationQueue setSuspended:YES];
}
// 恢复
- (IBAction)resumeAction:(id)sender {
    [self.invocationQueue setSuspended:NO];
}
// 取消
- (IBAction)cancelAction:(id)sender {
//    [self.operation cancel];
    [self.invocationQueue cancelAllOperations];
}

// 2.使用NSBlockOperation加载图片
- (IBAction)blockOperationLoadPictureAction:(id)sender {
    self.type = JYOpearationTypeBlock;
    [self loadImageWithBlockOperation];
}

- (void)loadImageWithInvocationOperation {
    // 创建好操作以后并没有调用
//    NSOperationQueue *opQueue = [[NSOperationQueue alloc] init];
    self.invocationQueue = [[NSOperationQueue alloc] init];
    self.operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadImage) object:nil];
    
    // 添加到队列后调用
    [self.invocationQueue addOperation:self.operation];
}

- (void)loadImageWithBlockOperation {
    NSOperationQueue *opQueue = [[NSOperationQueue alloc] init];
    // m1
    NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock:^{
        [self loadImage];
    }];
    [opQueue addOperation:blockOp];
    
    // m2
//    [opQueue addOperationWithBlock:^{
//        [self loadImage];
//    }];
}


- (NSData *)requestImageData {
    NSData *imageData;
    if (self.type == JYOpearationTypeInvocation) {
        NSURL *url = [NSURL URLWithString:Flower_URL];
        imageData = [NSData dataWithContentsOfURL:url];
    } else {
        NSURL *url = [NSURL URLWithString:Image_URL];
        imageData = [NSData dataWithContentsOfURL:url];
    }
    
    return imageData;
}

- (void)updateImage:(NSData *)imageData {
    if (self.type == JYOpearationTypeInvocation) {
        self.imageView.image = [UIImage imageWithData:imageData];
        [self.invocationBtn setTitle:@"加载成功" forState:UIControlStateNormal];
    } else {
        self.secondImageView.image = [UIImage imageWithData:imageData];
        [self.blockBtn setTitle:@"加载成功" forState:UIControlStateNormal];
    }
}

- (void)loadImage {
    UIButton *button;
    if (self.type == JYOpearationTypeInvocation) {
        button = self.invocationBtn;
    } else {
        button = self.blockBtn;
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [button setTitle:@"加载中" forState:UIControlStateNormal];
    });
    NSData *imageData = [self requestImageData];
    if (!imageData) {
        // m3--GCD
        dispatch_sync(dispatch_get_main_queue(), ^{
            [button setTitle:@"加载失败" forState:UIControlStateNormal];
        });
        return;
    }
    
    // m1--NSThread
//    [self performSelectorOnMainThread:@selector(updateImage:) withObject:imageData waitUntilDone:YES];
    // m2--NSOperationQueue
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self updateImage:imageData];
    }];
    
    
}

@end



