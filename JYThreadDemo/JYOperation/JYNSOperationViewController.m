//
//  JYNSOperationViewController.m
//  JYThreadDemo
//
//  Created by Jolie_Yang on 16/8/26.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "JYNSOperationViewController.h"

static NSString * const Image_URL = @"http://img.blog.csdn.net/20160823161814146";

typedef NS_ENUM(NSInteger, JYOpearationType) {
    JYOpearationTypeInvocation = 0,
    JYOpearationTypeBlock = 1
};

@interface JYNSOperationViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIButton *invocationBtn;
@property (weak, nonatomic) IBOutlet UIButton *blockBtn;

@property (nonatomic, assign) JYOpearationType type;
@end

@implementation JYNSOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// 使用NSInvocationOperation加载图片
- (IBAction)invocationOperationLoadPictureAction:(id)sender {
    self.type = JYOpearationTypeInvocation;
    [self loadImageWithInvocationOperation];
}

// 使用NSBlockOperation加载图片
- (IBAction)blockOperationLoadPictureAction:(id)sender {
    self.type = JYOpearationTypeBlock;
    [self loadImageWithBlockOperation];
}

- (void)loadImageWithInvocationOperation {
    // 创建好操作以后并没有调用
    NSInvocationOperation *inOp = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadImage) object:nil];
    
    NSOperationQueue *opQueue = [[NSOperationQueue alloc] init];
    [opQueue addOperation:inOp];
}

- (void)loadImageWithBlockOperation {
    NSOperationQueue *opQueue = [[NSOperationQueue alloc] init];
    [opQueue addOperationWithBlock:^{
        [self loadImage];
    }];
}


- (NSData *)requestImageData {
    NSURL *url = [NSURL URLWithString:Image_URL];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    
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
    
    [button setTitle:@"加载中" forState:UIControlStateNormal];
    NSData *imageData = [self requestImageData];
    if (!imageData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [button setTitle:@"加载失败" forState:UIControlStateNormal];
        });
        return;
    }
    
    // m1--NSThread
//    [self performSelectorOnMainThread:@selector(updateImage:) withObject:imageData waitUntilDone:YES];
    // m2--NSOperation
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self updateImage:imageData];
    }];
}

@end
