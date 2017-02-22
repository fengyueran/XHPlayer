//
//  XHPlayer.m
//  XHPlayer
//
//  Created by intern08 on 2/21/17.
//  Copyright © 2017 snow. All rights reserved.
//

#import "XHPlayer.h"
#import "XHPlayerControlView.h"
#import <AVFoundation/AVFoundation.h>
@interface XHPlayer ()<XHPlayerControlViewDelegate>
/** 播放属性 */
@property (nonatomic, strong) AVPlayer               *player;
@property (nonatomic, strong) AVPlayerItem           *playerItem;
@property (nonatomic, strong) id                     timeObserve;
/** player内部的一个view，用于管理所有视频播放相关的控件 */
@property (strong, nonatomic) XHPlayerControlView *controlView;


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
    self.controlView = [[XHPlayerControlView alloc]initWithFrame:self.bounds];
    self.controlView.delegate = self;
    [self addSubview:self.controlView];
}

- (void)play {
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4"];
    AVURLAsset *videoURLAsset = [AVURLAsset assetWithURL:url];
    self.playerItem = [AVPlayerItem playerItemWithAsset:videoURLAsset];
    self.player =[AVPlayer playerWithPlayerItem:self.playerItem];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    layer.frame =self.bounds;
    [self.layer addSublayer:layer];
    // 添加播放进度计时器
    [self addPeriodicTimeObserver];
    [self.player play];
}

- (void)addPeriodicTimeObserver {
    __weak typeof(self) weakSelf = self;
    self.timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1) queue:nil usingBlock:^(CMTime time){
        AVPlayerItem *currentItem = weakSelf.playerItem;
        NSArray *loadedRanges = currentItem.seekableTimeRanges;
        if (loadedRanges.count > 0 && currentItem.duration.timescale != 0) {
            NSInteger currentTime = (NSInteger)CMTimeGetSeconds([currentItem currentTime]);
            CGFloat totalTime     = (CGFloat)currentItem.duration.value / currentItem.duration.timescale;
            CGFloat value         = CMTimeGetSeconds([currentItem currentTime]) / totalTime;
            [weakSelf.controlView playerCurrentTime:currentTime totalTime:totalTime sliderValue:value];
        }
    }];
    
}

#pragma mark - XHPlayerControlDelegate methods
- (void)playAction:(UIButton *)sender {
    if (sender.selected) {
        [self.player pause];
    } else {
        [self.player play];
    }
}

- (void)progressSliderTap:(CGFloat)value
{
    // 视频总时间长度
    CGFloat total = (CGFloat)self.playerItem.duration.value / self.playerItem.duration.timescale;
    //计算出拖动的当前秒数
    NSInteger dragedSeconds = floorf(total * value);
    
//    [self.controlView zf_playerPlayBtnState:YES];
    [self seekToTime:dragedSeconds];
    
}
- (void)seekToTime:(NSInteger)dragedSeconds {
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        // seekTime:completionHandler:不能精确定位
        // 如果需要精确定位，可以使用seekToTime:toleranceBefore:toleranceAfter:completionHandler:
        // 转换成CMTime才能给player来控制播放进度
//        [self.controlView zf_playerActivity:YES];
        [self.player pause];
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1); //kCMTimeZero
        __weak typeof(self) weakSelf = self;
        [self.player seekToTime:dragedCMTime toleranceBefore:CMTimeMake(1,1) toleranceAfter:CMTimeMake(1,1) completionHandler:^(BOOL finished) {
//            [weakSelf.controlView zf_playerActivity:NO];
            // 视频跳转回调
//            if (completionHandler) { completionHandler(finished); }
            [weakSelf.player play];
//            weakSelf.seekTime = 0;
//            weakSelf.isDragged = NO;
            // 结束滑动
//            [weakSelf.controlView zf_playerDraggedEnd];
//            if (!weakSelf.playerItem.isPlaybackLikelyToKeepUp && !weakSelf.isLocalVideo) { weakSelf.state = ZFPlayerStateBuffering; }
            
        }];
    }
}

- (void)dealloc {
      [self.player removeTimeObserver:self.timeObserve];
}

@end
