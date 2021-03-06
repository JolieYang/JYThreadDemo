//
//  JYGCDViewController.m
//  JYThreadDemo
//
//  Created by Jolie on 16/8/27.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

// 如何获取到queue中加载图片的状态，比如是否全部加载完毕，还是加载了部分图片等。 -- 8th,March,2017
#import "JYGCDViewController.h"

static int image_count = 9;
static NSString * const Base_URL = @"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_";// http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_%i.jpg

@interface JYGCDViewController()
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;
@property (weak, nonatomic) IBOutlet UIButton *loadBtn;

@property (nonatomic, strong) dispatch_queue_t serialQueue;
@end

@implementation JYGCDViewController
- (void)testPrivateMethod {
    NSLog(@"test Private Method");
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
// 多线程加载图片
- (IBAction)loadImageAction:(id)sender {
    [self loadImageWithMultiThread];
}

// 按顺序加载图片
- (IBAction)sequenceLoadImgAction:(id)sender {
    [self loadImageSequenceWithMultiThread];
    
}
// 暂停加载
- (IBAction)suspendLoadImageAction:(id)sender {
    dispatch_suspend(self.serialQueue);
}
// 恢复加载
- (IBAction)resumeLoadImageAction:(id)sender {
    dispatch_resume(self.serialQueue);
}

- (void)loadImageAtIndex:(int)index {
    NSData *imageData = [self requestImageDataAtIndex:index];
    
    // UI界面的更新最好同步
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateImageWithData:imageData AtIndex:index];
    });
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
- (void)loadImageSequenceWithMultiThread {
    if (!self.serialQueue) {
        self.serialQueue = dispatch_queue_create("sequence", DISPATCH_QUEUE_SERIAL);
    }
    for (int i = 0; i < image_count; i++) {
        dispatch_async(self.serialQueue, ^{
            [self loadImageAtIndex:i];
        });
    }
}
- (void)loadImageWithMultiThread {
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < image_count; i++) {
        dispatch_async(globalQueue, ^{
            [self loadImageAtIndex:i];
        });
    }
}
@end
@implementation JYGCDViewController (Other)


@end
