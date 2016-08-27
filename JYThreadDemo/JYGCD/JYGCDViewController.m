//
//  JYGCDViewController.m
//  JYThreadDemo
//
//  Created by Jolie on 16/8/27.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "JYGCDViewController.h"

static int image_count = 9;
static NSString * const Base_URL = @"http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_";// http://images.cnblogs.com/cnblogs_com/kenshincui/613474/o_%i.jpg

@interface JYGCDViewController()
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;
@property (weak, nonatomic) IBOutlet UIButton *loadBtn;
@end

@implementation JYGCDViewController
- (IBAction)sequenceLoadImgAction:(id)sender {
    [self loadImageWithMultiThread];
    
}
- (void)loadImageAtIndex:(int)index {
    NSData *imageData = [self requestImageDataAtIndex:index];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
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
- (void)loadImageWithMultiThread {
    dispatch_queue_t serialQueue = dispatch_queue_create("sequence", DISPATCH_QUEUE_SERIAL);
    for (int i = 0; i < image_count; i++) {
        dispatch_async(serialQueue, ^{
            [self loadImageAtIndex:i];
        });
    }
}
@end
