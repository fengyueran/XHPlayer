//
//  ViewController.m
//  XHPlayer
//
//  Created by intern08 on 2/21/17.
//  Copyright © 2017 snow. All rights reserved.
//

#import "ViewController.h"
#import "XHPlayer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    XHPlayer *player = [[XHPlayer alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    [self.view addSubview:player];
    [player play];
}
//- (BOOL)shouldAutorotate{
//    
//    return NO;
//    
//}

@end
