//
//  MBBarView.m
//  Play-With-Sort-OC
//
//  Created by MisterBooo on 2017/7/31.
//  Copyright © 2017年 MisterBooo. All rights reserved.
//

#import "MBBarView.h"

@interface MBBarView()

@property(nonatomic, strong) UILabel *label;

@end

@implementation MBBarView

- (void)layoutSubviews{
    self.label.center = self.center;
    self.label.frame = CGRectMake(0, 0, self.frame.size.width, 10);
    self.label.hidden = self.frame.size.width < [UIScreen mainScreen].bounds.size.width / 15 ? YES : NO;
    self.label.text = [NSString stringWithFormat:@"%d",(int)self.frame.size.height];
}

- (UILabel *)label{
    if (!_label) {
        _label = [UILabel new];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor orangeColor];
        _label.font = [UIFont systemFontOfSize:10];
        [self addSubview:_label];
    }
    return _label;
}


@end
