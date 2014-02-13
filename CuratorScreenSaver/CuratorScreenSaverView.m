//
//  CuratorScreenSaverView.m
//  CuratorScreenSaver
//
//  Created by Francis Chong on 2/13/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import "CuratorScreenSaverView.h"
#import "CuratorClient.h"
#import "CuratorImageClient.h"

#import "CuratorImage.h"

#import "ObjectiveSugar.h"
#import "Bolts.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"

#import "DDLog.h"
static const int ddLogLevel = LOG_LEVEL_VERBOSE;

const CGFloat kRefreshImageInterval = 10.0;
const CGFloat kRefreshDataInterval = 60.0 * 60.0 * 12.0;

@interface CuratorScreenSaverView()
@property (strong) NSImageView *imageView;
@property (strong) NSTextField *label;
@property (strong) CuratorClient *client;
@property (strong) CuratorImageClient *imageClient;
@property (strong) NSArray* images;
@property (strong) NSTimer* timer;
@end

@implementation CuratorScreenSaverView

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/30.0];
        
        [DDLog addLogger:[DDASLLogger sharedInstance]];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];

        self.imageView = [[NSImageView alloc] initWithFrame:[self activeScreenRect]];
        [self addSubview:self.imageView];
        
        self.label = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, self.bounds.size.width, 100)];
        self.label.autoresizingMask = NSViewWidthSizable;
        self.label.alignment = NSCenterTextAlignment;
        self.label.backgroundColor = [NSColor clearColor];
        [self.label setEditable:NO];
        [self.label setBezeled:NO];
        self.label.textColor = [NSColor blackColor];
        
        self.label.font = [NSFont fontWithName:@"Helvetica Neue" size:24.0];
        [self.label setStringValue:@"Loading ..."];
        [self addSubview:self.label];
        
        self.client = [CuratorClient sharedClient];
        self.imageClient = [CuratorImageClient sharedClient];

        [self refreshCurator];
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
    [self drawCurator];
    
    [[NSColor whiteColor] setFill];
    NSRectFill(rect);
}

- (void)animateOneFrame
{
    return;
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

#pragma mark - Private

- (void) refreshCurator
{
    // cancel previous invocation
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(nextRandomImage) object:nil];

    // download data
    [[self.client getStreamAsync] continueWithBlock:^id(BFTask *task) {
        if (task.error) {
            DDLogError(@"error fetching stream: %@", [task.error localizedDescription]);
            [self.label setStringValue:[NSString stringWithFormat:@"error fetching stream: %@", [task.error localizedDescription]]];
            return nil;
        }

        self.images = task.result;
        DDLogDebug(@"%ld images loaded.", self.images.count);
        
        // display image
        [self nextRandomImage];
        
        // schedle next invocation
        [self performSelector:@selector(refreshCurator) withObject:nil afterDelay:kRefreshDataInterval];
        return nil;
    }];
}

- (void) nextRandomImage
{
    // cancel previous invocation
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(nextRandomImage) object:nil];

    CuratorImage* curatorImage = [self.images sample];
    if (curatorImage) {
        // download data
        DDLogDebug(@"load image ... %@", curatorImage.imageURLString);
        [[self.imageClient downloadImageAsyncWithURL:[NSURL URLWithString:curatorImage.imageURLString]] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
            if (task.error) {
                DDLogError(@"error downloading image: %@", [task.error localizedDescription]);
                [self.label setStringValue:[NSString stringWithFormat:@"error downloading image: %@", [task.error localizedDescription]]];
            } else {
                DDLogDebug(@"image loaded: %@ (%@)", curatorImage.name, curatorImage.imageURLString);
                [self.imageView setImage:task.result];
                [self.label setStringValue:curatorImage.name];
            }
            
            // schedle next invocation
            [self performSelector:@selector(nextRandomImage) withObject:nil afterDelay:kRefreshImageInterval];
            return nil;
        }];
    } else {
        DDLogWarn(@"image not found!");
        [self performSelector:@selector(nextRandomImage) withObject:nil afterDelay:kRefreshImageInterval];
    }
}

- (void) drawCurator
{
    CGRect r = self.imageView.frame;
    r.origin.x = self.bounds.size.width / 2 - r.size.width / 2;
    r.origin.y = self.bounds.size.height / 2 - r.size.height / 2;
    self.imageView.frame = r;

    NSSize s = [self.label.stringValue sizeWithAttributes:@{NSFontAttributeName: self.label.font}];
    CGRect rl = self.label.frame;
    rl.size.height = s.height;
    rl.origin.y = self.imageView.frame.origin.y - 60;
    self.label.frame = rl;
    self.label.textColor = [NSColor blackColor];
}

- (NSRect) activeScreenRect
{
    NSRect screenRect;
    NSArray *screenArray = [NSScreen screens];
    NSInteger screenCount = [screenArray count];
    
    for (NSInteger i = 0; i < screenCount; i++)
    {
        NSScreen *screen = [screenArray objectAtIndex:i];
        screenRect = [screen visibleFrame];
    }
    return screenRect;
}

@end
