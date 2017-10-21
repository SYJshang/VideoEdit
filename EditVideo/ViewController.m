//
//  ViewController.m
//  EditVideo
//
//  Created by 尚勇杰 on 2017/10/17.
//  Copyright © 2017年 尚勇杰. All rights reserved.
//

#import "ViewController.h"
#import "ZLPhotoActionSheet.h"
#import "LFPhotoEditingController.h"
#import "LFVideoEditingController.h"
#import "LFPhotoEditingController.h"
#import <Photos/Photos.h>
#import "SwitchingController.h"
#import <SVProgressHUD.h>
#import "SettingController.h"
#import "YJCache.h"
#import "SetController.h"



@interface ViewController ()<LFVideoEditingControllerDelegate,LFPhotoEditingControllerDelegate>

/** 需要保存到编辑数据 */
@property (nonatomic, strong) LFVideoEdit *videoEdit;
@property (nonatomic, strong) LFPhotoEdit *photoEdit;


@property (nonatomic, strong) NSData *dataUrl;

@property (nonatomic, strong) NSURL *url1;
@property (nonatomic, strong) NSURL *url2;



@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    [self.navigationController.navigationBar setBackgroundImage:
     [UIImage imageNamed:@"5.jpeg"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor brownColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:25]}];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"1"] forBarMetrics:UIBarMetricsDefault];

    
    // Do any additional setup after loading the view, typically from a nib.
}

- (ZLPhotoActionSheet *)getPas
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];

#pragma optional
    //以下参数为自定义参数，均可不设置，有默认值
    actionSheet.sortAscending = YES;
    actionSheet.allowSelectImage = NO;
    actionSheet.allowSelectGif = NO;
    actionSheet.allowSelectVideo = YES;
    actionSheet.allowSelectLivePhoto = NO;
    actionSheet.allowForceTouch = NO;
    actionSheet.allowEditImage = NO;
    actionSheet.allowEditVideo = YES;
    actionSheet.allowMixSelect = NO;
    //设置相册内部显示拍照按钮
    actionSheet.allowTakePhotoInLibrary = NO;
    //设置在内部拍照按钮上实时显示相机俘获画面
    actionSheet.showCaptureImageOnTakePhotoBtn = NO;
    //设置照片最大预览数
    actionSheet.maxPreviewCount = 20;
    //设置照片最大选择数
    actionSheet.maxSelectCount = 1;
    //设置允许选择的视频最大时长
    actionSheet.maxVideoDuration = 300;
    //设置照片cell弧度
    actionSheet.cellCornerRadio = 3;
    //单选模式是否显示选择按钮
    actionSheet.showSelectBtn = YES;
    //是否在选择图片后直接进入编辑界面
    actionSheet.editAfterSelectThumbnailImage = NO;
    //设置编辑比例
    //    actionSheet.clipRatios = @[GetClipRatio(4, 3)];
    //是否在已选择照片上显示遮罩层
    actionSheet.showSelectedMask = YES;
    //遮罩层颜色
    //    actionSheet.selectedMaskColor = [UIColor orangeColor];
#pragma required
    //如果调用的方法没有传sender，则该属性必须提前赋值
    actionSheet.sender = self;


    zl_weakify(self);
    
    
    
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {

        zl_strongify(weakSelf);
        
        PHAsset *assest = assets.firstObject;
        PHAsset *phAsset = assest;
        if (phAsset.mediaType == PHAssetMediaTypeVideo) {
            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            options.version = PHImageRequestOptionsVersionCurrent;
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
            
            PHImageManager *manager = [PHImageManager defaultManager];
            [manager requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                AVURLAsset *urlAsset = (AVURLAsset *)asset;
                
                NSURL *url = urlAsset.URL;
                UIImage *image = [self getVideoFirstImage:url];
                NSData *data = [NSData dataWithContentsOfURL:url];
                self.dataUrl = data;
                
                LFVideoEditingController *lfVideoEditVC = [[LFVideoEditingController alloc] init];
                lfVideoEditVC.delegate = strongSelf;
                //    lfVideoEditVC.operationType = LFVideoEditOperationType_draw | LFVideoEditOperationType_clip;
                //    lfVideoEditVC.minClippingDuration = 3;
                if (strongSelf.videoEdit) {
                    lfVideoEditVC.videoEdit = strongSelf.videoEdit;
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [lfVideoEditVC setVideoURL:url placeholderImage:image];
                    });
                    
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [strongSelf.navigationController setNavigationBarHidden:YES];
                    [strongSelf.navigationController pushViewController:lfVideoEditVC animated:NO];
                });
                
                
            }];
        }

    }];

    return actionSheet;
}



