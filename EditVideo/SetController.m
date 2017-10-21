//
//  SetController.m
//  EditVideo
//
//  Created by 尚勇杰 on 2017/10/19.
//  Copyright © 2017年 尚勇杰. All rights reserved.
//

#import "SetController.h"
#import "SettingController.h"
#import "YJCache.h"
#import <SVProgressHUD.h>

@interface SetController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SetController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.title = @"Setting";
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
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
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionHeaderHeight = 40;
    
    // Do any additional setup after loading the view.
}


            


#pragma mark - table view dataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 40;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MTCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    
    if(indexPath.section == 0){
       
        cell.textLabel.text = @"The import of audio";

    }else if (indexPath.section == 1){
        
        cell.textLabel.text = @"Clean up the file";
    }else{
        cell.textLabel.text = @"About us";
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(indexPath.section == 0){
        
        [self.navigationController pushViewController:[SettingController new] animated:YES];
        
       
    }else if (indexPath.section == 1){
        
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
        
        NSString *str = [NSString stringWithFormat:@"Clean up the memory %@ Mb ",[YJCache getCacheSizeWithFilePath:documentsPath]];
        ;
        [SVProgressHUD showInfoWithStatus:str];
        
        [YJCache clearCacheWithFilePath:documentsPath];
    }else{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Solemnly declare" message:@"Our software is always free, and we won't charge for any time! If you have problems with the software, please contact me at yojie_ios@126.com." preferredStyle:UIAlertControllerStyleAlert];
        
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        
       
        // Add the actions.
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
    //    kTipAlert(@"<%ld> selected...", indexPath.row);
}


- (void)dealloc{
    
    self.tableView.delegate = nil;
    
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
