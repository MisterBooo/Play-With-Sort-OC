//
//  ViewController.m
//  Play-With-Sort-OC
//
//  Created by MisterBooo on 2017/7/23.
//  Copyright © 2017年 MisterBooo. All rights reserved.
//

#import "ViewController.h"
#import "NSMutableArray+MBSort.h"
#import "MBBarView.h"
@interface ViewController ()

@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UISegmentedControl *countSegmentControl;
@property (nonatomic, strong) UISegmentedControl *orderSegmentControl;
@property (nonatomic, strong) NSMutableArray<MBBarView *> *barArray;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) dispatch_semaphore_t sema;

@property(nonatomic, assign) NSInteger barCount;
@property(nonatomic, assign) BOOL repeatState;
@property(nonatomic, assign) BOOL orderState;
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, assign) CGFloat barBottom;
@property(nonatomic, assign) CGFloat barAreaHeight;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) NSTimeInterval nowTime;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.barCount = 100;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重置" style:UIBarButtonItemStylePlain target:self action:@selector(onReset)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"排序" style:UIBarButtonItemStylePlain target:self action:@selector(onSort)];
    
    self.segmentControl.frame = CGRectMake(8, 64 + 8, CGRectGetWidth(self.view.bounds) - 16, 30);
    self.countSegmentControl.frame = CGRectMake(8, 64 + 8 + 30 + 8, CGRectGetWidth(self.view.bounds) - 16, 30);
    self.orderSegmentControl.frame = CGRectMake(8, 64 + 8 + 30 + 8 + 30 + 8, CGRectGetWidth(self.view.bounds) - 16, 30);

    [self onReset];
}

- (void)onSegmentControlChanged:(UISegmentedControl *)segmentControl {
    [self onReset];
}
- (void)countSegmentControlChanged:(UISegmentedControl *)segmentControl{
    NSArray *count = @[@"5", @"10",@"20", @"50",@"100"];
    self.barCount = [count[segmentControl.selectedSegmentIndex] integerValue];
    [self onReset];
}
- (void)orderSegmentControlChanged:(UISegmentedControl *)segmentControl{
    self.repeatState = NO;
    self.orderState = NO;
    if (segmentControl.selectedSegmentIndex == 2) {
        //大量重复元素
        self.repeatState = YES;
    }else if (segmentControl.selectedSegmentIndex == 1){
        //近乎有序
        self.orderState = YES;
    }
    [self onReset];
}


/**
 设置BarView的高度

 @param mutArray 高度数组
 @param isReset 是否是重置状态
 */
- (void)setupBarArrayHeight:(NSMutableArray *)mutArray isReset:(BOOL)isReset {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat barMargin = 1;
    CGFloat barWidth = floorf((width - barMargin * (self.barCount + 1)) / self.barCount);
    CGFloat barOrginX = roundf((width - (barMargin + barWidth) * self.barCount + barMargin) / 2.0);
    
    [self.barArray enumerateObjectsUsingBlock:^(MBBarView * _Nonnull bar, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat barHeight = [mutArray[idx] floatValue];
        //重置状态
        if (isReset) {
            if (self.orderState) {
                barHeight = self.barAreaHeight/2 + idx * 2;
            }
            //大量重复元素
            if (self.repeatState) {
                barHeight = self.barAreaHeight/2 + arc4random_uniform(5) * 10;
            }
        }
       
        bar.frame = CGRectMake(barOrginX + idx * (barMargin + barWidth), self.barBottom - barHeight, barWidth, barHeight);
        bar.tag = (int)idx + 2;
    }];
    
    //近乎有序
    if (self.orderState && isReset) {
        for (int i = 0; i < 10; i++) {
            int posx = arc4random() % self.barCount;
            MBBarView *bar = (MBBarView *)self.barArray[posx];
            CGRect frame = bar.frame;
            CGFloat h = arc4random() % 100;
            frame.size.height += h ;
            frame.origin.y -= h;
            bar.frame = frame;
        }
    }
}

- (void)onReset {

    [self invalidateTimer];
    self.index = 0;
    [self setupBarArray];
 
    CGFloat barAreaY = 64 + 8 * 3 + 30 * 3 + 10 ;
    CGFloat barBottom = CGRectGetHeight(self.view.bounds) * 0.95;
    CGFloat barAreaHeight = barBottom - barAreaY;
    self.barBottom = barBottom;
    self.barAreaHeight = barAreaHeight;
    NSMutableArray *mutArray = [NSMutableArray array];
    for (int i = 0; i < self.barArray.count; i++) {
        CGFloat barHeight = 20 + arc4random_uniform(barAreaHeight - 20);
        [mutArray addObject:[NSString stringWithFormat:@"%f",barHeight]];
    }
  
    [self setupBarArrayHeight:mutArray isReset:YES];

}

- (void)onSort {
    if (self.timer || [self judgeArrayIsSorted:self.barArray]) {
        return;
    }
    self.sema = dispatch_semaphore_create(0);
    self.nowTime = [[NSDate date] timeIntervalSince1970];
    
    
    // 定时器信号
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(fireTimerAction) userInfo:nil repeats:YES];
    self.barArray.vc = self;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __unsafe_unretained __block typeof(self) weakSelf = self;
        [self.barArray mb_sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [weakSelf compareWithBarOne:obj1 andBarTwo:obj2];
        } sortType:self.segmentControl.selectedSegmentIndex];