- (ZLPhotoActionSheet *)getImages
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    
#pragma optional
    //以下参数为自定义参数，均可不设置，有默认值
    actionSheet.sortAscending = YES;
    actionSheet.allowSelectImage = YES;
    actionSheet.allowSelectGif = NO;
    actionSheet.allowSelectVideo = NO;
    actionSheet.allowSelectLivePhoto = NO;
    actionSheet.allowForceTouch = NO;
    actionSheet.allowEditImage = YES;
//    actionSheet.allowEditVideo = NO;
    actionSheet.allowMixSelect = NO;
    //设置相册内部显示拍照按钮
    actionSheet.allowTakePhotoInLibrary = YES;
    //设置在内部拍照按钮上实时显示相机俘获画面
    actionSheet.showCaptureImageOnTakePhotoBtn = YES;
    //设置照片最大预览数
    actionSheet.maxPreviewCount = 20;
    //设置照片最大选择数
    actionSheet.maxSelectCount = 1;
    //设置允许选择的视频最大时长
//    actionSheet.maxVideoDuration = 300;
    //设置照片cell弧度
    actionSheet.cellCornerRadio = 3;
    //单选模式是否显示选择按钮
    actionSheet.showSelectBtn = YES;
    //是否在选择图片后直接进入编辑界面
    actionSheet.editAfterSelectThumbnailImage = NO;
    //设置编辑比例
    //    actionSheet.clipRatios = @[GetClipRatio(4, 3)];
    //是否在已选择照片上显示遮罩层
    actionSheet.showSelectedMask = YES;
    //遮罩层颜色
    //    actionSheet.selectedMaskColor = [UIColor orangeColor];
#pragma required
    //如果调用的方法没有传sender，则该属性必须提前赋值
    actionSheet.sender = self;
    
    
    zl_weakify(self);
    
    
    
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        
        zl_strongify(weakSelf);
        
        UIImage *imgae = images.firstObject;
        
        LFPhotoEditingController *lfPhotoEditVC = [[LFPhotoEditingController alloc] init];
        //    lfPhotoEditVC.operationType = LFPhotoEditOperationType_draw | LFPhotoEditOperationType_splash;
        lfPhotoEditVC.delegate = strongSelf;
        if (strongSelf.photoEdit) {
            lfPhotoEditVC.photoEdit = strongSelf.photoEdit;
        } else {
            lfPhotoEditVC.editImage = imgae;
        }
        

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController setNavigationBarHidden:YES];
            [self.navigationController pushViewController:lfPhotoEditVC animated:NO];
        });
    }];
    
    return actionSheet;
}


- (ZLPhotoActionSheet *)getVideo
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    
#pragma optional
    //以下参数为自定义参数，均可不设置，有默认值
    actionSheet.sortAscending = YES;
    actionSheet.allowSelectImage = NO;
    actionSheet.allowSelectGif = NO;
    actionSheet.allowSelectVideo = YES;
    actionSheet.allowSelectLivePhoto = NO;
    actionSheet.allowForceTouch = NO;
    actionSheet.allowEditImage = NO;
    actionSheet.allowEditVideo = YES;
    actionSheet.allowMixSelect = NO;
    //设置相册内部显示拍照按钮
    actionSheet.allowTakePhotoInLibrary = NO;
    //设置在内部拍照按钮上实时显示相机俘获画面
    actionSheet.showCaptureImageOnTakePhotoBtn = NO;
    //设置照片最大预览数
    actionSheet.maxPreviewCount = 20;
    //设置照片最大选择数
    actionSheet.maxSelectCount = 2;
    //设置允许选择的视频最大时长
    actionSheet.maxVideoDuration = 300;
    //设置照片cell弧度
    actionSheet.cellCornerRadio = 3;
    //单选模式是否显示选择按钮
    actionSheet.showSelectBtn = YES;
    //是否在选择图片后直接进入编辑界面
    actionSheet.editAfterSelectThumbnailImage = NO;
    //设置编辑比例
    //    actionSheet.clipRatios = @[GetClipRatio(4, 3)];
    //是否在已选择照片上显示遮罩层
    actionSheet.showSelectedMask = YES;
    //遮罩层颜色
    //    actionSheet.selectedMaskColor = [UIColor orangeColor];
