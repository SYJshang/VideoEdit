//
//  MusicListController.h
//  EditVideo
//
//  Created by 尚勇杰 on 2017/10/19.
//  Copyright © 2017年 尚勇杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicListController : UIViewController

@property (nonatomic, copy) void (^selectCell)(NSInteger intergert);

@end
