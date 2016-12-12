//
//  ViewController.m
//  Copyright © 2016年 QQpicture. All rights reserved.
//

#import "PictureView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "PictureCollectionViewCell.h"
#import "PictureAddCell.h"
#import "ELCImagePickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/ALAsset.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface PictureView ()<UICollectionViewDataSource,UICollectionViewDelegate,MJPhotoBrowserDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UICollectionViewDelegateFlowLayout,ELCImagePickerControllerDelegate>



@property(nonatomic,strong)NSMutableArray *itemsSectionPictureArray;

@property (nonatomic, strong) id superVC;




@end

@implementation PictureView


- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSMutableArray *)imageArray superVC:(id)superVC {
    if (self = [super initWithFrame:frame]) {
        if (imageArray!= nil && imageArray.count > 0) {
            self.itemsSectionPictureArray = [NSMutableArray array];
            self.itemsSectionPictureArray = imageArray;
        }
        self.superVC = superVC;
        [self addsubViewWithFrame:frame];
        
    }
    return self;
}


- (void)adjustFrameWithImageArray:(NSMutableArray*)imageArray {
    self.itemsSectionPictureArray = imageArray;
    
//    CGFloat height = 0;
//    if (self.itemsSectionPictureArray.count<3) {
//        height= kScreenWidth/3;
//    } else if (self.itemsSectionPictureArray.count == 3) {
//        height = kScreenWidth/3 *2;
//        
//    } else if (self.itemsSectionPictureArray.count <6) {
//        height= kScreenWidth/3*2;
//    } else if (self.itemsSectionPictureArray.count == 6) {
//        height = kScreenWidth/3*3;
//    }
//    else if (self.itemsSectionPictureArray.count <=9) {
//        height= kScreenWidth/3*3;
//    } else {
//        height= kScreenWidth/3*3;
//    }

    CGFloat height = 0;
    //2016-10-11
    if (self.itemsSectionPictureArray.count % 3 == 0) {
        height = (ceilf(self.itemsSectionPictureArray.count/3)+1) * (kScreenWidth/3);
    }else{
        height = (ceilf(self.itemsSectionPictureArray.count/3)+1) * ((kScreenWidth/3));
    }
    
    self.pictureCollectonView.frame = CGRectMake(0, 0, self.frame.size.width, height);
    
    
}



- (void)addsubViewWithFrame:(CGRect)frame {
   

    if (!self.itemsSectionPictureArray) {
        self.itemsSectionPictureArray = [[NSMutableArray alloc] init];
    }

    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
//    layout.itemSize = CGSizeMake(75, 75);
//    layout.minimumInteritemSpacing = 0;
//    layout.minimumLineSpacing = 5; //上下的间距 可以设置0看下效果
//    layout.sectionInset = UIEdgeInsetsMake(0.f, 5, 5.f, 5);
    
    
    layout.itemSize = CGSizeMake(kScreenWidth/3-10, kScreenWidth/3-10); // 自动布局
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    
    
//    
//    CGFloat height = 0;
//    if (self.itemsSectionPictureArray.count<=3) {
//        height= kScreenWidth/3;
//    } else if (self.itemsSectionPictureArray.count <=6) {
//        height= kScreenWidth/3*2;
//    } else if (self.itemsSectionPictureArray.count <=9) {
//        height= kScreenWidth/3*3;
//    } else {
//        height= kScreenWidth/3*3;
//    }
    CGFloat height = 0;
    //2016-10-11
    if (self.itemsSectionPictureArray.count % 3 == 0) {
        height = (ceilf(self.itemsSectionPictureArray.count/3)+1) * (kScreenWidth/3);
    }else{
        height = (ceilf(self.itemsSectionPictureArray.count/3)+1) * ((kScreenWidth/3));
    }
    
    //创建 UICollectionView
    self.pictureCollectonView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, height) collectionViewLayout:layout];
    [self.pictureCollectonView registerClass:[PictureCollectionViewCell class]forCellWithReuseIdentifier:@"cell"];
    [self.pictureCollectonView registerClass:[PictureAddCell class] forCellWithReuseIdentifier:@"addItemCell"];
    self.pictureCollectonView.backgroundColor = [UIColor brownColor];
    self.pictureCollectonView.delegate = self;
    self.pictureCollectonView.dataSource = self;
    [self addSubview:self.pictureCollectonView];
}







#pragma mark - collectionView 调用方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemsSectionPictureArray.count +1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.itemsSectionPictureArray.count) {
        static NSString *addItem = @"addItemCell";
        PictureAddCell *addItemCell = [collectionView dequeueReusableCellWithReuseIdentifier:addItem forIndexPath:indexPath];
        return addItemCell;
    }else
    {
        static NSString *identify = @"cell";
        PictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        cell.imageView.image = self.itemsSectionPictureArray[indexPath.row];
        return cell;
    }
}

