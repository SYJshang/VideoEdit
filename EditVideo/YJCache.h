//
//  YJCache.h
//  全球向导
//
//  Created by SYJ on 2016/12/5.
//  Copyright © 2016年 尚勇杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJCache : NSObject


/*s*
 *  获取path路径下文件夹的大小
 *
 *  @param path 要获取的文件夹 路径
 *
 *  @return 返回path路径下文件夹的大小
 */
+ (NSString *)getCacheSizeWithFilePath:(NSString *)path;

/**
 *  清除path路径下文件夹的缓存
 *
 *  @param path  要清除缓存的文件夹 路径
 *
 *  @return 是否清除成功
 */
+ (BOOL)clearCacheWithFilePath:(NSString *)path;


@end
