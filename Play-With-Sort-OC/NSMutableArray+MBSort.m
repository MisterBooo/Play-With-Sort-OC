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
#import "MBHeap.h"
void (*objc_msgSendExchangePosition)(id self,SEL _cmd,id obj1,id obj2) = (void *)objc_msgSend;
void (*objc_msgSendSortArray)(id self,SEL _cmd,id sortArray) = (void *)objc_msgSend;

@interface NSMutableArray()

@property(nonatomic, copy) MBSortComparator comparator;
@property(nonatomic, strong) id objc;


@end

@implementation NSMutableArray (MBSort)

- (void)mb_sortUsingComparator:(MBSortComparator )comparator sortType:(MBSortType )sortType{

    self.comparator = comparator;
    Class class = NSClassFromString(@"ViewController");
    id objc = [class new];
    self.objc = objc;
    
    switch (sortType) {
        case MBSelectionSort:
            //选择排序
            [self mb_selectionSort];
            break;
        case MBBubbleSort:
            //冒泡排序
            [self mb_bubbleSort];
            break;
        case MBInsertionSort:
            //插入排序
            [self mb_insertionSort];
            break;
        case MBMergeSort:
            //归并排序
            [self mb_mergeSort];
            break;
        case MBQuickSort:
            //快速排序
            [self mb_quickSort];
            break;
        case MBIdenticalQuickSort:
            //双路快速排序
            [self mb_identicalQuickSort];
            break;
        case MBQuick3WaysSort:
            //三路快速排序
            [self mb_quick3WaysSort];
            break;
        case MBHeapSort:
            //堆排序
            [self mb_heapSort];
            break;
        default:
            break;
    }
}

#pragma mark - 私有排序算法

#pragma mark - /**选择排序*/
- (void)mb_selectionSort{
    for (int i = 0; i < self.count; i++) {
        for (int j = i + 1; j < self.count ; j++) {
            if (self.comparator(self[i],self[j]) == NSOrderedDescending) {
                [self mb_exchangeWithIndexA:i  indexB:j];
            }
        }
    }
}
#pragma mark - /**冒泡排序*/
- (void)mb_bubbleSort{
    bool swapped;
    do {
        swapped = false;
        for (int i = 1; i < self.count; i++) {
            if (self.comparator(self[i - 1],self[i]) == NSOrderedDescending) {
                swapped = true;
                [self mb_exchangeWithIndexA:i  indexB:i- 1];
            }
        }
    } while (swapped);
}
#pragma mark - /**插入排序*/
- (void)mb_insertionSort{
    for (int i = 0; i < self.count; i++) {
        id e = self[i];
        int j;
        for (j = i; j > 0 && self.comparator(self[j - 1],e) == NSOrderedDescending; j--) {
            [self mb_exchangeWithIndexA:j  indexB:j- 1];
        }
        self[j] = e;
    }
}

#pragma mark - /**归并排序 自顶向下*/
- (void)mb_mergeSort{
    [self mb_mergeSortArray:self LeftIndex:0 rightIndex:(int)self.count - 1];
}
- (void)mb_mergeSortArray:(NSMutableArray *)array LeftIndex:(int )l rightIndex:(int)r{
    if(l >= r) return;
    int mid = (l + r) / 2;
    [self mb_mergeSortArray:self LeftIndex:l rightIndex:mid]; //左边有序
    [self mb_mergeSortArray:self LeftIndex:mid + 1 rightIndex:r]; //右边有序
    [self mb_mergeSortArray:self LeftIndex:l midIndex:mid rightIndex:r]; //再将二个有序数列合并
}

