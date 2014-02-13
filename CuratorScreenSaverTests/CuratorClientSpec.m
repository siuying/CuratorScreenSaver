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

SPEC_BEGIN(CuratorClientSpec)

describe(@"CuratorClient", ^{
    __block CuratorClient* client;
    
    beforeEach(^{
        client = [[CuratorClient alloc] init];
        client.token = CuratorAPIClientKey;
    });

    context(@"", ^{
        
    });
});

SPEC_END
