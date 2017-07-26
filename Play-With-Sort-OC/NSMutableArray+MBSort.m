//
//  NSMutableArray+MBSort.m
//  Play-With-Sort-OC
//
//  Created by MisterBooo on 2017/7/26.
//  Copyright © 2017年 MisterBooo. All rights reserved.
//

#import "NSMutableArray+MBSort.h"
#import <objc/message.h>

void (*objc_msgSendArraySort)(id self,SEL _cmd,id obj1,id obj2) = (void *)objc_msgSend;

@interface NSMutableArray()

@property(nonatomic, copy) MBSortComparator comparator;

@end

@implementation NSMutableArray (MBSort)

- (void)mb_sortUsingComparator:(MBSortComparator )comparator sortType:(MBSortType )sortType{
   
    switch (sortType) {
        case MBSelectionSort:
            [self mb_selectionSortComparator:comparator];
            break;
        case MBBubbleSort:
            [self mb_bubbleSortComparator:comparator];
            break;
        case MBInsertionSort:
            [self mb_insertionSortComparator:comparator];
            break;
        case MBMergeSort:
            [self mb_mergeSortComparator:comparator];
            break;
            
        default:
            break;
    }
}

#pragma mark - 私有排序算法

#pragma mark - /**选择排序*/
- (void)mb_selectionSortComparator:(MBSortComparator )comparator{
    Class class = NSClassFromString(@"ViewController");
    id objc = [class new];
    for (int i = 0; i < self.count; i++) {
        for (int j = i + 1; j < self.count ; j++) {
            if (comparator(self[i],self[j]) == NSOrderedDescending) {
                id temp = self[i];
                self[i] = self[j];
                self[j] = temp;
                SEL func = NSSelectorFromString(@"exchangePositionWithBarOne:andBarTwo:");
                objc_msgSendArraySort(objc,func,temp,self[i]);
            }
        }
    }
}
#pragma mark - /**冒泡排序*/
- (void)mb_bubbleSortComparator:(MBSortComparator )comparator{
    Class class = NSClassFromString(@"ViewController");
    id objc = [class new];
    bool swapped;
    do {
        swapped = false;
        for (int i = 1; i < self.count; i++) {
            if (comparator(self[i - 1],self[i]) == NSOrderedDescending) {
                swapped = true;
                id temp = self[i];
                self[i] = self[i - 1];
                self[i - 1] = temp;
                SEL func = NSSelectorFromString(@"exchangePositionWithBarOne:andBarTwo:");
                objc_msgSendArraySort(objc,func,temp,self[i]);
            }
        }
    } while (swapped);
}
#pragma mark - /**插入排序*/
- (void)mb_insertionSortComparator:(MBSortComparator )comparator{
    Class class = NSClassFromString(@"ViewController");
    id objc = [class new];
    for (int i = 0; i < self.count; i++) {
        id e = self[i];
        int j;
        for (j = i; j > 0 && comparator(self[j - 1],e) == NSOrderedDescending; j--) {
            id temp = self[j];
            self[j] = self[j - 1];
            self[j - 1] = temp;
            SEL func = NSSelectorFromString(@"exchangePositionWithBarOne:andBarTwo:");
            objc_msgSendArraySort(objc,func,temp,self[j]);
        }
        self[j] = e;
    }
}
#pragma mark - /**归并排序 自顶向下*/
- (void)mb_mergeSortComparator:(MBSortComparator )comparator{
    self.comparator = comparator;
    //要特别注意边界的情况
    [self mb_mergeSortArray:self LeftIndex:0 rightIndex:(int)self.count - 1];
}
- (void)mb_mergeSortArray:(NSMutableArray *)array LeftIndex:(int )l rightIndex:(int)r{
    if(l >= r) return;
    
    int mid = (l + r) / 2;
    [self mb_mergeSortArray:array LeftIndex:l rightIndex:mid];
    [self mb_mergeSortArray:array LeftIndex:mid + 1 rightIndex:r];
    [self mb_mergeSortArray:array LeftIndex:l midIndex:mid rightIndex:r];
}

- (void)mb_mergeSortArray:(NSMutableArray *)array LeftIndex:(int )l midIndex:(int )mid rightIndex:(int )r{

    Class class = NSClassFromString(@"ViewController");
    id objc = [class new];
    // 开辟新的空间 r-l+1的空间

    NSMutableArray *aux = [NSMutableArray arrayWithCapacity:r-l+1];
    for (int i = l; i <= r; i++) {
        aux[i - l] = array[i];
    }
    // 初始化，i指向左半部分的起始索引位置l；j指向右半部分起始索引位置mid+1
    int i = l, j = mid + 1;
    for ( int k = l; k <= r; k++) {
        if (i > mid) { // 如果左半部分元素已经全部处理完毕
            self.comparator(nil, nil);
            id temp = array[k];
            array[k] = aux[j - l];
            array[j - l] = temp;
            SEL func = NSSelectorFromString(@"exchangePositionWithBarOne:andBarTwo:");
            objc_msgSendArraySort(objc,func,temp,array[k]);
            j++;
        }else if(j > r){// 如果右半部分元素已经全部处理完毕
            self.comparator(nil, nil);
            id temp = array[k];
            array[k] = aux[i - l];
            array[i - l] = temp;
            SEL func = NSSelectorFromString(@"exchangePositionWithBarOne:andBarTwo:");
            objc_msgSendArraySort(objc,func,temp,array[k]);
            i++;
        }else if(self.comparator(aux[i - l], aux[j - l]) == NSOrderedAscending){// 左半部分所指元素 < 右半部分所指元素
            id temp = array[k];
            array[k] = aux[i - l];
            array[i - l] = temp;
            SEL func = NSSelectorFromString(@"exchangePositionWithBarOne:andBarTwo:");
            objc_msgSendArraySort(objc,func,temp,array[k]);
            i++;
        }else{
            self.comparator(nil, nil);
            id temp = array[k];
            array[k] = aux[j - l];
            array[j - l] = temp;
            SEL func = NSSelectorFromString(@"exchangePositionWithBarOne:andBarTwo:");
            objc_msgSendArraySort(objc,func,temp,array[k]);
            j++;
        }
        
        
        
        
    }
}
#pragma mark - /**快速排序*/


#pragma mark - Getter && Setter
- (void)setComparator:(MBSortComparator)comparator{
    // objc_setAssociatedObject（将某个值跟某个对象关联起来，将某个值存储到某个对象中）
    // object:给哪个对象添加属性
    // key:属性名称
    // value:属性值
    // policy:保存策略
    objc_setAssociatedObject(self, @"comparator",comparator, OBJC_ASSOCIATION_COPY);
}
- (MBSortComparator)comparator{
    return objc_getAssociatedObject(self, @"comparator");
}


@end
