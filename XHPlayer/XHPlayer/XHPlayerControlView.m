//
//  XHPlayerControlView.m
//  XHPlayer
//
//  Created by intern08 on 2/21/17.
//  Copyright © 2017 snow. All rights reserved.
//

#import "XHPlayerControlView.h"
#import "ASValueTrackingSlider.h"
#import <Masonry.h>
@interface XHPlayerControlView ()<UIGestureRecognizerDelegate>

/** 顶部操作工具栏 */
@property (nonatomic, strong) UIImageView             *topImageView;
/** 返回按钮*/
@property (nonatomic, strong) UIButton                *backBtn;
/** 缓存按钮 */
@property (nonatomic, strong) UIButton                *downLoadBtn;

/** 底部操作工具栏 */
@property (nonatomic,retain ) UIImageView         *bottomImageView;
/** 开始播放按钮 */
@property (nonatomic, strong) UIButton                *startBtn;
/** 当前播放时长label */
@property (nonatomic, strong) UILabel                 *currentTimeLabel;
/** 滑杆 */
@property (nonatomic, strong) ASValueTrackingSlider   *videoSlider;
/** 视频总时长label */
@property (nonatomic, strong) UILabel                 *totalTimeLabel;

/** 是否拖拽slider控制播放进度 */
@property (nonatomic, assign, getter=isDragged) BOOL  dragged;
@end

@implementation XHPlayerControlView
{

    UITapGestureRecognizer *_sliderTap;

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
         [self addSubview:self.topImageView];
        [self.topImageView addSubview:self.backBtn];
        [self.topImageView addSubview:self.downLoadBtn];
        [self addSubview:self.bottomImageView];
         [self.bottomImageView addSubview:self.startBtn];
         [self.bottomImageView addSubview:self.currentTimeLabel];
         [self.bottomImageView addSubview:self.videoSlider];
        [self.bottomImageView addSubview:self.totalTimeLabel];
        [self makeSubViewsConstraints];
    }
    return self;
}
- (UIImageView *)topImageView
{
    if (!_topImageView) {
        _topImageView                        = [[UIImageView alloc] init];
        _topImageView.userInteractionEnabled = YES;
        _topImageView.image                  = [self getXHPlayerImage:@"XHPlayer_top_shadow"];
    }
    return _topImageView;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.imageEdgeInsets = UIEdgeInsetsMake(32, 12, 32, 59);
        [_backBtn setImage:[self getXHPlayerImage:@"XHPlayer_back"] forState:UIControlStateNormal];
        [_backBtn setImage:[self getXHPlayerImage:@"XHPlayer_back_h"] forState:UIControlStateHighlighted];
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)downLoadBtn
{
    if (!_downLoadBtn) {
        _downLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _downLoadBtn.imageEdgeInsets = UIEdgeInsetsMake(32, 49, 32, 15);
        [_downLoadBtn setImage:[self getXHPlayerImage:@"XHPlayer_download"] forState:UIControlStateNormal];
        [_downLoadBtn setImage:[self getXHPlayerImage:@"XHPlayer_download_h"] forState:UIControlStateHighlighted];
        [_downLoadBtn addTarget:self action:@selector(downloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downLoadBtn;
}



- (UIImageView *)bottomImageView
{
    if (!_bottomImageView) {
        _bottomImageView                        = [[UIImageView alloc] init];
        _bottomImageView.userInteractionEnabled = YES;
        _bottomImageView.image                  = [self getXHPlayerImage:@"XHPlayer_bottom_shadow.png"];
        
    }
    return _bottomImageView;
}

- (UIButton *)startBtn
{
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setImage:[self getXHPlayerImage:@"XHPlayer_pause"] forState:UIControlStateNormal];
        [_startBtn setImage:[self getXHPlayerImage:@"XHPlayer_play"] forState:UIControlStateSelected];
        [_startBtn addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (UILabel *)currentTimeLabel
{
    if (!_currentTimeLabel) {
        _currentTimeLabel               = [[UILabel alloc] init];
        _currentTimeLabel.textColor     = [UIColor whiteColor];
        _currentTimeLabel.font          = [UIFont systemFontOfSize:12.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        _currentTimeLabel.text     = @"00:00";
    }
    return _currentTimeLabel;
}


- (ASValueTrackingSlider *)videoSlider
{
    if (!_videoSlider) {
        _videoSlider                       = [[ASValueTrackingSlider alloc] init];
//        _videoSlider.popUpViewCornerRadius = 0.0;
//        _videoSlider.popUpViewColor = [UIColor greenColor];
////        _videoSlider.popUpViewColor = RGBA(19, 19, 9, 1);
//        _videoSlider.popUpViewArrowLength = 8;
        
        [_videoSlider setThumbImage:[self getXHPlayerImage:@"XHPlayer_slider"] forState:UIControlStateNormal];
        _videoSlider.maximumValue          = 1;
        //        _videoSlider.minimumTrackTintColor = [UIColor whiteColor];
        _videoSlider.minimumTrackTintColor = [UIColor redColor];
        
        _videoSlider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        
        _sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSliderAction:)];
        [_videoSlider addGestureRecognizer:_sliderTap];
//
        UILongPressGestureRecognizer * longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognizer:)];
        longPressRecognizer.minimumPressDuration = 1.0;
        [_videoSlider addGestureRecognizer:longPressRecognizer];
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRecognizer:)];
        panRecognizer.delegate = self;
        [panRecognizer setMaximumNumberOfTouches:1];
        [panRecognizer setDelaysTouchesBegan:YES];
        [panRecognizer setDelaysTouchesEnded:YES];
        [panRecognizer setCancelsTouchesInView:YES];
        [_videoSlider addGestureRecognizer:panRecognizer];
    }
    return _videoSlider;
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

