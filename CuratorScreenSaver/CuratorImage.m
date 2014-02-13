//
//  CuratorImage.m
//  CuratorScreenSaver
//
//  Created by Francis Chong on 2/13/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "CuratorImage.h"

@implementation CuratorImage

+(instancetype) imageWithName:(NSString*)name imageURLString:(NSString*)imageURLString createdAt:(NSDate*)createdAt
{
    return [[self alloc] initWithName:name imageURLString:imageURLString createdAt:createdAt];
}

-(instancetype) initWithName:(NSString*)name imageURLString:(NSString*)imageURLString createdAt:(NSDate*)createdAt
{
    self = [super init];
    _name = name;
    _imageURLString = imageURLString;
    _createdAt = createdAt;
    return self;
}

@end
