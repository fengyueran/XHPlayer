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
#import <Masonry.h>

#define ScreenW    [[UIScreen mainScreen] bounds].size.width
#define ScreenH    [[UIScreen mainScreen] bounds].size.height

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

    [self addNotifications];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.player.currentItem) {
        if ([keyPath isEqualToString:@"status"]) {
            
            if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
                NSInteger currentTime = (NSInteger)CMTimeGetSeconds([self.playerItem currentTime]);
                CGFloat totalTime     = (CGFloat)self.playerItem.duration.value / self.playerItem.duration.timescale;
                CGFloat value         = CMTimeGetSeconds([self.playerItem currentTime]) / totalTime;
                [self.controlView playerCurrentTime:currentTime totalTime:totalTime sliderValue:value];
//                [self setNeedsLayout];
//                [self layoutIfNeeded];
                // 添加playerLayer到self.layer
//                [self.layer insertSublayer:self.playerLayer atIndex:0];
//                self.state = ZFPlayerStatePlaying;
                // 加载完成后，再添加平移手势
                // 添加平移手势，用来控制音量、亮度、快进快退
//                UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
//                panRecognizer.delegate = self;
//                [panRecognizer setMaximumNumberOfTouches:1];
//                [panRecognizer setDelaysTouchesBegan:YES];
//                [panRecognizer setDelaysTouchesEnded:YES];
//                [panRecognizer setCancelsTouchesInView:YES];
//                [self addGestureRecognizer:panRecognizer];
                
                // 跳到xx秒播放视频
//                if (self.seekTime) {
//                    [self seekToTime:self.seekTime completionHandler:nil];
//                }
//                self.player.muted = self.mute;
            } else if (self.player.currentItem.status == AVPlayerItemStatusFailed) {
//                self.state = ZFPlayerStateFailed;
            }
        } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            
            // 计算缓冲进度
            NSTimeInterval timeInterval = [self availableDuration];
            CMTime duration             = self.playerItem.duration;
            CGFloat totalDuration       = CMTimeGetSeconds(duration);
//            if (!self.isPauseByUser) { [self play]; } // 如果没有被用户暂停，就继续播放，只要缓冲就播放。
//            [self.controlView zf_playerSetProgress:timeInterval / totalDuration];
            
        } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
            
            // 当缓冲是空的时候
            if (self.playerItem.playbackBufferEmpty) {
//                self.state = ZFPlayerStateBuffering;
                [self bufferingSomeSecond];
            }
            
        } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            
            // 当缓冲好的时候
//            if (self.playerItem.playbackLikelyToKeepUp && self.state == ZFPlayerStateBuffering){
//                self.state = ZFPlayerStatePlaying;
//            }
            
        }
    }
}


- (void)onDeviceOrientationChange {

  
    //    if (!self.player) { return; }
    //    if (ZFPlayerShared.isLockScreen) { return; }
    //    if (self.didEnterBackground) { return; };
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown ) { return; }
    
    
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
        }
            break;
        case UIInterfaceOrientationPortrait:{
            [self toOrientation:UIInterfaceOrientationPortrait];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            [self toOrientation:UIInterfaceOrientationLandscapeLeft];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            [self toOrientation:UIInterfaceOrientationLandscapeRight];
        }
            break;
        default:
            break;
    }
    
}

- (void)toOrientation:(UIInterfaceOrientation)orientation
{
    // 获取到当前状态条的方向
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
//    // 判断如果当前方向和要旋转的方向一致,那么不做任何操作
//    if (currentOrientation == orientation) { return; }
    
    // 根据要旋转的方向,使用Masonry重新修改限制
    if (orientation != UIInterfaceOrientationPortrait) {//
        
        // 这个地方加判断是为了从全屏的一侧,直接到全屏的另一侧不用修改限制,否则会出错;
        if (currentOrientation == UIInterfaceOrientationPortrait) {
                        [self removeFromSuperview];
            //            ZFBrightnessView *brightnessView = [ZFBrightnessView sharedBrightnessView];
//                        [[UIApplication sharedApplication].keyWindow addSubview:self];
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(ScreenH));
                make.height.equalTo(@(ScreenW));
                make.center.equalTo([UIApplication sharedApplication].keyWindow);
            }];
        }
    }
    // iOS6.0之后,设置状态条的方法能使用的前提是shouldAutorotate为NO,也就是说这个视图控制器内,旋转要关掉;
    // 也就是说在实现这个方法的时候-(BOOL)shouldAutorotate返回值要为NO
//    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
    
    // 获取旋转状态条需要的时间:
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    // 更改了状态条的方向,但是设备方向UIInterfaceOrientation还是正方向的,这就要设置给你播放视频的视图的方向设置旋转
    // 给你的播放视频的view视图设置旋转
        self.transform = CGAffineTransformIdentity;
        self.transform = [self getTransformRotationAngle];
    //    // 开始旋转
        [UIView commitAnimations];
    //    [self.controlView layoutIfNeeded];
    //    [self.controlView setNeedsLayout];
}

/**
 * 获取变换的旋转角度
 *
 * @return 角度
 */
- (CGAffineTransform)getTransformRotationAngle
{
    // 状态条的方向已经设置过,所以这个就是你想要旋转的方向
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // 根据要进行旋转的方向来计算旋转的角度
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft){
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if(orientation == UIInterfaceOrientationLandscapeRight){
        return CGAffineTransformMakeRotation(M_PI_2);
    }
    return CGAffineTransformIdentity;
}

#pragma mark - 缓冲较差时候

/**
 *  缓冲较差时候回调这里
 */
- (void)bufferingSomeSecond
{
//    self.state = ZFPlayerStateBuffering;
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时播放执行完之前再调用bufferingSomeSecond都忽略
    __block BOOL isBuffering = NO;
    if (isBuffering) return;
    isBuffering = YES;
    
    // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
    [self.player pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 如果此时用户已经暂停了，则不再需要开启播放了
//        if (self.isPauseByUser) {
//            isBuffering = NO;
//            return;
//        }
        
        [self play];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        isBuffering = NO;
        if (!self.playerItem.isPlaybackLikelyToKeepUp) { [self bufferingSomeSecond]; }
        
    });
}


#pragma mark - 计算缓冲进度

/**
 *  计算缓冲进度
 *
 *  @return 缓冲进度
 */
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
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


#pragma mark - 观察者、通知

/**
 *  添加观察者、通知
 */
- (void)addNotifications
{
    //    // app退到后台
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    //    // app进入前台
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayground) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // 监测设备方向
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(onStatusBarOrientationChange)
    //                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
    //                                               object:nil];
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
