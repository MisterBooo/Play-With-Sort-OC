//
//  ViewController.m
//  Play-With-Sort-OC
//
//  Created by MisterBooo on 2017/7/23.
//  Copyright © 2017年 MisterBooo. All rights reserved.
//

#import "ViewController.h"
#import "NSMutableArray+MBSort.h"


@interface ViewController ()

@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, strong) UISegmentedControl *countSegmentControl;
@property (nonatomic, strong) UISegmentedControl *orderSegmentControl;
@property (nonatomic, strong) NSMutableArray<UIView *> *barArray;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) dispatch_semaphore_t sema;

@property(nonatomic, assign) NSInteger barCount;
@property(nonatomic, assign) BOOL repeatState;
@property(nonatomic, assign) BOOL orderState;
@property(nonatomic, assign) NSInteger index;

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
    NSArray *count = @[@"10", @"20", @"50",@"100"];
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

- (void)onReset {

    [self invalidateTimer];
    
    [self setupBarArray];
  
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat barMargin = 1;
    CGFloat barWidth = floorf((width - barMargin * (self.barCount + 1)) / self.barCount);
    CGFloat barOrginX = roundf((width - (barMargin + barWidth) * self.barCount + barMargin) / 2.0);
    CGFloat barAreaY = 64 + 8 * 3 + 30 * 3 + 10 ;
    CGFloat barBottom = CGRectGetHeight(self.view.bounds) * 0.95;
    CGFloat barAreaHeight = barBottom - barAreaY;
    __unsafe_unretained __block typeof(self) weakSelf = self;
    [self.barArray enumerateObjectsUsingBlock:^(UIView * _Nonnull bar, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat barHeight = 20 + arc4random_uniform(barAreaHeight - 20);
        if (weakSelf.orderState) {
            barHeight = barAreaHeight/2 + idx * 2;
        }
        //大量重复元素
        if (weakSelf.repeatState) {
            barHeight = barAreaHeight/2 + arc4random_uniform(5) * 10;
        }
        bar.frame = CGRectMake(barOrginX + idx * (barMargin + barWidth), barBottom - barHeight, barWidth, barHeight);
    }];
    //近乎有序
    if (self.orderState) {
        for (int i = 0; i < 10; i++) {
            int posx = arc4random() % self.barCount;
            UIView *bar = (UIView *)self.barArray[posx];
            CGRect frame = bar.frame;
            CGFloat h = arc4random() % 100;
            frame.size.height += h ;
            frame.origin.y -= h;
            bar.frame = frame;
       }
    }
    [self printBarArray];
}

- (void)onSort {
    if (self.timer) {
        return;
    }
    self.sema = dispatch_semaphore_create(0);
    
    // 定时器信号
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(fireTimerAction) userInfo:nil repeats:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        switch (self.segmentControl.selectedSegmentIndex) {
            case MBSelectionSort:
                [self selectionSort];
                break;
            case MBBubbleSort:
                [self bubbleSort];
                break;
            case MBInsertionSort:
                [self insertionSort];
                break;
            case MBMergeSort:
                [self mergeSort];
                break;
            case MBQuickSort:
                [self quickSort];
                break;
            case MBIdenticalQuickSort:
                [self identicalQuickSort];
                break;
            case MBQuick3WaysSort:
                [self quick3WaysSort];
                break;
            case MBHeapSort:
                [self heapSort];
                break;
            default:
                break;
        }
        [self invalidateTimer];
        [self printBarArray];
    });
}

- (void)fireTimerAction {
    // 发出信号量，唤醒排序线程
    dispatch_semaphore_signal(self.sema);
}

#pragma mark - 排序算法
- (void)selectionSort{
    __unsafe_unretained __block typeof(self) weakSelf = self;
    [self.barArray mb_sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [weakSelf compareWithBarOne:obj1 andBarTwo:obj2];
    } sortType:MBSelectionSort];
}
- (void)bubbleSort{
    __unsafe_unretained __block typeof(self) weakSelf = self;
    [self.barArray mb_sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [weakSelf compareWithBarOne:obj1 andBarTwo:obj2];
    } sortType:MBBubbleSort];
}

