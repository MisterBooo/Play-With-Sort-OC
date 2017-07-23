//
//  MBSortHelper.m
//  Play-With-Sort-OC
//
//  Created by MisterBooo on 2017/7/23.
//  Copyright © 2017年 MisterBooo. All rights reserved.
//

#import "MBSortHelper.h"

@implementation MBSortHelper

#pragma mark - 接口
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static MBSortHelper *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

/**
 生成有n个元素的随机数组,每个元素的随机范围为[rangeL, rangeR]
 
 @param number 元素个数
 @param rangeL 左区间
 @param rangeR 右区间
 @return 数组
 */
- (NSMutableArray *)generateRandomArrayNumber:(int )number rangeL:(int )rangeL rangeR:(int)rangeR{
    NSAssert(rangeL <= rangeR, @"右区间必须不小于左区间");
    NSMutableArray *arrayM = [NSMutableArray array];
    UIColor *blueColor = [UIColor blueColor];
    for (int i = 0; i < number; i++) {
        int modelNumber = arc4random() % (rangeR - rangeL);
        MBSortModel *model = [[MBSortModel alloc] initWithNumber:modelNumber Color:blueColor];
        [arrayM addObject:model];
    }
    return arrayM;
}

/**
 生成一个近乎有序的数组
 首先生成一个含有[0...n-1]的完全有序数组, 之后随机交换swapTimes对数据
 swapTimes定义了数组的无序程度
 */
- (NSMutableArray *)generateNearlyOrderedArray:(int )arrayCount swapTimes:(int )swapTimes{
    NSMutableArray *array = [NSMutableArray array];
    UIColor *blueColor = [UIColor blueColor];
    for (int i = 0; i < arrayCount; i++) {
     MBSortModel *model = [[MBSortModel alloc] initWithNumber:i Color:blueColor];
     [array addObject:model];
    }
    for (int i = 0; i < swapTimes; i++) {
        int posx = arc4random() % arrayCount;
        int posy = arc4random() % arrayCount;
        [array exchangeObjectAtIndex:posx withObjectAtIndex:posy];
    }
    return array;
}
/**
 判断array数组是否有序
 
 @param array array
 @return 结果
 */
- (BOOL)isSorted:(NSArray *)array{
    NSInteger number = array.count - 1;
    for (NSInteger i = 0; i < number ; i++) {
        MBSortModel *model1 = array[i];
        MBSortModel *model2 = array[i + 1];
        if (model1.modelNumber > model2.modelNumber) {
            return false;
        }
    }
    return true;
}
/**
 测试sort排序算法排序arr数组所得到结果的正确性
 @param sortType 排序算法
 @param array 测试数组
 @return 是否排序
 */
- (BOOL )testSort:(NSMutableArray <MBSortModel *> *)array sortType:(MBSortType )sortType{
    NSMutableArray *sortArray = [NSMutableArray array];
    switch (sortType) {
        case MBBubbleSort:
            {
                sortArray = [self bubbleSort:array];
            }
            break;
            
        default:
            break;
    }
    return [self isSorted:sortArray];
}



#pragma mark - 排序算法
- (NSMutableArray <MBSortModel *> *)bubbleSort:(NSMutableArray <MBSortModel *> *)array{
    NSMutableArray *bubbleArray = [NSMutableArray array];
    bool swapped;
    do {
        swapped = false;
        for (int i = 1; i < array.count; i++) {
            MBSortModel *model_i = array[i];
            MBSortModel *model_i_1 = array[i-1];
            if (model_i.modelNumber < model_i_1.modelNumber) {
                swapped = true;
                [array exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
            }
            
        }
        [array removeLastObject];
    } while (swapped);
    return bubbleArray;
}



@end


@implementation MBSortModel
- (instancetype)initWithNumber:(int )number Color:(UIColor *)color{
    if (self = [super init]) {
        self.modelColor = color;
        self.modelNumber = number;
    }
    return self;
}



@end