- (void)mb_mergeSortArray:(NSMutableArray *)array LeftIndex:(int )l midIndex:(int )mid rightIndex:(int )r{

    dispatch_async(dispatch_get_main_queue(), ^{
        
        SEL func = NSSelectorFromString(@"resetSortArray:");
        // 开辟新的空间 r-l+1的空间
        NSMutableArray *aux = [NSMutableArray arrayWithCapacity:r-l+1];
        for (int i = l; i <= r; i++) {
            // aux 中索引 i-l 的对象 与 array 中索引 i 的对象一致
            // aux[i-l] = array[i];
            [aux addObject:array[i]];
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
                 array[k] = aux[i - l];
                 i++;
             }else{
                 self.comparator(nil, nil);
                 array[k] = aux[j - l];
                 j++;
             }
            
            NSMutableArray *mutArray = [NSMutableArray array];
            [array enumerateObjectsUsingBlock:^(MBBarView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [mutArray addObject:[NSString stringWithFormat:@"%f",obj.frame.size.height]];
            }];
            
            objc_msgSendSortArray(self.vc,func,mutArray);
        }
    });

}
//将有二个有序数列a[first...mid]和a[mid...last]合并。
- (void)mb_mergeSortedArray:(NSMutableArray *)array LeftIndex:(int )l midIndex:(int )mid rightIndex:(int )r
{
    // 开辟新的空间 r-l+1的空间
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:r-l+1];
    // 初始化，i指向左半部分的起始索引位置l；j指向右半部分起始索引位置mid+1
    int i = l, j = mid + 1;
    int m = mid, n = r;
    int k = 0;
    
    while (i <= m && j <= n)
    {
        if (self.comparator(array[i], array[j]) == NSOrderedAscending)// 左半部分所指元素 < 右半部分所指元素
            temp[k++] = array[i++];
        else
            temp[k++] = array[j++];
    }
    
    while (i <= m)
        temp[k++] = array[i++];
    
    while (j <= n)
        temp[k++] = array[j++];
    
    for (i = 0; i < k; i++)
        array[l + i] = temp[i];
}
#pragma mark - /**快速排序*/
- (void)mb_quickSort{
    //要特别注意边界的情况
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
#pragma mark - /**双路快排*/
///近乎有序数组使用双路排序
- (void)mb_identicalQuickSort{
    //要特别注意边界的情况
    [self mb_quickSort:self indexL:0 indexR:(int)self.count - 1];
}
- (void)mb_identicalQuickSort:(NSMutableArray *)array indexL:(int)l indexR:(int)r{
    if (l >= r) return;
    int p = [self __partition2:array indexL:l indexR:r];
    [self mb_quickSort:array indexL:l indexR:p-1];
    [self mb_quickSort:array indexL:p + 1 indexR:r];
}
- (int)__partition2:(NSMutableArray *)array indexL:(int)l indexR:(int)r{
    // 随机在arr[l...r]的范围中, 选择一个数值作为标定点pivot
    [self mb_exchangeWithIndexA:l indexB:(arc4random()%(r-l+1))];
    id v = array[l];
    // arr[l+1...i) <= v; arr(j...r] >= v
    int i = l + 1, j = r;
    while (true) {
        
        while (i <= r && self.comparator(array[i],v) == NSOrderedAscending)
            i++;
        
        while (j > l + 1 && self.comparator(array[j],v) == NSOrderedDescending)
            j--;
        
        if (i > j) {
            break;
        }
        [self mb_exchangeWithIndexA:i indexB:j];
        
        i++;
        j--;
    }
    [self mb_exchangeWithIndexA:l indexB:j];

    return j;
}

#pragma mark - /**三路快排*/
//对于包含有大量重复数据的数组, 三路快排有巨大的优势
- (void)mb_quick3WaysSort{
    //要特别注意边界的情况
    [self mb_quick3WaysSort:self indexL:0 indexR:(int)self.count - 1];
}
/// 递归的三路快速排序算法
- (void)mb_quick3WaysSort:(NSMutableArray *)array indexL:(int)l indexR:(int)r{

    if (l >= r)  return;
    
    self.comparator(nil, nil);
    // 随机在arr[l...r]的范围中, 选择一个数值作为标定点pivot
    [self mb_exchangeWithIndexA:l indexB:(arc4random_uniform(r-l+1) + l)];
    
    id v = array[l];
    
    int lt = l; // array[l+1...lt] < v
    int gt = r + 1; // array[gt...r] > v
    int i = l + 1; // array[lt+1...i) == v
    
    while (i < gt) {
        if ( [self compareWithBarOne:array[i] andBarTwo:v] == NSOrderedAscending) {
            self.comparator(nil, nil);
            [self mb_exchangeWithIndexA:i indexB:lt + 1];

            i++;
            lt++;
        }else if  ([self compareWithBarOne:array[i] andBarTwo:v] == NSOrderedDescending){
            self.comparator(nil, nil);
            [self mb_exchangeWithIndexA:i indexB:gt - 1];
            gt--;
        }else{ //array[i] == v
            i++;
        }

    }
    self.comparator(nil,nil);
    [self mb_exchangeWithIndexA:l indexB:lt];

    [self mb_quick3WaysSort:array indexL:l indexR:lt-1];
    [self mb_quick3WaysSort:array indexL:gt indexR:r];
    
}
#pragma mark - /**堆排序*/
///借助heapify过程创建堆
- (void)mb_heapSort{
    MBHeap *maxheap = [[MBHeap alloc] init];
    maxheap.comparator = self.comparator;
    //构造一个最大堆 在构造最大堆的过程中动画显示
    [maxheap maxHeapItems:self];
    for (int i = maxheap.size - 1; i >= 0; i--) {
       //这个动画如何显示 在构造最大堆的过程中动画显示
        self[i] = maxheap.extractMax;
    }
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
- (NSComparisonResult)compareWithBarOne:(MBBarView *)barOne andBarTwo:(MBBarView *)barTwo {
    CGFloat height1 = CGRectGetHeight(barOne.copiedFrame);
    CGFloat height2 = CGRectGetHeight(barTwo.copiedFrame);
    if (height1 == height2) {
        return NSOrderedSame;
    }
    return height1 < height2 ? NSOrderedAscending : NSOrderedDescending;
}

/// 交换两个元素
- (void)mb_exchangeWithIndexA:(NSInteger)indexA indexB:(NSInteger)indexB{
    if (indexA >= self.count || indexB >= self.count ) {
        NSLog(@"indexA:%ld,indexB:%ld",(long)indexA,(long)indexB);
        return;
    }
    id temp = self[indexA];
    self[indexA] = self[indexB];
    self[indexB] = temp;
    if (!self.objc) {
        Class class = NSClassFromString(@"ViewController");
        id objc = [class new];
        self.objc = objc;
    }
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
