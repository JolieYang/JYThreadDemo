//
//  JYGCDViewController.h
//  JYThreadDemo
//
//  Created by Jolie on 16/8/27.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

// 今天比较累，具体的理解明天开始吧 -- 27th,August,2016
// GCD队列:
//1) 公开的5个队列： 运行在主线程的队列(dispatch_get_main_queue())， 三个不同优先级的后台队列(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW/DISPATCH_QUEUE_PRIORITY_DEFAULT/DISPATCH_QUEUE_PRIORITY_HIGH, 0))， 一个优先级更低的后台队列(DISPATCH_QUEUE_PRIORITY_BACKGROUND)
// 2)自定义队列，分为串行和并发队列

@interface JYGCDViewController : UIViewController

@end