- (void)insertionSort{
    __unsafe_unretained __block typeof(self) weakSelf = self;
    [self.barArray mb_sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [weakSelf compareWithBarOne:obj1 andBarTwo:obj2];
    } sortType:MBInsertionSort];
}

- (void)mergeSort{
    __unsafe_unretained __block typeof(self) weakSelf = self;
    [self.barArray mb_sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [weakSelf compareWithBarOne:obj1 andBarTwo:obj2];
    } sortType:MBMergeSort];
}

- (void)quickSort{
    __unsafe_unretained __block typeof(self) weakSelf = self;
    [self.barArray mb_sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [weakSelf compareWithBarOne:obj1 andBarTwo:obj2];
    } sortType:MBQuickSort];
}

- (void)identicalQuickSort{
    __unsafe_unretained __block typeof(self) weakSelf = self;
    [self.barArray mb_sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [weakSelf compareWithBarOne:obj1 andBarTwo:obj2];
    } sortType:MBIdenticalQuickSort];
    
}

- (void)quick3WaysSort{
    __unsafe_unretained __block typeof(self) weakSelf = self;
    [self.barArray mb_sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [weakSelf compareWithBarOne:obj1 andBarTwo:obj2];
    } sortType:MBQuick3WaysSort];
}

- (void)heapSort{
    __unsafe_unretained __block typeof(self) weakSelf = self;
    [self.barArray mb_sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [weakSelf compareWithBarOne:obj1 andBarTwo:obj2];
    } sortType:MBHeapSort];
}


#pragma mark - 比较

- (NSComparisonResult)compareWithBarOne:(UIView *)barOne andBarTwo:(UIView *)barTwo {
    // 模拟进行比较所需的耗时
    dispatch_semaphore_wait(self.sema, DISPATCH_TIME_FOREVER);
    CGFloat height1 = CGRectGetHeight(barOne.frame);
    CGFloat height2 = CGRectGetHeight(barTwo.frame);
    if (height1 == height2) {
        return NSOrderedSame;
    }
    return height1 < height2 ? NSOrderedAscending : NSOrderedDescending;
}

- (void)exchangePositionWithBarOne:(UIView *)barOne andBarTwo:(UIView *)barTwo {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect frameOne = barOne.frame;
        CGRect frameTwo = barTwo.frame;
        frameOne.origin.x = barTwo.frame.origin.x;
        frameTwo.origin.x = barOne.frame.origin.x;
        barOne.frame = frameOne;
        barTwo.frame = frameTwo;
    });
}


- (void)invalidateTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.sema = nil;
}

- (void)printBarArray {
    NSMutableString *str = [NSMutableString string];
    [self.barArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [str appendFormat:@"%@ ", @(CGRectGetHeight(obj.frame))];
    }];
    NSLog(@"数组：%@", str);
}

/**
 初始化barArray
 */
- (void)setupBarArray{
    [self.barArray removeAllObjects];
    for (UIView *bar in self.view.subviews) {
        if (bar.tag == 999) {
            [bar removeFromSuperview];
        }
    }
    _barArray = [NSMutableArray arrayWithCapacity:self.barCount];
    for (NSInteger index = 0; index < self.barCount; index ++) {
        UIView *bar = [[UIView alloc] init];
        bar.tag = 999;
        bar.backgroundColor = [UIColor blueColor];
        [self.view addSubview:bar];
        [_barArray addObject:bar];
    }
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
        _countSegmentControl = [[UISegmentedControl alloc] initWithItems:@[@"10", @"20", @"50",@"100"]];
        _countSegmentControl.selectedSegmentIndex = 3;
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



@end
