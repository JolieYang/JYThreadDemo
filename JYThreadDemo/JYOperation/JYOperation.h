//
//  JYOperation.h
//  JYThreadDemo
//
//  Created by Jolie_Yang on 16/8/29.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

// 参考： http://www.cnblogs.com/Jepson1218/p/5180915.html

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface JYOperation : NSOperation
@property (nonatomic, strong) UIImageView *imageView;
@end


@protocol JYOperationDelegate <NSObject>
- (void)downloadImage:(UIImage *)image;
@end
// 通过代理进行消息传递
@interface JYDelegateOperation : NSOperation
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, weak) id<JYOperationDelegate> delegate;
@end

// 通过Block进行消息传递
typedef void(^DownloadImageBlock)(UIImage *image);
@interface JYBlockOperation : NSOperation
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, copy) DownloadImageBlock downloadBlock;
- (void)downloadImageWithBlock:(DownloadImageBlock)block;
@end

// 通过通知实现消息传递
@interface JYNotificationOperation : NSOperation
@property (nonatomic, copy) NSString *urlStr;
@end


@interface DownloadImage : NSObject
+(UIImage *)imageWithURLStr:(NSString *)urlStr;
@end