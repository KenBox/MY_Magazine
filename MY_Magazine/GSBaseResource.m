//
//  GSBaseResource.m
//  GSPublishSystem
//
//  Created by Baoyifeng on 12-1-20.
//  Copyright 2012 Glavesoft. All rights reserved.
//

#import "GSBaseResource.h"
#import "AllDefineHeader.h"

@implementation GSBaseResource
@synthesize resourePath;
@synthesize downloadURL;


- (void)setMagazineResourePath:(NSString *)resoureRelativePath {
    // /caches/resoureRelativePath
	self.resourePath = [kCachesFolderPath stringByAppendingPathComponent:resoureRelativePath];
    NSLog(@"self.resourePath is %@",self.resourePath);
	
}

- (void)setXmlDownloadURL:(NSString *)downloadXmlURL
{
	//http://mz.glavesoft.com/jianfengzazhi/.....绝对地址
	self.downloadURL = [NSString stringWithFormat:@"%@/%@",kResouceDownloadURL,downloadXmlURL];
    //[baseHttpURL stringByAppendingPathComponent:downloadXmlURL];
    NSLog(@"self.downloadURL is %@",self.downloadURL);
    
}


@end
