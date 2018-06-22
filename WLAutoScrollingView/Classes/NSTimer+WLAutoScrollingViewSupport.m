//
//  NSTimer+WLAutoScrollingViewSupport.m
//  WLAutoScrollingView_Example
//
//  Created by Fallrainy on 2018/6/21.
//  Copyright © 2018年 nomeqc@gmail.com. All rights reserved.
//

#import "NSTimer+WLAutoScrollingViewSupport.h"

@implementation NSTimer (WLAutoScrollingViewSupport)

+ (void)WLASV_execute:(NSTimer *)timer {
    void (^block)(NSTimer *timer) = timer.userInfo;
    if (block) {
        block(timer);
    }
}

+ (NSTimer *)WLASV_scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return  [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(WLASV_execute:) userInfo:[block copy] repeats:YES];
}



@end
