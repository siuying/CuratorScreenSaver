//
//  CuratorClientSpec.m
//  CuratorScreenSaver
//
//  Created by Francis Chong on 2/13/14.
//  Copyright 2014 Ignition Soft. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CuratorClient.h"
#import "CuratorClientSettings.h"
#import "ObjectiveSugar.h"
#import "CuratorImage.h"
#import "Bolts.h"

SPEC_BEGIN(CuratorClientSpec)

describe(@"CuratorClient", ^{
    __block CuratorClient* client;
    
    beforeEach(^{
        client = [[CuratorClient alloc] init];
        client.token = CuratorAPIClientKey;
    });

    context(@"-getStreamAsync", ^{
        it(@"fetch stream images", ^{
            BFTask* task = [client getStreamAsync];
            [[expectFutureValue(task.result) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];

            [task.result each:^(CuratorImage* image) {
                [[[image name] shouldNot] beNil];
                [[theValue([image height]) should] beGreaterThan:theValue(400)];
                [[theValue([image width]) should] beGreaterThan:theValue(400)];
            }];
        });
    });
});

SPEC_END
