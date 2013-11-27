//
//  FileOperation.h
//  PublishSystem
//
//  Created by Dev on 11-7-13.
//  Copyright 2011 glavesoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileOperation : NSObject 
//得到Documents文件夹下，添加了anAppendingPathComponent的路径（文件路径/文件夹路径）
+ (NSString *)getDocumentsDirectory:(NSString *)anAppendingPathComponent;

//得到Caches目录下的文件 /Cahces/anAppendingPathComponent(文件夹名)
+ (NSString *)getCachesDirectory:(NSString *)anAppendingPathComponent;

//得到tempFolderPath临时文件夹下，添加了savePath（经过MD5值的转化，此savePath为不规则字符串）的路径（文件路径/文件夹路径）
+ (NSString *)setTempFilePath:(NSString *)savePath andtempFolderPath:(NSString *)tempFolderPath;
//把一连串不规则的字符转化成MD5值
+ (NSString *)md5:(NSString *)anAppendingFileName;

//判断路径（文件路径/文件夹路径）是否存在
+ (BOOL)fileExistsAtPath:(NSString *)path;

//功能就是创建所需文件夹路径（文件夹路径判断时若没有则创建文件夹）
//文件路径不能创建，只能使用writeToFile写进去
//返回值暂时没用，因为再使用时都会判断一下
+ (BOOL)createDirectoryAtPath:(NSString *)saveFolderPath;

//根据路径删除文件,文件夹
//返回值暂时没用，因为再使用时都会判断一下
+ (BOOL)removeFileAtPath:(NSString *)path;

@end
