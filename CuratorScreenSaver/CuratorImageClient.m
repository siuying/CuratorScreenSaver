//
//  CuratorImageClient.m
//  CuratorScreenSaver
//
//  Created by Francis Chong on 2/13/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "CuratorImageClient.h"
#import "CuratorImage.h"
#import "CuratorClientSettings.h"

#import "Bolts.h"
#import "ObjectiveSugar.h"

@implementation CuratorImageClient

+ (instancetype)sharedClient {
    static CuratorImageClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[CuratorImageClient alloc] init];
    });
    return _sharedClient;
}

-(instancetype) init{
    self = [super init];
    self.responseSerializer = [AFImageResponseSerializer serializer];
    return self;
}

-(BFTask*) downloadImageAsyncWithURL:(NSURL*)URL
{
    BFTaskCompletionSource *source = [BFTaskCompletionSource taskCompletionSource];
    [self GET:URL.absoluteString
   parameters:nil
      success:^(NSURLSessionDataTask *task, NSImage* image) {
          [source setResult:image];
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          [source setError:error];
      }];
    return source.task;
}
@end