- (void)makeSubViewsConstraints {
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.mas_top).offset(0);
        make.height.mas_equalTo(100);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(80);
        make.top.equalTo(self.topImageView.mas_top);
        make.leading.equalTo(self.topImageView.mas_leading).offset(0);
    }];
    
    [self.downLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(80);
        make.top.equalTo(self.topImageView.mas_top);
        make.trailing.equalTo(self.topImageView.mas_trailing).offset(0);
    }];
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        self.bottomImageView.backgroundColor = [UIColor greenColor];
        make.leading.trailing.bottom.equalTo(self);
        make.height.mas_equalTo(70);
    }];
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mas_leading).offset(5);
        make.bottom.equalTo(self.bottomImageView.mas_bottom).offset(-5);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.startBtn.mas_trailing).offset(-3);
        make.centerY.equalTo(self.startBtn.mas_centerY);
        make.width.mas_equalTo(43);
    }];

    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        self.totalTimeLabel.backgroundColor = [UIColor redColor];
        make.trailing.bottom.equalTo(self);
        make.width.height.mas_equalTo(43);
    }];
    
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        //        self.videoSlider.backgroundColor = [UIColor greenColor];
        make.leading.equalTo(self.currentTimeLabel.mas_trailing).offset(4);
        make.trailing.equalTo(self.totalTimeLabel.mas_leading).offset(-4);
        make.centerY.equalTo(self.currentTimeLabel.mas_centerY).offset(-1);
        make.height.mas_equalTo(90);
    }];
}

- (void)playOrPause:(UIButton *)sender {
        sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(playAction:)]) {
        [self.delegate playAction:sender];
    }
}

- (void)backBtnClick:(UIButton *)sender {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"back" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    
//    // 状态条的方向旋转的方向,来判断当前屏幕的方向
//    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//    // 在cell上并且是竖屏时候响应关闭事件
//    if (self.isCellVideo && orientation == UIInterfaceOrientationPortrait) {
//        if ([self.delegate respondsToSelector:@selector(zf_controlView:closeAction:)]) {
//            [self.delegate zf_controlView:self closeAction:sender];
//        }
//    } else {
//        if ([self.delegate respondsToSelector:@selector(zf_controlView:backAction:)]) {
//            [self.delegate zf_controlView:self backAction:sender];
//        }
//    }
}
- (void)downloadBtnClick:(UIButton *)sender {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"download" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    
    
//    if ([self.delegate respondsToSelector:@selector(zf_controlView:downloadVideoAction:)]) {
//        [self.delegate zf_controlView:self downloadVideoAction:sender];
//    }
}

- (void) playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value {
    // 当前时长进度progress
    NSInteger proMin = currentTime / 60;//当前秒
    NSInteger proSec = currentTime % 60;//当前分钟
    // duration 总时长
    NSInteger durMin = totalTime / 60;//总秒
    NSInteger durSec = totalTime % 60;//总分钟
    if (!self.isDragged) {
        // 更新slider
        self.videoSlider.value           = value;
//        self.bottomProgressView.progress = value;
        // 更新当前播放时间
        self.currentTimeLabel.text       = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
    }
    // 更新总时间
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
}


/**
 UISlider TapAction
 */
- (void)tapSliderAction:(UITapGestureRecognizer *)tap
{
    if ([tap.view isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)tap.view;
        CGPoint point = [tap locationInView:slider];
        CGFloat length = slider.frame.size.width;
        // 视频跳转的value
        CGFloat tapValue = point.x / length;
        if ([self.delegate respondsToSelector:@selector(progressSliderTap:)]) {
            [self.delegate progressSliderTap:tapValue];
        }
    }
}

- (void)longPressRecognizer:(UILongPressGestureRecognizer *)longPress {
    if ([longPress.view isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)longPress.view;
        
        CGPoint point = [longPress locationInView:slider];
        CGFloat length = slider.frame.size.width;
        // 视频跳转的value
        CGFloat tapValue = point.x / length;
        if ([self.delegate respondsToSelector:@selector(zf_controlView:progressSliderTap:)]) {
//            [self.delegate zf_controlView:self progressSliderTap:tapValue];
        }
    }
}

/**
 UISlider swipeAction
 */
- (void)panRecognizer:(UIPanGestureRecognizer *)pan {
    if ([pan.view isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)pan.view;
        CGPoint point = [pan locationInView:slider];
        CGFloat length = slider.frame.size.width;
        // 视频跳转的value
        CGFloat tapValue = point.x / length;
        switch (pan.state) {
            case UIGestureRecognizerStateBegan:
//                [self zf_playerCancelAutoFadeOutControlView];
                self.dragged = YES;
                slider.value = tapValue;
                break;
            case UIGestureRecognizerStateChanged:
                slider.value = tapValue;
                break;
            case UIGestureRecognizerStateEnded:
                self.dragged = NO;
                [self.delegate progressSliderTap:tapValue];
                break;
            default:
                break;
        }
    }
}


- (UIImage *)getXHPlayerImage:(NSString *)imageName {
    NSString *file = [[NSBundle mainBundle]pathForResource:@"XHPlayer" ofType:@"bundle"];
    NSString *imagePath = [file stringByAppendingPathComponent:imageName];
    return [UIImage imageWithContentsOfFile:imagePath];
}

@end
