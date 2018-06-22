//
//  NSTimer+WLAutoScrollingViewSupport.h
//  WLAutoScrollingView_Example
//
//  Created by Fallrainy on 2018/6/21.
//  Copyright © 2018年 nomeqc@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (WLAutoScrollingViewSupport)

+ (NSTimer *)WLASV_scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;

@end
