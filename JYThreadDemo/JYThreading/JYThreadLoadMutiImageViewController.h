//
//  JYThreadLoadMutiImageViewController.h
//  JYThreadDemo
//
//  Created by Jolie_Yang on 16/8/25.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

//demo from http://blog.csdn.net/jianxin160/article/details/47753225
// 主要是为了测试[NSThread exit]这个函数

@interface JYImageData : NSObject
@property (nonatomic, strong) NSData *data;
@property (nonatomic, assign) int index;
@end

@interface JYThreadLoadMutiImageViewController : UIViewController

@end

