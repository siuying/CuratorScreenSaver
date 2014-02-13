//
//  CuratorClient.h
//  CuratorScreenSaver
//
//  Created by Francis Chong on 2/13/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@class BFTask;

/**
 * API Client for Curator.im
 */
@interface CuratorClient : AFHTTPSessionManager

@property (nonatomic, copy) NSString* token;

+ (instancetype)sharedClient;

/**
 * Get a stream using a block.
 */
-(BFTask*) getStreamAsync;

@end
