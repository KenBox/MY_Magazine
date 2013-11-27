//
//  FileOperation.m
//  PublishSystem
//
//  Created by Dev on 11-7-13.
//  Copyright 2011 glavesoft. All rights reserved.
//

#import "FileOperation.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access

@implementation FileOperation
+ (BOOL)removeFileAtPath:(NSString *)path {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error = nil;
	if ([fileManager fileExistsAtPath:path]) {
		[fileManager removeItemAtPath:path error:&error];
		
	}
    //删除成功
    //没路径／有路径但被删了
	if (!error)
	{
		return YES;
	}
	return NO;
	
    
}

+ (BOOL)fileExistsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (NSString *)getDocumentsDirectory:(NSString *)anAppendingPathComponent {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path;
    
    path = anAppendingPathComponent ?
    [documentsDirectory stringByAppendingPathComponent:anAppendingPathComponent] :
    documentsDirectory;
    //	if (anAppendingPathComponent) {
    //		path = [documentsDirectory stringByAppendingPathComponent:anAppendingPathComponent];
    //	}
    //	else {
    //		path = documentsDirectory;
    //	}
	return path;
    
}

+ (NSString *)getCachesDirectory:(NSString *)anAppendingPathComponent {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cachesDirectory = [paths objectAtIndex:0];
	NSString *path;
	if (anAppendingPathComponent) {
		path = [cachesDirectory stringByAppendingPathComponent:anAppendingPathComponent];
	}
	else {
		path = cachesDirectory;
	}
	return path;
    
}

+ (BOOL)createDirectoryAtPath:(NSString *)saveFolderPath {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error = nil;
	if (![fileManager fileExistsAtPath:saveFolderPath]) {
        // 直接创建间接目录
		[fileManager createDirectoryAtPath:saveFolderPath withIntermediateDirectories:YES attributes:nil error:&error];
        NSLog(@"创建了!");
	}
    //创建成功
    //有路径／无文件但创建了
	if (!error)
	{
		return YES;
	}
	return NO;
}


+ (NSString *)setTempFilePath:(NSString *)savePath andtempFolderPath:(NSString *)tempFolderPath {
	//设置临时文件目录
	//创建文件名（md5）
	NSString *AppendingFileName = @"";
	NSArray *pathArray = [savePath componentsSeparatedByString:@"/"];
	for (int i = 0; i<[pathArray count]; i++)
	{
		NSString *partPath = [pathArray objectAtIndex:i];
		AppendingFileName = [AppendingFileName stringByAppendingString:partPath];
	}
	AppendingFileName = [FileOperation md5:AppendingFileName];
	//有无临时文件根目录，没有就创建
	[FileOperation createDirectoryAtPath:tempFolderPath];
	//文件名与临时文件根目录拼接成临时文件目录,用于写入
	NSString *tempFilePath = [tempFolderPath stringByAppendingPathComponent:AppendingFileName];
	return tempFilePath;
}

+ (NSString *)md5:(NSString *)anAppendingFileName
{
    const char *cStr = [anAppendingFileName UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];   
}


@end
