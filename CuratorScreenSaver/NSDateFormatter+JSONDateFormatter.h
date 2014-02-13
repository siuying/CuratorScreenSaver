//
//  NSDateFormatter+JSONDateFormatter.h
//  CuratorScreenSaver
//
//  Created by Francis Chong on 2/13/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (JSONDateFormatter)

+(NSDateFormatter*) dateFormatterForJSON;

+(NSDateFormatter*) sharedDateFormatterForJSON;

@end