#pragma required
    //如果调用的方法没有传sender，则该属性必须提前赋值
    actionSheet.sender = self;
    
    
    zl_weakify(self);
    
    
    
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        
        zl_strongify(weakSelf);
        
        if(assets.count < 2){
            NSLog(@"选择视频数量少");
            [SVProgressHUD showErrorWithStatus:@"Please select two video!"];
            return ;
        }
        
        
        
        
        //获取第一个视频
        PHAsset *assest = assets.firstObject;
        PHAsset *phAsset = assest;
        if (phAsset.mediaType == PHAssetMediaTypeVideo) {
            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            options.version = PHImageRequestOptionsVersionCurrent;
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
            
            PHImageManager *manager = [PHImageManager defaultManager];
            [manager requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                AVURLAsset *urlAsset = (AVURLAsset *)asset;
                
                strongSelf.url1 = urlAsset.URL;
            }];
        }
        
        //获取第二个视频
        PHAsset *assest1 = assets[1];
        PHAsset *phAsset1 = assest1;
        if (phAsset1.mediaType == PHAssetMediaTypeVideo) {
            PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
            options.version = PHImageRequestOptionsVersionCurrent;
            options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
            
            PHImageManager *manager = [PHImageManager defaultManager];
            [manager requestAVAssetForVideo:phAsset1 options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                AVURLAsset *urlAsset = (AVURLAsset *)asset;
                
                strongSelf.url2 = urlAsset.URL;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    SwitchingController *vc = [[SwitchingController alloc]init];
                    vc.url1 = self.url1;
                    vc.url2 = self.url2;
                    
                    [strongSelf.navigationController pushViewController:vc animated:NO];
                });
            }];
        }

        
    }];
    
    return actionSheet;
}



#pragma mark - 点击事件

///视频编辑
- (IBAction)videoClip:(id)sender {
    NSLog(@"xxxxxxx");
    
        ZLPhotoActionSheet *a = [self getPas];
        [a showPhotoLibrary];
    
}

///照片编辑
- (IBAction)photoEdit:(id)sender {
    NSLog(@"sssss");
    
    ZLPhotoActionSheet *a = [self getImages];
    [a showPhotoLibrary];

}

///拍照
- (IBAction)takePhoto:(id)sender {
    
    ZLPhotoActionSheet *a = [self getImages];
    [a showPreviewAnimated:YES];
}
///拍摄视频
- (IBAction)shootVideo:(id)sender {
    
    ZLPhotoActionSheet *a = [self getPas];
    [a showPreviewAnimated:YES];
}
///视频拼接
- (IBAction)videoStitch:(id)sender {
    
    ZLPhotoActionSheet *a = [self getVideo];
    [a showPhotoLibrary];
}
///设置
- (IBAction)setting:(id)sender {
    NSLog(@"setting");
    
    [self.navigationController pushViewController:[SetController new] animated:YES];
    
}

//获取视频第一帧图片
- (UIImage *)getVideoFirstImage:(NSURL *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode =AVAssetImageGeneratorApertureModeEncodedPixels;
    assetImageGenerator.maximumSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale, [UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale);
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = 1;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, asset.duration.timescale) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
    NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    return thumbnailImageRef ? [[UIImage alloc]initWithCGImage:thumbnailImageRef] : nil;
}



#pragma mark - LFVideoEditingControllerDelegate
- (void)lf_VideoEditingController:(LFVideoEditingController *)videoEditingVC didCancelPhotoEdit:(LFVideoEdit *)videoEdit
{
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController setNavigationBarHidden:NO];
  
}
- (void)lf_VideoEditingController:(LFVideoEditingController *)videoEditingVC didFinishPhotoEdit:(LFVideoEdit *)videoEdit
{
    
    [SVProgressHUD showWithStatus:@"Saving..."];

   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
        __block PHObjectPlaceholder *placeholder;
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoEdit.editFinalURL.path)) {
            NSError *error;
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                PHAssetChangeRequest* createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:videoEdit.editFinalURL];
                placeholder = [createAssetRequest placeholderForCreatedAsset];
            } error:&error];
            if (error) {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
            }
            else{
                [SVProgressHUD showSuccessWithStatus:@"Video has been saved to the album"];
            }
        }else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Video saves the album failure, please set the software to read the album permissions", nil)];
        }
    });
    
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController setNavigationBarHidden:NO];

}


#pragma mark - LFPhotoEditingControllerDelegate
- (void)lf_PhotoEditingController:(LFPhotoEditingController *)photoEditingVC didCancelPhotoEdit:(LFPhotoEdit *)photoEdit
{
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController setNavigationBarHidden:NO];
    

}
- (void)lf_PhotoEditingController:(LFPhotoEditingController *)photoEditingVC didFinishPhotoEdit:(LFPhotoEdit *)photoEdit
{
    
    [SVProgressHUD showWithStatus:@"Saving..."];

    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        //写入图片到相册
        [PHAssetChangeRequest creationRequestForAssetFromImage:photoEdit.editPreviewImage];
        
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if(success){
            
            [SVProgressHUD showSuccessWithStatus:@"Success!"];
        }
        
        
    }];
    
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController setNavigationBarHidden:NO];
    
  
    
}



@end
