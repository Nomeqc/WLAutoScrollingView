//
//  WLAutoScrollingView.m
//  WLAutoScrollingView_Example
//
//  Created by Fallrainy on 2018/6/20.
//  Copyright © 2018年 nomeqc@gmail.com. All rights reserved.
//

#import "WLAutoScrollingView.h"
#import "NSTimer+WLAutoScrollingViewSupport.h"

@interface WLAutoScrollingView ()

@property (nonatomic) Class rowContentViewClass;

@property (nonatomic, copy) NSArray<UIView *> *rowContentViews;

@property (nonatomic) NSArray<UIView *> *canvasViews;

@property (nonatomic) NSTimer *controlTimer;



@property (nonatomic) BOOL rolling;

@property (nonatomic) NSUInteger currentGroupIndex;

@property (nonatomic) UIView *nowCanvasView;
@property (nonatomic) UIView *nextCanvasView;

@end

@implementation WLAutoScrollingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    _rowHeight = 30.f;
    _visibleRowCount = 3;
    _rollInterval = 2.5;
    
    self.layer.masksToBounds = YES;
    
    UIView *nowCanvasView = ({
        UIView *view = [[UIView alloc] init];
        view;
    });
    UIView *nextCanvasView = ({
        UIView *view = [[UIView alloc] init];
        view;
    });
    [self addSubview:nowCanvasView];
    [self addSubview:nextCanvasView];
    _nowCanvasView = nowCanvasView;
    _nextCanvasView = nextCanvasView;
    
    return self;
}

- (void)setVisibleRowCount:(NSUInteger)visibleRowCount {
    _visibleRowCount = visibleRowCount;
    [self setFrame:self.frame];
}

- (void)setRowHeight:(CGFloat)rowHeight {
    _rowHeight = rowHeight;
    [self setFrame:self.frame];
}

- (void)registerRowContentView:(Class)cls {
    NSAssert(cls, @"registerRowContentView:参数不能为空");
    NSString *errorString = [NSString stringWithFormat:@"registerRowContentView:%@必须是UIView的子类",cls];
    NSAssert([[cls new] isKindOfClass:[UIView class]], errorString);
    
    if (cls != _rowContentViewClass) {
        _rowContentViewClass = cls;
        ///删除所有的rowContentView
        [_nowCanvasView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [_nextCanvasView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        
        NSArray<UIView *> *canvasViews = @[_nowCanvasView,
                                           _nextCanvasView];
        NSMutableArray *rowContentViews = [NSMutableArray array];
        for (NSUInteger i = 0; i < 2 * self.visibleRowCount; i++) {
            UIView *view = [_rowContentViewClass new];
            [rowContentViews addObject:view];
            
            UIView *canvasView = canvasViews[i /self.visibleRowCount];
            [canvasView addSubview:view];
        }
        _rowContentViews = [rowContentViews copy];
    }
}

// MARK: Helper
- (NSUInteger)rowCount {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfRowsOfScrollingView:)]) {
        return [self.dataSource numberOfRowsOfScrollingView:self];
    }
    return 0;
}

- (void)configRowContentView:(UIView *)view atIndex:(NSUInteger)index {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(scrollingView:rowContentView:atIndex:)]) {
        [self.dataSource scrollingView:self rowContentView:view atIndex:index];
    }
}


// MARK: @Override
- (void)setFrame:(CGRect)frame {
    CGFloat fixedHeight = self.rowHeight * self.visibleRowCount;
    frame.size = CGSizeMake(frame.size.width, fixedHeight);
    [super setFrame:frame];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.nowCanvasView.frame = self.bounds;
    self.nextCanvasView.frame = ({
        CGRect frame = self.bounds;
        frame.origin.y = CGRectGetWidth(self.bounds);
        frame;
    });
    
    CGFloat rowHeight = self.rowHeight;
    [self.nowCanvasView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(0, rowHeight * idx, CGRectGetWidth(self.nowCanvasView.bounds), rowHeight);
    }];
    [self.nextCanvasView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(0, rowHeight * idx, CGRectGetWidth(self.nextCanvasView.bounds), rowHeight);
    }];
}


- (void)willMoveToWindow:(UIWindow *)newWindow {
    NSLog(@"willMoveToWindow:%@",newWindow);
    if (newWindow) {
        [self startRolling];
    } else {
        [self stopRolling];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    NSLog(@"willMoveToSuperview:%@",newSuperview);
    if (newSuperview) {
        [self startRolling];
    } else {
        [self stopRolling];
    }
}

- (void)didEnterBackground:(NSNotification *)arg1; {
    if (_rolling) {
        [self stopRolling];
    }
}

- (void)didBecomeActive:(NSNotification *)arg1 {
    if (!_rolling) {
        [self startRolling];
    }
}

// MARK: timer
- (void)startRolling {
    [self stopRolling];
    [self updateRowsContent];
    [self resetCanvasViewsPosition];
    
    __weak typeof(self) weakSelf = self;
    _controlTimer = [NSTimer WLASV_scheduledTimerWithTimeInterval:self.rollInterval block:^(NSTimer *timer) {
        typeof(weakSelf) self = weakSelf;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.nowCanvasView.frame = ({
                CGRect frame = self.bounds;
                frame.origin.y = - CGRectGetHeight(self.bounds);
                frame;
            });
            self.nextCanvasView.frame = self.bounds;
        } completion:^(BOOL finished) {
            UIView *nowView = self.nowCanvasView;
            self.nowCanvasView = self.nextCanvasView;
            self.nextCanvasView = nowView;
            
            [self resetCanvasViewsPosition];
            NSUInteger rowCount = [self rowCount];
            NSUInteger groupCount = (NSUInteger)ceilf((rowCount / (CGFloat)self.visibleRowCount));
            self.currentGroupIndex = (self.currentGroupIndex + 1) % groupCount;
            
            [self updateRowsContent];
        }];
    } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_controlTimer forMode:NSRunLoopCommonModes];
}

- (void)stopRolling {
    [_controlTimer invalidate];
    _controlTimer = nil;
    _rolling = NO;
}

- (void)resetCanvasViewsPosition {
    self.nowCanvasView.frame = self.bounds;
    self.nextCanvasView.frame = ({
        CGRect frame = self.bounds;
        frame.origin.y = CGRectGetHeight(frame);
        frame;
    });
}

- (void)updateRowsContent {
    NSUInteger rowCount = [self rowCount];
    NSUInteger groupCount = (NSUInteger)ceilf((rowCount / (CGFloat)self.visibleRowCount));
    [self configContentViewWithGroupIndex:self.currentGroupIndex canvasView:self.nowCanvasView];
    NSUInteger nextGroupIndex = (self.currentGroupIndex + 1) % groupCount;
    [self configContentViewWithGroupIndex:nextGroupIndex canvasView:self.nextCanvasView];
}

- (void)configContentViewWithGroupIndex:(NSUInteger)groupIndex canvasView:(UIView *)canvasView {
    NSUInteger rowCount = [self rowCount];
    NSUInteger rowBeginningIndex = groupIndex * self.visibleRowCount;
    NSUInteger rowCotnentViewIndex = 0;
    for (NSUInteger i = rowBeginningIndex; i < MIN(rowBeginningIndex + self.visibleRowCount, rowCount); i++) {
        UIView *view = canvasView.subviews[rowCotnentViewIndex];
        [self configRowContentView:view atIndex:i];
        rowCotnentViewIndex++;
    }
}

@end
