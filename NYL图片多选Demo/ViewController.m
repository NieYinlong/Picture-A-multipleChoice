//
//  ViewController.m
//  NYL图片多选Demo
//
//  Created by YinlongNie on 16/6/30.
//  Copyright © 2016年 Jiuzhekan. All rights reserved.
//

#import "ViewController.h"

// 注意这是继承自 UIView并不是控制器

#import "PictureView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<PictureViewDelegate>


@property (nonatomic, strong) PictureView *pictureView;

@property (nonatomic, strong) NSMutableArray *addImageArray;

@property (nonatomic, assign) CGFloat height;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"图片多选!!!!");
    
    self.height = kScreenWidth/3;
    
    self.addImageArray = [NSMutableArray array];
    // 创建
    self.pictureView = [[PictureView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, self.height) imageArray:self.addImageArray superVC:self];
    self.pictureView.delegate = self;
    
    [self.view addSubview:self.pictureView];
    
}


#pragma mark - 代理
- (void)sendSelectedImageArray:(NSMutableArray *)imageArray height:(CGFloat)height {
    
    [_pictureView adjustFrameWithImageArray:imageArray];
    
    self.height = height;
    
    self.pictureView.frame = CGRectMake(0, 100, kScreenWidth, self.height);
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