//用代理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.itemsSectionPictureArray.count) {
        // 限制9张
        if (self.itemsSectionPictureArray.count >= 9) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"最多添加9张" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            return;
        }
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机选择",@"拍照", nil];
        sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [sheet showInView:self];
    }else
    {
        NSMutableArray *photoArray = [[NSMutableArray alloc] init];
        for (int i = 0;i< self.itemsSectionPictureArray.count; i ++) {
            UIImage *image = self.itemsSectionPictureArray[i];
            
            MJPhoto *photo = [MJPhoto new];
            photo.image = image;
            PictureCollectionViewCell *cell = (PictureCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            photo.srcImageView = cell.imageView;
            [photoArray addObject:photo];
        }
        
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.photoBrowserdelegate = self;
        browser.currentPhotoIndex = indexPath.row;
        browser.photos = photoArray;
        [browser show];
        
    }
}



#pragma mark - 删除照片
-(void)deletedPictures:(NSSet *)set
{
    NSMutableArray *cellArray = [NSMutableArray array];
    
    for (NSString *index1 in set) {
        [cellArray addObject:index1];
    }
    
    if (cellArray.count == 0) {
        
    }else if (cellArray.count == 1 && self.itemsSectionPictureArray.count == 1) {
        NSIndexPath *indexPathTwo = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [self.itemsSectionPictureArray removeObjectAtIndex:indexPathTwo.row];
        [self.pictureCollectonView deleteItemsAtIndexPaths:@[indexPathTwo]];
    }else{
        
        for (int i = 0; i<cellArray.count-1; i++) {
            for (int j = 0; j<cellArray.count-1-i; j++) {
                if ([cellArray[j] intValue]<[cellArray[j+1] intValue]) {
                    NSString *temp = cellArray[j];
                    cellArray[j] = cellArray[j+1];
                    cellArray[j+1] = temp;
                }
            }
        }
        
        for (int b = 0; b<cellArray.count; b++) {
            int idexx = [cellArray[b] intValue]-1;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idexx inSection:0];
            
            [self.itemsSectionPictureArray removeObjectAtIndex:indexPath.row];
            [self.pictureCollectonView deleteItemsAtIndexPaths:@[indexPath]];
        }
    }
    
    
    
//    CGFloat height = 0;
//    if (self.itemsSectionPictureArray.count<=3) {
//        height= kScreenWidth/3;
//    } else if (self.itemsSectionPictureArray.count <=6) {
//        height= kScreenWidth/3*2;
//    } else if (self.itemsSectionPictureArray.count <=9) {
//        height= kScreenWidth/3*3;
//    } else {
//        height= kScreenWidth/3*3;
//    }
    
    CGFloat height = 0;
    //2016-10-11
    if (self.itemsSectionPictureArray.count % 3 == 0) {
        height = (ceilf(self.itemsSectionPictureArray.count/3)+1) * (kScreenWidth/3);
    }else{
        height = (ceilf(self.itemsSectionPictureArray.count/3)+1) * ((kScreenWidth/3));
    }
    
     self.pictureCollectonView.frame = CGRectMake(0, 0, self.frame.size.width, height);
    // 重新设置 collectionView的高度
//    if (self.itemsSectionPictureArray.count <4) {
//        self.pictureCollectonView.frame = CGRectMake(0, 100, self.view.frame.size.width, 75);
//    }else if (self.itemsSectionPictureArray.count <8)
//    {
//        self.pictureCollectonView.frame = CGRectMake(0, 100, self.view.frame.size.width, 160);
//    }else
//    {
//        self.pictureCollectonView.frame = CGRectMake(0, 100, self.view.frame.size.width, 240);
//    }
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(sendSelectedImageArray:height:)]) {
        [_delegate sendSelectedImageArray:self.itemsSectionPictureArray height:height];
    }
    
}

#pragma mark - 相册、相机调用方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"点击了从手机选择");
        
        ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
        
        // 设置最多添加9张
        elcPicker.maximumImagesCount = 9 - self.itemsSectionPictureArray.count;
        elcPicker.returnsOriginalImage = YES;
        elcPicker.returnsImage = YES;
        elcPicker.onOrder = NO;
        elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie];
        elcPicker.imagePickerDelegate = self;
        //    elcPicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;//过渡特效
        [_superVC presentViewController:elcPicker animated:YES completion:nil];
        
    } else if (buttonIndex == 1) {
        
        NSLog(@"点击了拍照");
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            
            picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            [_superVC presentViewController:picker animated:YES completion:nil];
        }else{
            NSLog(@"模拟无效,请真机测试");
        }
    }
}



