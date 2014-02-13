//
//  CuratorImage.m
//  CuratorScreenSaver
//
//  Created by Francis Chong on 2/13/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "CuratorImage.h"

@implementation CuratorImage

+(instancetype) imageWithName:(NSString*)name imageURLString:(NSString*)imageURLString createdAt:(NSDate*)createdAt height:(CGFloat)height width:(CGFloat)width
{
    return [[self alloc] initWithName:name imageURLString:imageURLString createdAt:createdAt height:height width:width];
}

-(instancetype) initWithName:(NSString*)name imageURLString:(NSString*)imageURLString createdAt:(NSDate*)createdAt height:(CGFloat)height width:(CGFloat)width
{
    self = [super init];
    _name = name;
    _imageURLString = imageURLString;
    _createdAt = createdAt;
    _height = height;
    _width = width;
    return self;
}

@end