//        //归并排序 用了递归 动画有概率跟不上排序 排序
//        if (self.segmentControl.selectedSegmentIndex == MBMergeSort && ![self judgeArrayIsSorted:self.barArray]) {
//            NSLog(@"归并排序动画有问题");
//            [self.barArray mb_sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//                return [weakSelf compareWithBarOne:obj1 andBarTwo:obj2];
//            } sortType:self.segmentControl.selectedSegmentIndex];
//            return ;
//        }
        
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] - self.nowTime;
        if ([self judgeArrayIsSorted:self.barArray]) {
            self.timeLabel.text = [NSString stringWithFormat:@"排序成功：耗时(秒):%2.3f", interval];
        }else{
            self.timeLabel.text = [NSString stringWithFormat:@"排序失败：耗时(秒):%2.3f", interval];
        }
        
        [self invalidateTimer];
    });
}




#pragma mark - 比较
- (NSComparisonResult)compareWithBarOne:(MBBarView *)barOne andBarTwo:(MBBarView *)barTwo {
    // 模拟进行比较所需的耗时
    if (self.sema) {
        dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
    }
    CGFloat height1 = CGRectGetHeight(barOne.frame);
    CGFloat height2 = CGRectGetHeight(barTwo.frame);
    if (height1 == height2) {
        return NSOrderedSame;
    }
    return height1 < height2 ? NSOrderedAscending : NSOrderedDescending;
}


/**
 数组是否排序

 @param mutArray <#mutArray description#>
 @return <#return value description#>
 */
- (BOOL)judgeArrayIsSorted:(NSMutableArray *)mutArray{
    NSInteger number = mutArray.count - 1;
    for (NSInteger i = 0; i < number; i++) {
        if ([self compareWithBarOne:mutArray[i] andBarTwo:mutArray[i + 1]] == NSOrderedDescending) {
            return false;
        }
    }
    
    return true;
}

#pragma mark - 回调
- (void)resetSortArray:(NSMutableArray *)mutArray{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupBarArrayHeight:mutArray isReset:NO];
    });

}
- (void)exchangePositionWithBarOne:(MBBarView *)barOne andBarTwo:(MBBarView *)barTwo {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect frameOne = barOne.frame;
        CGRect frameTwo = barTwo.frame;
        frameOne.origin.x = barTwo.frame.origin.x;
        frameTwo.origin.x = barOne.frame.origin.x;
        barOne.frame = frameOne;
        barTwo.frame = frameTwo;
        
    });
}
#pragma mark - 定时器
- (void)fireTimerAction {
    // 发出信号量，唤醒排序线程
    dispatch_semaphore_signal(self.sema);
    // 更新计时
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] - self.nowTime;
    self.timeLabel.text = [NSString stringWithFormat:@"耗时(秒):%2.3f", interval];
}
- (void)invalidateTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.sema = nil;
}


#pragma mark - Getter && Setter
- (UISegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"选择", @"冒泡", @"插入",@"归并", @"快速", @"双路", @"三路", @"堆排序"]];
        _segmentControl.selectedSegmentIndex = 0;
        [_segmentControl addTarget:self action:@selector(onSegmentControlChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_segmentControl];
    }
    return _segmentControl;
}

- (UISegmentedControl *)countSegmentControl {
    if (!_countSegmentControl) {
        _countSegmentControl = [[UISegmentedControl alloc] initWithItems:@[@"5", @"10",@"20", @"50",@"100"]];
        _countSegmentControl.selectedSegmentIndex = 4;
        [_countSegmentControl addTarget:self action:@selector(countSegmentControlChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_countSegmentControl];
    }
    return _countSegmentControl;
}
- (UISegmentedControl *)orderSegmentControl {
    if (!_orderSegmentControl) {
        _orderSegmentControl = [[UISegmentedControl alloc] initWithItems:@[@"乱序", @"近乎有序", @"大量重复元素"]];
        _orderSegmentControl.selectedSegmentIndex = 0;
        [_orderSegmentControl addTarget:self action:@selector(orderSegmentControlChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_orderSegmentControl];
    }
    return _orderSegmentControl;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = [UIColor darkTextColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.frame = CGRectMake(CGRectGetWidth(self.view.bounds) * 0.5 - 50,
                                          CGRectGetHeight(self.view.bounds) * 0.95, self.view.bounds.size.width, 40);
        [self.view addSubview:_timeLabel];
    }
    return _timeLabel;
}
/**
 初始化barArray
 */
- (void)setupBarArray{
    [self.barArray removeAllObjects];
    for (MBBarView *bar in self.view.subviews) {
        if (bar.tag > 1) {
            [bar removeFromSuperview];
        }
    }
    _barArray = [NSMutableArray arrayWithCapacity:self.barCount];
    for (NSInteger index = 0; index < self.barCount; index ++) {
        MBBarView *bar = [[MBBarView alloc] init];
        bar.backgroundColor = [UIColor colorWithRed:94.0/255.0 green:171.0/255.0 blue:210.0/255.0 alpha:1];
        [self.view addSubview:bar];
        [_barArray addObject:bar];
    }
}






@end
