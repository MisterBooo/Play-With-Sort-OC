//
//  ViewController.m
//  Play-With-Sort-OC
//
//  Created by MisterBooo on 2017/7/23.
//  Copyright © 2017年 MisterBooo. All rights reserved.
//

#import "ViewController.h"
#import "MBSortHelper.h"

static const NSInteger kBarCount = 100;

@interface ViewController ()

@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UILabel *calculateTimesLabel;

@property (nonatomic, strong) NSMutableArray<UIView *> *barArray;

@property (nonatomic, assign) NSTimeInterval nowTime;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重置" style:UIBarButtonItemStylePlain target:self action:@selector(p_Reset)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"排序" style:UIBarButtonItemStylePlain target:self action:@selector(p_Sort)];
    
    self.segmentControl.frame = CGRectMake(8, 64 + 8, CGRectGetWidth(self.view.bounds) - 16, 30);
    self.calculateTimesLabel.frame = CGRectMake(CGRectGetWidth(self.view.bounds) * 0.5 - 50,
                                      CGRectGetHeight(self.view.bounds) * 0.8, 120, 40);
    
    [self p_Reset];
}

- (UILabel *)calculateTimesLabel {
    if (!_calculateTimesLabel) {
        _calculateTimesLabel = [[UILabel alloc] init];
        _calculateTimesLabel.font = [UIFont systemFontOfSize:14];
        _calculateTimesLabel.textColor = [UIColor darkTextColor];
        [self.view addSubview:_calculateTimesLabel];
    }
    return _calculateTimesLabel;
}

- (UISegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"选择", @"冒泡", @"插入",@"归并", @"快速", @"双路", @"三路", @"堆排序"]];
        _segmentControl.selectedSegmentIndex = 0;
        [_segmentControl addTarget:self action:@selector(onSegmentControlChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_segmentControl];
    }
    return _segmentControl;
}

- (void)onSegmentControlChanged:(UISegmentedControl *)segmentControl {
    [self p_Reset];
}

- (void)p_Reset {

    self.calculateTimesLabel.text = nil;
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat barMargin = 1;
    CGFloat barWidth = floorf((width - barMargin * (kBarCount + 1)) / kBarCount);
    CGFloat barOrginX = roundf((width - (barMargin + barWidth) * kBarCount + barMargin) / 2.0);
    CGFloat barAreaY = 64 + 10 + 30 + 10;
    CGFloat barBottom = CGRectGetHeight(self.view.bounds) * 0.8;
    CGFloat barAreaHeight = barBottom - barAreaY;
    
    [self.barArray enumerateObjectsUsingBlock:^(UIView * _Nonnull bar, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat barHeight = 20 + arc4random_uniform(barAreaHeight - 20);
        // 若需要制造高概率重复数据请打开此行，令数值为10的整数倍(或修改为其它倍数)
        //        barHeight = roundf(barHeight / 10) * 10;
        bar.frame = CGRectMake(barOrginX + idx * (barMargin + barWidth), barBottom - barHeight, barWidth, barHeight);
    }];
    NSLog(@"重置成功!");
}
- (void)p_Sort{
    
}

#pragma mark - Getter && Setter
- (NSMutableArray<UIView *> *)barArray {
    if (!_barArray) {
        _barArray = [NSMutableArray arrayWithCapacity:kBarCount];
        
        for (NSInteger index = 0; index < kBarCount; index ++) {
            UIView *bar = [[UIView alloc] init];
            bar.backgroundColor = [UIColor blueColor];
            [self.view addSubview:bar];
            [_barArray addObject:bar];
        }
    }
    return _barArray;
}



@end
