//
//  XHPlayerControlView.h
//  XHPlayer
//
//  Created by intern08 on 2/21/17.
//  Copyright © 2017 snow. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol XHPlayerControlViewDelegate <NSObject>
/** 播放或者暂停 */
- (void)playAction:(UIButton *)sender;
/** 播放进度条tap事件 */
- (void)progressSliderTap:(CGFloat)value;

@end

@interface XHPlayerControlView : UIView
@property (weak, nonatomic) id<XHPlayerControlViewDelegate> delegate;

- (void) playerCurrentTime:(NSInteger)currentTime totalTime:(NSInteger)totalTime sliderValue:(CGFloat)value;
@end