#pragma mark - 选取图片后的代理回调
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    __weak PictureView *wself = self;
    [_superVC dismissViewControllerAnimated:YES completion:^{
        BOOL hasVideo = NO;
        
        NSMutableArray *images = [NSMutableArray array];
        for (NSDictionary *dict in info) {
            if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
                if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                    UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                    [images addObject:image];
                } else {
                    NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
                }
            } else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo){
                if (!hasVideo) {
                    hasVideo = YES;
                }
            } else {
                NSLog(@"Uknown asset type");
            }
        }
        
        NSMutableArray *indexPathes = [NSMutableArray array];
        for (unsigned long i = wself.itemsSectionPictureArray.count; i < wself.itemsSectionPictureArray.count + images.count; i++) {
            [indexPathes addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [wself.itemsSectionPictureArray addObjectsFromArray:images];
        // 调整集合视图的高度
        
        [UIView animateWithDuration:.25 delay:0 options:7 animations:^{
            
//            if (wself.itemsSectionPictureArray.count <4) {
//                wself.pictureCollectonView.frame = CGRectMake(0, 100, wself.view.frame.size.width, 75);
//            }else if (wself.itemsSectionPictureArray.count <8)
//            {
//                wself.pictureCollectonView.frame = CGRectMake(0, 100, wself.view.frame.size.width, 160);
//            }else
//            {
//                wself.pictureCollectonView.frame = CGRectMake(0, 100, wself.view.frame.size.width, 240);
//            }
            
//            CGFloat height = 0;
//            if (self.itemsSectionPictureArray.count<=3) {
//                height= kScreenWidth/3;
//            } else if (self.itemsSectionPictureArray.count <=6) {
//                height= kScreenWidth/3*2;
//            } else if (self.itemsSectionPictureArray.count <=9) {
//                height= kScreenWidth/3*3;
//            } else {
//                height= kScreenWidth/3*3;
//            }
            
            CGFloat height = 0;
            if (self.itemsSectionPictureArray.count<3) {
                height= kScreenWidth/3;
            } else if (self.itemsSectionPictureArray.count == 3) {
                height = kScreenWidth/3 *2;
                
            } else if (self.itemsSectionPictureArray.count <6) {
                height= kScreenWidth/3*2;
            } else if (self.itemsSectionPictureArray.count == 6) {
                height = kScreenWidth/3*3;
            }
            else if (self.itemsSectionPictureArray.count <=9) {
                height= kScreenWidth/3*3;
            } else {
                height= kScreenWidth/3*3;
            }
            
            self.pictureCollectonView.frame = CGRectMake(0, 0, self.frame.size.width, height);
            
            if (_delegate && [_delegate respondsToSelector:@selector(sendSelectedImageArray:height:)]) {
                [_delegate sendSelectedImageArray:self.itemsSectionPictureArray height:height];
            }
            
            [wself layoutIfNeeded];
        } completion:^(BOOL finished) {
            
            // 添加新选择的图片
            [wself.pictureCollectonView performBatchUpdates:^{
                
                [wself.pictureCollectonView insertItemsAtIndexPaths:indexPathes];
            } completion:^(BOOL finished) {
                if (hasVideo) {
                    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"暂不支持视频发布" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                }
            }];
        }];
    }];
}


#pragma mark - 选择拍照后的代理回调
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    
    [self.itemsSectionPictureArray addObject:image];
    __weak PictureView *wself = self;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [UIView animateWithDuration:.25 delay:0 options:7 animations:^{
//            if (wself.itemsSectionPictureArray.count <4) {
//                wself.pictureCollectonView.frame = CGRectMake(0, 100, wself.view.frame.size.width, 75);
//            }else if (wself.itemsSectionPictureArray.count <8)
//            {
//                wself.pictureCollectonView.frame = CGRectMake(0, 100, wself.view.frame.size.width, 160);
//            }else
//            {
//                wself.pictureCollectonView.frame = CGRectMake(0, 100, wself.view.frame.size.width, 240);
//            }
//            CGFloat height = 0;
//            if (self.itemsSectionPictureArray.count<=3) {
//                height= kScreenWidth/3;
//            } else if (self.itemsSectionPictureArray.count <=6) {
//                height= kScreenWidth/3*2;
//            } else if (self.itemsSectionPictureArray.count <=9) {
//                height= kScreenWidth/3*3;
//            } else {
//                height= kScreenWidth/3*3;
//            }
            
            CGFloat height = 0;
            //2016-10-11
            if (self.itemsSectionPictureArray.count % 3 == 0) {
                height = (ceilf(self.itemsSectionPictureArray.count/3)+1) * (kScreenWidth/3);
            }else{
                height = (ceilf(self.itemsSectionPictureArray.count/3)+1) * ((kScreenWidth/3));
            }
            self.pictureCollectonView.frame = CGRectMake(0, 0, self.frame.size.width, height);
            [wself layoutIfNeeded];
            
            // 发送选择好的图片数组
            if (_delegate && [_delegate respondsToSelector:@selector(sendSelectedImageArray:height:)]) {
                [_delegate sendSelectedImageArray:self.itemsSectionPictureArray height:height];
            }
            
        } completion:nil];
        
        [self.pictureCollectonView performBatchUpdates:^{
            [wself.pictureCollectonView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:wself.itemsSectionPictureArray.count - 1 inSection:0]]];
        } completion:nil];
    }];
    
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [_superVC dismissViewControllerAnimated:YES completion:nil];
}


@end
