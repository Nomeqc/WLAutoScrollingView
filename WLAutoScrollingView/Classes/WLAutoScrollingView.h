//
//  WLAutoScrollingView.h
//  WLAutoScrollingView_Example
//
//  Created by Fallrainy on 2018/6/20.
//  Copyright © 2018年 nomeqc@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WLAutoScrollingView;

@protocol WLAutoScrollingViewDataSource <NSObject>

- (NSUInteger)numberOfRowsOfScrollingView:(WLAutoScrollingView *)scrollingView;

- (void)scrollingView:(WLAutoScrollingView *)scrollingView rowContentView:(UIView *)rowContentView atIndex:(NSUInteger)index;

@end


// !!!: 不要每一次都调用[self rowCount]询问数据源？

@interface WLAutoScrollingView : UIView

///可见的行数,默认为3;
@property (nonatomic) NSUInteger visibleRowCount;

///每一行的高度,默认为30.f
@property (nonatomic) CGFloat rowHeight;

///自定滚动间隔，默认为2.5秒
@property (nonatomic) NSTimeInterval rollInterval;

- (void)registerRowContentView:(Class)cls;

@property (nonatomic, weak) id<WLAutoScrollingViewDataSource> dataSource;

///开始滚动
- (void)startRolling;

///停止滚动
- (void)stopRolling;

@end
