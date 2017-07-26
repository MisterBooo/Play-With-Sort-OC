//
//  NSMutableArray+MBSort.h
//  Play-With-Sort-OC
//
//  Created by MisterBooo on 2017/7/26.
//  Copyright © 2017年 MisterBooo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,MBSortType){
    MBSelectionSort,         //选择排序
    MBBubbleSort,            //冒泡排序
    MBInsertionSort,         //插入排序
    MBMergeSort,             //归并排序
    MBQuickSort,             //原始快速排序
    MBIdenticalQuickSort,    //双路快速排序
    MBQuick3WaysSort,        //三路快速排序
    MBHeapSort,              //堆排序
};
typedef NSComparisonResult(^MBSortComparator)(id obj1, id obj2);


@interface NSMutableArray (MBSort)

- (void)mb_sortUsingComparator:(MBSortComparator )comparator sortType:(MBSortType )sortType;

@end
