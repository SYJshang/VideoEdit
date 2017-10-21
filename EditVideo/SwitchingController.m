//
//  SwitchingController.m
//  EditVideo
//
//  Created by 尚勇杰 on 2017/10/18.
//  Copyright © 2017年 尚勇杰. All rights reserved.
//

#import "SwitchingController.h"
#import <AVFoundation/AVFoundation.h>
#import <SDAutoLayout/SDAutoLayout.h>
#import <Photos/Photos.h>
#import <SVProgressHUD.h>
#import "SettingController.h"
#import "MusicListController.h"
#import "ZLDefine.h"

#define KW  [UIScreen mainScreen].bounds.size.width
#define KH  ([UIScreen mainScreen].bounds.size.height - 64)

@interface SwitchingController (){
    
    AVAssetExportSession *exporter;
}

@property (nonatomic, strong) AVPlayer *player1;
@property (nonatomic, strong) AVPlayer *player2;

@property (nonatomic, weak) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) UIButton *btnMusic;

@property (nonatomic, strong) NSString *musicName;



@end

@implementation SwitchingController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.title = @"Video stitching";
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithWhite:0.80 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = [UIColor cyanColor];
    [self.navigationController.navigationBar setBackgroundImage:
     [UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor brownColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(5, 5, 34, 34);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setImage:[UIImage imageNamed:@"下载"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(finsh) forControlEvents:UIControlEventTouchUpInside];
    btn1.frame = CGRectMake(5, 5, 34, 34);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn1];

}

- (void)finsh{
    
    NSString *documentsPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"/FilePath"];
    NSString *musicPath = [documentsPath stringByAppendingString:[NSString stringWithFormat:@"/%@",self.musicName]];

//    NSString *str = [documentsPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL fileURLWithPath:musicPath];
    [self addFirstVideo:self.url1 andSecondVideo:self.url2 withMusic:url];
    
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.80 alpha:1.0];
//    self.url1 = [[NSBundle mainBundle] URLForResource:@"2" withExtension:@"mp4"];
    _player1 = [AVPlayer playerWithURL:self.url1];
    [self.player1 addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player1];
    playerLayer.frame = CGRectMake(5, 69, KW - 10, KH / 2 - 45);
    [self.view.layer addSublayer:playerLayer];
    
//    _playerLayer = playerLayer;
    
    _player2 = [AVPlayer playerWithURL:self.url2];
    [self.player2 addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    AVPlayerLayer *playerLayer2 = [AVPlayerLayer playerLayerWithPlayer:_player2];
    playerLayer2.frame = CGRectMake(5, KH / 2 + 35,KW - 10, KH / 2 - 45);
    [self.view.layer addSublayer:playerLayer2];
    
    self.btnMusic = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.btnMusic];
    [self.btnMusic setTitle:@"Add background music" forState:UIControlStateNormal];
    [self.btnMusic setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [self.btnMusic setBackgroundColor:[UIColor cyanColor]];
    [self.btnMusic addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnMusic.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0).heightIs(45);
    
    // Do any additional setup after loading the view from its nib.
}

- (void)action{
   
    NSLog(@"导入音乐");
    
    NSFileManager *fileManage = [NSFileManager defaultManager];
    
    NSString *documentsPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"/FilePath"];
    
    NSArray *arr = [[fileManage subpathsOfDirectoryAtPath:documentsPath error:nil] mutableCopy];
    
    if(arr.count < 1){
        
        [self.navigationController pushViewController:[SettingController new] animated:YES];
        
    }else{
        
        MusicListController *vc = [[MusicListController alloc]init];
        
        zl_weakify(self);
        
        vc.selectCell = ^(NSInteger intergert) {
            
            NSString *str = [NSString stringWithFormat:@"%@",arr[intergert]];
            [SVProgressHUD showSuccessWithStatus:str];
            weakSelf.musicName = str;
            
            [weakSelf.btnMusic setTitle:str forState:UIControlStateNormal];
            
            
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    

    
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    NSLog(@"keyPath:     %@",keyPath);
    
    if ([keyPath isEqualToString:@"status"]) {
        if (self.player1.status == AVPlayerStatusReadyToPlay) {
            [self.player1 play];
            
            if(self.player2.status == AVPlayerStatusReadyToPlay){
                [self.player2 play];
            }
        }else{
            NSLog(@"视频解析失败!");

        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
   
}

#pragma mark - 视频合成
-(void)addFirstVideo:(NSURL*)firstVideoPath andSecondVideo:(NSURL*)secondVideo withMusic:(NSURL*)musicPath{
    
    [SVProgressHUD showWithStatus:@"正在合成到系统相册中"];
    AVAsset *firstAsset = [AVAsset assetWithURL:firstVideoPath];
    AVAsset *secondAsset = [AVAsset assetWithURL:secondVideo];
    AVAsset *musciAsset = [AVAsset assetWithURL:musicPath];
    
    // 1 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    // 2 - Video track
    AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration)
                        ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration)
                        ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:firstAsset.duration error:nil];
    
    if (musciAsset != nil){
        AVMutableCompositionTrack *AudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                            preferredTrackID:kCMPersistentTrackID_Invalid];
        [AudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, CMTimeAdd(firstAsset.duration, secondAsset.duration))
                            ofTrack:[[musciAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    }
    
    
    // 4 - Get path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];
    NSURL *url = [NSURL fileURLWithPath:myPathDocs];
    // 5 - Create exporter
    exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL=url;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self exportDidFinish:exporter];
        });
    }];
}

- (void)exportDidFinish:(AVAssetExportSession*)session {
    if (session.status == AVAssetExportSessionStatusCompleted) {
        NSURL *outputURL = session.outputURL;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            __block PHObjectPlaceholder *placeholder;
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(outputURL.path)) {
                NSError *error;
                [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                    PHAssetChangeRequest* createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:outputURL];
                    placeholder = [createAssetRequest placeholderForCreatedAsset];
                } error:&error];
                if (error) {
                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
                }
                else{
                    [SVProgressHUD showSuccessWithStatus:@"视频已经保存到相册"];
                }
            }else {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"视频保存相册失败，请设置软件读取相册权限", nil)];
            }
        });
    }
}

- (void)dealloc
{
    [self.player1 removeObserver:self forKeyPath:@"status"];
    [self.player2 removeObserver:self forKeyPath:@"status"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
