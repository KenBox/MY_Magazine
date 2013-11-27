//
//  GSResourcePath.m
//  GSPublishSystem
//
//  Created by Baoyifeng on 12-1-12.
//  Copyright 2012 Glavesoft. All rights reserved.
//

#import "GSResourcePath.h"

#import "AllDefineHeader.h"

@implementation GSResourcePath

+ (NSString *)getResourcePath:(NSString *)resourceRelativePath {
	NSString *resourcePath = nil;
#ifdef kIsBundlePath
	NSString *resourceName = nil;
	NSArray *array = [resourceRelativePath componentsSeparatedByString:@"/"];
	int arrayCount = [array count];
	if (arrayCount > 0)
	{
		resourceName = [array objectAtIndex:(arrayCount - 1)];
	}
	else {
		resourceName = resourceRelativePath;
	}

	
	resourcePath = [[NSBundle mainBundle] pathForResource:resourceName ofType:nil];
		//note：pathForResource函数返回的若为空，则代表这个目录下不存在此文件。反之，则资源存在
	
#else
	NSString *cachesFolderPath = kResouceUseFolderPath;
	resourcePath = [cachesFolderPath stringByAppendingPathComponent:resourceRelativePath];
#endif

	return resourcePath;
}

@end
