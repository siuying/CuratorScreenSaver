//
//  CuratorScreenSaverView.m
//  CuratorScreenSaver
//
//  Created by Francis Chong on 2/13/14.
//  Copyright (c) 2014 Ignition Soft. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "CuratorScreenSaverView.h"
#import "CuratorClient.h"
#import "CuratorImageClient.h"

#import "CuratorImage.h"

#import "ObjectiveSugar.h"
#import "Bolts.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"
#import "Masonry.h"

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
        [self setWantsLayer:YES];
        self.wantsLayer = YES;
        self.layer = [[CALayer alloc] init];
        CGColorRef color = CGColorCreateGenericGray(0.0, 1.0);
        self.layer.backgroundColor = color;
        CGColorRelease(color);

        [self setAnimationTimeInterval:1/30.0];
        
        [DDLog addLogger:[DDASLLogger sharedInstance]];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];

        self.imageView = [[NSImageView alloc] initWithFrame:NSZeroRect];
        self.imageView.imageScaling = NSImageScaleProportionallyUpOrDown;
        self.imageView.imageAlignment = NSImageAlignCenter;
        [self addSubview:self.imageView];

        self.label = [[NSTextField alloc] initWithFrame:NSZeroRect];
        self.label.autoresizingMask = NSViewWidthSizable;
        self.label.alignment = NSLeftTextAlignment;
        self.label.backgroundColor = [NSColor clearColor];
        self.label.textColor = [NSColor whiteColor];
        [self.label setEditable:NO];
        [self.label setBezeled:NO];
        self.label.font = [NSFont fontWithName:@"Helvetica Neue Light" size:32.0];
        [self.label setStringValue:@"Loading ..."];
        [self addSubview:self.label];

        [self createConstraints];

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

-(void) createConstraints
{
    NSRect screen = [NSScreen mainScreen].frame;

    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10.0);
        make.left.equalTo(self.mas_left).with.offset(10.0);
    }];

    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10.0);
        make.left.equalTo(self.mas_left).with.offset(10.0);
        make.width.equalTo(@(screen.size.width - 20));
        make.height.equalTo(@(screen.size.height - 20));
    }];
}

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
                NSImage* image = task.result;
                [self.imageView setImage:image];
                [self.label setStringValue:curatorImage.name];
                [self updateLayer:image];
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

-(void) updateLayer:(NSImage*)image
{
    CIFilter* blackGenerator = [CIFilter filterWithName:@"CIConstantColorGenerator"];
    CIColor* black = [CIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.9];
    [blackGenerator setValue:black forKey:@"inputColor"];
    CIImage* blackImage = [blackGenerator valueForKey:@"outputImage"];
    
    CIFilter *compositeFilter = [CIFilter filterWithName:@"CIMultiplyBlendMode"];
    [compositeFilter setValue:blackImage forKey:@"inputImage"];
    [compositeFilter setValue:[CIImage imageWithData:image.TIFFRepresentation] forKey:@"inputBackgroundImage"];
    CIImage *darkenedImage = [compositeFilter valueForKey: @"outputImage"];
    
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setDefaults];
    [blurFilter setValue:darkenedImage forKey:@"inputImage"];
    [blurFilter setValue:@20 forKey:@"inputRadius"];
    CIImage *effectedImage = [blurFilter valueForKey: @"outputImage"];
    
    effectedImage = [effectedImage imageByCroppingToRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithCIImage:effectedImage];
    self.layer.contents = (__bridge id)(rep.CGImage);
}


@end
