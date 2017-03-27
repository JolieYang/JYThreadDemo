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
// 2)自定义队列，分为串行(dispatch_queue_create("sequence", DISPATCH_QUEUE_SERIAL))和并发队列


// from http://www.cnblogs.com/Jepson1218/p/5180915.html
// GCD 底层是C语言 iOS4.0推出。 停止加入queue的block，要写复杂的代码(todo:如何停止加入队列的block)。
// GCD 高级功能： dispatch_once; 延迟操作dispatch_after; 调度组dispatch_group

// NSOperation iOS2.0推出，推出GCD以后，对底层进行了重写，基于GCD进行封装。 可以取消准备执行的操作，操作依赖，设置优先级
// NSOperation高级功能: 设置最大操作并发数； 继续/暂停/全部取消; 设置队列依赖关系

@interface JYGCDViewController : UIViewController
@end

@interface JYGCDViewController (Other)
- (void)testPrivateMethod;
@end
