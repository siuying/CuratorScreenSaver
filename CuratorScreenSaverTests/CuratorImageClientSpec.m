//
//  CuratorImageClientSpec.m
//  CuratorScreenSaver
//
//  Created by Francis Chong on 2/13/14.
//  Copyright 2014 Ignition Soft. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "CuratorImageClient.h"
#import "ObjectiveSugar.h"
#import "CuratorImage.h"
#import "Bolts.h"


SPEC_BEGIN(CuratorImageClientSpec)

describe(@"CuratorImageClient", ^{
    __block CuratorImageClient* client;
    
    beforeEach(^{
        client = [[CuratorImageClient alloc] init];
    });

    context(@"-downloadImageAsyncWithURL", ^{
        it(@"download an image", ^{
            BFTask* task = [client downloadImageAsyncWithURL:[NSURL URLWithString:@"http://media.curator.im/images/287585804599662/705105052847733_1477661_705105052847733_909342244_n.jpg"]];
            [[expectFutureValue(@([task isCompleted])) shouldEventuallyBeforeTimingOutAfter(10.0)] beTrue];

            NSImage* image = task.result;
            [[image shouldNot] beNil];
            [[theValue(image.size.height) should] beGreaterThan:theValue(400)];
            [[theValue(image.size.width) should] beGreaterThan:theValue(400)];
        });
    });
});

SPEC_END
