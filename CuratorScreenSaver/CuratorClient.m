//
//  CuratorClient.m
//  CuratorScreenSaver
//
//  Created by Francis Chong on 2/13/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "CuratorClient.h"

static NSString * const CuratorClientAPIBaseURLString = @"http://curator.im/api/";

@implementation CuratorClient

+ (instancetype)sharedClient {
    static CuratorClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[CuratorClient alloc] initWithBaseURL:[NSURL URLWithString:CuratorClientAPIBaseURLString]];
    });
    return _sharedClient;
}

-(void) streamWithBlock:(void (^)(NSArray *images, NSError *error))block {
    if (!self.token) {
        [NSException raise:NSInconsistentArchiveException format:@"token not set for CuratorClient!"];
    }

    [self GET:@"stream"
   parameters:@{@"token": self.token}
      success:^(NSURLSessionDataTask *task, id JSON) {
          NSArray *imagesFromResponse = [JSON valueForKeyPath:@"results"];
          if (imagesFromResponse) {
              
          }
      } failure:^(NSURLSessionDataTask *task, NSError *error) {
          
      }];
}

@end
