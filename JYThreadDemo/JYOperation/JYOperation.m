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
