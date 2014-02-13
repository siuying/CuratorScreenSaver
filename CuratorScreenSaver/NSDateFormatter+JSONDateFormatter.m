//
//  NSDateFormatter+JSONDateFormatter.m
//  CuratorScreenSaver
//
//  Created by Francis Chong on 2/13/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "NSDateFormatter+JSONDateFormatter.h"

@implementation NSDateFormatter (JSONDateFormatter)

+(NSDateFormatter*) dateFormatterForJSON
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return dateFormatter;
}

+(NSDateFormatter*) sharedDateFormatterForJSON
{
    static NSDateFormatter* _sharedDateFormatterForJSON;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDateFormatterForJSON = [self dateFormatterForJSON];
    });
    return _sharedDateFormatterForJSON;
}

@end
