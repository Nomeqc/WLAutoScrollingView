//
//  AutoScrollingContentView.m
//  WLAutoScrollingView_Example
//
//  Created by Fallrainy on 2018/6/21.
//  Copyright © 2018年 nomeqc@gmail.com. All rights reserved.
//

#import "AutoScrollingContentView.h"


@interface AutoScrollingContentView ()



@end

@implementation AutoScrollingContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    UILabel *titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label;
    });
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.frame = ({
        CGRect frame = self.bounds;
        frame.size.width = frame.size.width - 16;
        frame.origin.x = 8;
        frame;
    });
    
}


@end
