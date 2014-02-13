//
//  CuratorImageClient.h
//  CuratorScreenSaver
//
//  Created by Francis Chong on 2/13/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@class BFTask;

@interface CuratorImageClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

/**
 * Get an image with a URL
 */
-(BFTask*) downloadImageAsyncWithURL:(NSURL*)URL;

@end
