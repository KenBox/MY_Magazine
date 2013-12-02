//
//  GSBaseResource.h
//  GSPublishSystem
//
//  Created by Baoyifeng on 12-1-20.
//  Copyright 2012 Glavesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSResourcePath.h"

@interface GSBaseResource : NSObject {

	NSString *resourePath;	//资源路径（或下载的资源的存放路径）
	NSString *downloadURL;	//资源下载的路径
}

@property (nonatomic, copy) NSString *resourePath;
@property (nonatomic, copy) NSString *downloadURL;

/**
 * @brief	设置资源对象的资源存放路径和下载地址
 * @param	resourceRelativePath:资源相对路径
 * @return	资源存放路径和下载地址的绝对路径
 * @note	
 */
//设置资源存放路径  /caches/期刊号
- (void)setMagazineResourePath:(NSString *)resoureRelativePath;
//设置下载xml的绝对路径
- (void)setXmlDownloadURL:(NSString *)downloadXmlURL;

@end
