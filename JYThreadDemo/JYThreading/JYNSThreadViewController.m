//
//  JYNSThreadViewController.m
//  JYThreadDemo
//
//  Created by Jolie_Yang on 16/8/22.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "JYNSThreadViewController.h"

#define PICTURE_URL @"http://img.blog.csdn.net/20160822174348226"

@interface JYNSThreadViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation JYNSThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 加载图片
- (IBAction)loadPictureAction:(id)sender {
    [self performSelectorInBackground:@selector(downloadPicture) withObject:nil];
}

- (void)downloadPicture {
    NSURL *url = [[NSURL alloc] initWithString:PICTURE_URL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    self.imageView.image = image;
}
@end
