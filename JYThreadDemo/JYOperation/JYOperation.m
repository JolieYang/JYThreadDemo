//
//  JYOperation.m
//  JYThreadDemo
//
//  Created by Jolie_Yang on 16/8/29.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "JYOperation.h"

@implementation JYOperation
- (void)main {
    UIImage *image = [self downloadImage];
    
    // 通过传入imageView
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = image;
    });
}
- (UIImage *)downloadImage {
    NSURL *url = [NSURL URLWithString:@""];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    
    return image;
}
@end


@implementation JYDelegateOperation
- (void)main {
    UIImage *image = [DownloadImage imageWithURLStr:self.urlStr];
    // 通过代理进行消息传递
    dispatch_sync(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(downloadImage:)]) {
            [self.delegate downloadImage:image];
        }
    });
}
@end


@implementation JYBlockOperation
- (void)downloadImageWithBlock:(DownloadImageBlock)block {
    if (block) {
        self.downloadBlock = block;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [DownloadImage imageWithURLStr:self.urlStr];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (self.downloadBlock) {
                    self.downloadBlock(image);
                    block(image);
                }
            });
        });
    }
}
@end

@implementation JYNotificationOperation
- (void)main {
    UIImage *image = [DownloadImage imageWithURLStr:self.urlStr];
    
    // 1.注册通知: 在UIViewcontroller中需在viewDidLoad中注册通知 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpImageWithNotify:) name:@"FinishDownLoadImage" object:nil];
    // 2. 接收到通知后进行相应操作: 定义setUpImageWithNotify:(NSNotification *)notification方法 self.imageView.image = notification.object
    // 3. 移除通知: 在通知用完后dealloc需移除
    dispatch_sync(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didFinishDownloadImage" object:image];
    });
}
@end

@implementation DownloadImage
+ (UIImage *)imageWithURLStr:(NSString *)urlStr {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    
    return image;
}
@end