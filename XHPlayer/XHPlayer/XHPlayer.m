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

/** player内部的一个view，用于管理所有视频播放相关的控件 */
@property (strong, nonatomic) UIView *controlView;
/** 底部操作工具栏 */
@property (nonatomic,retain ) UIImageView         *bottomImageView;
/** 视频总时长label */
@property (nonatomic, strong) UILabel                 *totalTimeLabel;

@end

@implementation XHPlayer

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initXHPlayer];
    }
    return self;
}

- (UIImageView *)bottomImageView
{
    if (!_bottomImageView) {
        _bottomImageView                        = [[UIImageView alloc] init];
        _bottomImageView.userInteractionEnabled = YES;
        _bottomImageView.image                  = [self getXHPlayerImage:@"XHPlayer_bottom_shadow"];
    
    }
    return _bottomImageView;
}

- (UILabel *)totalTimeLabel
{
    if (!_totalTimeLabel) {
        _totalTimeLabel               = [[UILabel alloc] init];
        _totalTimeLabel.textColor     = [UIColor whiteColor];
        _totalTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _totalTimeLabel;
}

- (void)initXHPlayer {
    self.controlView = [[UIView alloc]initWithFrame:self.bounds];
    self.controlView.backgroundColor = [UIColor redColor];
    [self addSubview:self.controlView];
    [self.controlView addSubview:self.bottomImageView];

}

- (void)play {
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4"];
    AVURLAsset *videoURLAsset = [AVURLAsset assetWithURL:url];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:videoURLAsset];
    AVPlayer *player =[AVPlayer playerWithPlayerItem:item];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    layer.frame =self.bounds;
    [self.layer addSublayer:layer];
    [player play];
}

- (UIImage *)getXHPlayerImage:(NSString *)imageName {
    NSString *file = [[NSBundle mainBundle]pathForResource:@"XHPlayer" ofType:@"bundle"];
    NSString *imagePath = [file stringByAppendingString:imageName];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

@end
