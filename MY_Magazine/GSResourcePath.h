//
//  GSResourcePath.h
//  GSPublishSystem
//
//  Created by Baoyifeng on 12-1-12.
//  Copyright 2012 Glavesoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GSResourcePath : NSObject {

}

/**
 * @brief	通过资源相对路径和宏定义（资源前缀路径）得到资源的绝对路径
 * @param	resourceRelativePath:资源相对路径
 * @return	资源的绝对路径
 * @note	注意宏定义:kIsBundlePath
 */
+ (NSString *)getResourcePath:(NSString *)resourceRelativePath;

@end
