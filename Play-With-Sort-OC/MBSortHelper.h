//
//  MBSortHelper.h
//  Play-With-Sort-OC
//
//  Created by MisterBooo on 2017/7/23.
//  Copyright © 2017年 MisterBooo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MBSortModel;

typedef NS_ENUM(NSUInteger,MBSortType){
    MBSelectionSort,         //选择排序
    MBInsertionSort,         //插入排序
    MBBubbleSort,            //冒泡排序
    MBMergeSort,             //归并排序
    MBQuickSort,             //原始快速排序
    MBIdenticalQuickSort,    //双路快速排序
    MBQuick3WaysSort,        //三路快速排序
    MBHeapSort,              //堆排序
};

@interface MBSortHelper : NSObject

@property(nonatomic, strong) NSMutableArray *sortArray;
@property(nonatomic, assign) NSInteger sortTimes;

+ (instancetype)sharedInstance;

/**
 测试sort排序算法排序arr数组所得到结果的正确性
 @param sortType 排序算法
 @param array 测试数组
 @return 是否排序
 */
- (BOOL )testSort:(NSMutableArray <MBSortModel *> *)array sortType:(MBSortType )sortType;


/**
 生成有n个元素的随机数组,每个元素的随机范围为[rangeL, rangeR]
 
 @param number 元素个数
 @param rangeL 左区间
 @param rangeR 右区间
 @return 数组
 */
- (NSMutableArray <MBSortModel *> *)generateRandomArrayNumber:(int )number rangeL:(int )rangeL rangeR:(int)rangeR;

/**
 生成一个近乎有序的数组
 首先生成一个含有[0...n-1]的完全有序数组, 之后随机交换swapTimes对数据
 swapTimes定义了数组的无序程度
 */
- (NSMutableArray <MBSortModel *> *)generateNearlyOrderedArray:(int )arrayCount swapTimes:(int )swapTimes;
/**
 数组是否排序
 
 @param array array
 @return 排序结果
 */
- (BOOL)isSorted:(NSArray <MBSortModel *> *)array;



@end

@interface MBSortModel : NSObject


@property(nonatomic, strong) UIColor *modelColor;

@property(nonatomic, assign) int modelNumber;

- (instancetype)initWithNumber:(int )number Color:(UIColor *)color;


@end






