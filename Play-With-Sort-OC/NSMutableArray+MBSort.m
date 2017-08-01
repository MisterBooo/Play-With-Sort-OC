//
//  NSMutableArray+MBSort.m
//  Play-With-Sort-OC
//
//  Created by MisterBooo on 2017/7/26.
//  Copyright © 2017年 MisterBooo. All rights reserved.
//

#import "NSMutableArray+MBSort.h"
#import <objc/message.h>
#import <UIKit/UIKit.h>
#import "MBBarView.h"
void (*objc_msgSendExchangePosition)(id self,SEL _cmd,id obj1,id obj2) = (void *)objc_msgSend;

void (*objc_msgSendSortArray)(id self,SEL _cmd,id sortArray) = (void *)objc_msgSend;


@interface NSMutableArray()

@property(nonatomic, copy) MBSortComparator comparator;
@property(nonatomic, strong) id objc;


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
        case MBQuickSort:
            [self mb_quickSortComparator:comparator];
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
                objc_msgSendExchangePosition(objc,func,temp,self[i]);
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
                objc_msgSendExchangePosition(objc,func,temp,self[i]);
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
            objc_msgSendExchangePosition(objc,func,temp,self[j]);
        }
        self[j] = e;
    }
}
#pragma mark - /**归并排序 自顶向下*/
- (void)mb_mergeSortComparator:(MBSortComparator )comparator{
    self.comparator = comparator;
    //要特别注意边界的情况
    Class class = NSClassFromString(@"ViewController");
    id objc = [class new];
    self.objc = objc;
    [self mb_mergeSortArray:self LeftIndex:0 rightIndex:(int)self.count - 1];
}
- (void)mb_mergeSortArray:(NSMutableArray *)array LeftIndex:(int )l rightIndex:(int)r{
    if(l >= r) return;
    int mid = (l + r) / 2;
    [self mb_mergeSortArray:self LeftIndex:l rightIndex:mid];
    [self mb_mergeSortArray:self LeftIndex:mid + 1 rightIndex:r];
    [self mb_mergeSortArray:self LeftIndex:l midIndex:mid rightIndex:r];
}

- (void)mb_mergeSortArray:(NSMutableArray *)array LeftIndex:(int )l midIndex:(int )mid rightIndex:(int )r{

    SEL func = NSSelectorFromString(@"resetSortArray:");
    // 开辟新的空间 r-l+1的空间
    NSMutableArray *aux = [NSMutableArray arrayWithCapacity:r-l+1];
    for (int i = l; i <= r; i++) {
        // aux 中索引 i-l 的对象 与 array 中索引 i 的对象一致
        aux[i-l] = self[i];
    }
    // 初始化，i指向左半部分的起始索引位置l；j指向右半部分起始索引位置mid+1
    int i = l, j = mid + 1;
    for ( int k = l; k <= r; k++) {
        if (i > mid) { // 如果左半部分元素已经全部处理完毕
            self.comparator(nil, nil);
            self[k] = aux[j - l];
            j++;
        }else if(j > r){// 如果右半部分元素已经全部处理完毕
            self.comparator(nil, nil);
            self[k] = aux[i - l];
            i++;
        }else if(self.comparator(aux[i - l], aux[j - l]) == NSOrderedAscending){// 左半部分所指元素 < 右半部分所指元素
            self[k] = aux[i - l];
            i++;
        }else{
            self.comparator(nil, nil);
            self[k] = aux[j - l];
            j++;
        }
        NSMutableArray *mutArray = [NSMutableArray array];
        [self enumerateObjectsUsingBlock:^(MBBarView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mutArray addObject:[NSString stringWithFormat:@"%f",obj.frame.size.height]];
        }];
        
        objc_msgSendSortArray(self.vc,func,mutArray);
    }

}
#pragma mark - /**快速排序*/
- (void)mb_quickSortComparator:(MBSortComparator )comparator{
    self.comparator = comparator;
    //要特别注意边界的情况
    Class class = NSClassFromString(@"ViewController");
    id objc = [class new];
    self.objc = objc;
    [self mb_quickSort:self indexL:0 indexR:(int)self.count - 1];
}
- (void)mb_quickSort:(NSMutableArray *)array indexL:(int)l indexR:(int)r{
    if (l >= r) return;
    int p = [self __partition:array indexL:l indexR:r];
    [self mb_quickSort:array indexL:l indexR:p-1];
    [self mb_quickSort:array indexL:p + 1 indexR:r];
    
}
/**
 对arr[l...r]部分进行partition操作
 返回p, 使得arr[l...p-1] < arr[p] ; arr[p+1...r] > arr[p]
 
 @param array array
 @param l 左
 @param r 右
 @return 返回p
 */
- (int)__partition:(NSMutableArray *)array indexL:(int)l indexR:(int)r{
    int j = l;// arr[l+1...j] < v ; arr[j+1...i) > v
    for (int i = l + 1; i <= r ; i++) {
        if ( self.comparator(array[i], array[ l]) == NSOrderedAscending) {
            j++;
            //交换
            [self mb_exchangeWithIndexA:j indexB:i];
        }
    }
    self.comparator(nil, nil);
    [self mb_exchangeWithIndexA:j indexB:l];
    return j;
}

#pragma mark - Private
- (void)printArray{
    //打印排序时的数组
    NSMutableString *str = [NSMutableString string];
    [self enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [str appendFormat:@"%@ ", @(CGRectGetHeight(obj.frame))];
    }];
    NSLog(@"数组：%@", str);
}
/// 交换两个元素
- (void)mb_exchangeWithIndexA:(NSInteger)indexA indexB:(NSInteger)indexB{
    id temp = self[indexA];
    self[indexA] = self[indexB];
    self[indexB] = temp;
    SEL func = NSSelectorFromString(@"exchangePositionWithBarOne:andBarTwo:");
    objc_msgSendExchangePosition(self.objc,func,temp,self[indexA]);
}

#pragma mark - Getter && Setter 给NSMutableArray 类动态添加属性 comparator
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

- (void)setObjc:(id)objc{
    objc_setAssociatedObject(self, @"objc",objc, OBJC_ASSOCIATION_RETAIN);
}
- (id)objc{
    return objc_getAssociatedObject(self, @"objc");
}

- (void)setVc:(UIViewController *)vc{
    objc_setAssociatedObject(self, @"vc",vc, OBJC_ASSOCIATION_RETAIN);
}
- (UIViewController *)vc{
    return objc_getAssociatedObject(self, @"vc");
}

@end
