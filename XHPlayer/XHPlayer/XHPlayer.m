//
//  XHPlayer.m
//  XHPlayer
//
//  Created by intern08 on 2/21/17.
//  Copyright © 2017 snow. All rights reserved.
//

#import "XHPlayer.h"
#import <AVFoundation/AVFoundation.h>
@interface XHPlayer ()

@end

@implementation XHPlayer

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initXHPlayer];
    }
    return self;
}

- (void)initXHPlayer {
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4"];
    AVURLAsset *videoURLAsset = [AVURLAsset assetWithURL:url];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:videoURLAsset];
    AVPlayer *player =[AVPlayer playerWithPlayerItem:item];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    layer.frame =CGRectMake(0, 0, 320, 568);
    [self.layer addSublayer:layer];
    [player play];
}
@end
