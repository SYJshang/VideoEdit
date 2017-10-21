//
//  SettingController.m
//  EditVideo
//
//  Created by 尚勇杰 on 2017/10/19.
//  Copyright © 2017年 尚勇杰. All rights reserved.
//

#import "SettingController.h"
#import "GCDWebUploader.h"


@interface SettingController (){
    GCDWebUploader *_webUploader;
    __weak IBOutlet UILabel *networkLab;
}

@end

@implementation SettingController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.title = @"File Settings";
    
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
    

    
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.80 alpha:1.0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    [fileManager createDirectoryAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/FilePath"] withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *documentsPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"/FilePath"];
    
    _webUploader = [[GCDWebUploader alloc] initWithUploadDirectory:documentsPath];
    [_webUploader start];
    
    networkLab.text = [NSString stringWithFormat:@"Enter the following address in the computer terminal browser:\n%@",_webUploader.serverURL];
    
    NSLog(@"Visit %@ in your web browser", _webUploader.serverURL);
    
    // Do any additional setup after loading the view from its nib.
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
