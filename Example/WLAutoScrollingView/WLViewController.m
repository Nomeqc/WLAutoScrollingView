//
//  WLViewController.m
//  WLAutoScrollingView
//
//  Created by nomeqc@gmail.com on 06/20/2018.
//  Copyright (c) 2018 nomeqc@gmail.com. All rights reserved.
//

#import "WLViewController.h"
#import "WLAutoScrollingView.h"
#import "AutoScrollingContentView.h"

@interface WLViewController ()<WLAutoScrollingViewDataSource>

@property (nonatomic, copy) NSArray *titles;

@end

@implementation WLViewController {
    WLAutoScrollingView *_autoScrollView;
}


- (IBAction)didTapStartBarButton:(UIBarButtonItem *)sender {
    [_autoScrollView startRolling];
}
- (IBAction)didTapStopBarButton:(UIBarButtonItem *)sender {
    [_autoScrollView stopRolling];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titles = @[@"检查网线、调制解调器和路由器",
                    @"重新连接到 Wi-Fi 网络",
                    @"未连接到互联网",
                    @"请试试以下办法：",
                    @"公司类型：1个人设计师 ",
                    @"公司ID，修改后提交时"];
    WLAutoScrollingView *autoScrollView = [[WLAutoScrollingView alloc] initWithFrame:CGRectMake(0, 0, 200, 0)];
    autoScrollView.rowHeight = 22;
    autoScrollView.visibleRowCount = 3;
    ///在配置行高，和屏幕中可见行数后再注册每一行的内容对应的view
    [autoScrollView registerRowContentView:[AutoScrollingContentView class]];
    autoScrollView.dataSource = self;
    [self.view addSubview:autoScrollView];
    autoScrollView.center = self.view.center;
    
    autoScrollView.backgroundColor = [UIColor cyanColor];
    _autoScrollView = autoScrollView;
}

// MARK: WLAutoScrollingViewDataSource
- (NSUInteger)numberOfRowsOfScrollingView:(WLAutoScrollingView *)scrollingView {
    return self.titles.count;
}

- (void)scrollingView:(WLAutoScrollingView *)scrollingView rowContentView:(UIView *)rowContentView atIndex:(NSUInteger)index {
//    NSLog(@"%@",@(index));
    AutoScrollingContentView *contentView = (id)rowContentView;
    contentView.titleLabel.text = self.titles[index];
}

@end
