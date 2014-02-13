//
//  CuratorImage.h
//  CuratorScreenSaver
//
//  Created by Francis Chong on 2/13/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * An image in the Curator.im
 */
@interface CuratorImage : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* imageURLString;
@property (nonatomic, strong) NSDate* createdAt;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;

-(instancetype) initWithName:(NSString*)name imageURLString:(NSString*)imageURLString createdAt:(NSDate*)createdAt height:(CGFloat)height width:(CGFloat)width;

+(instancetype) imageWithName:(NSString*)name imageURLString:(NSString*)imageURLString createdAt:(NSDate*)createdAt height:(CGFloat)height width:(CGFloat)width;

@end
