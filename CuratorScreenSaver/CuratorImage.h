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

-(instancetype) initWithName:(NSString*)name imageURLString:(NSString*)imageURLString createdAt:(NSDate*)createdAt;

+(instancetype) imageWithName:(NSString*)name imageURLString:(NSString*)imageURLString createdAt:(NSDate*)createdAt;

@end
