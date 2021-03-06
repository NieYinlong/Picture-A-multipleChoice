//
//  PictureViewController.h
//  Copyright © 2016年 QQpicture. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol PictureViewDelegate <NSObject>

// 代理方法
@optional
/**
 *  // nyl 发送选择好的图片 已经collectView的高度
 *
 *  @param imageArray 图片对象数组
 *  @param height     需要调节的高度
 */
- (void)sendSelectedImageArray:(NSMutableArray *)imageArray height:(CGFloat)height;

@end

@interface PictureView : UIView




@property(nonatomic,strong)UICollectionView *pictureCollectonView;

// nyl
@property (nonatomic, assign) id<PictureViewDelegate>delegate;


/**
 *  自定义初始化方法
 *
 *  @param frame      frame
 *  @param imageArray 图片数组 可为nil
 *  @param superVC    控制器
 */
- (instancetype)initWithFrame:(CGRect)frame  imageArray:(NSMutableArray *)imageArray superVC:(id)superVC;


/**
 *  根据调节UIcollectionView的高度
 *
 *  @param imageArray 图片数组
 */
- (void)adjustFrameWithImageArray:(NSMutableArray*)imageArray;



@end
