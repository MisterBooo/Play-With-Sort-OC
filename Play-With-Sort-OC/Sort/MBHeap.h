//
//  MBHeap.h
//  Play-With-Sort-OC
//
//  Created by MisterBooo on 2017/8/1.
//  Copyright © 2017年 MisterBooo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBHeap : NSObject

/**
  构造函数, 构造一个空堆, 可容纳capacity个元素

 @param capacity 容量
 */
- (void)maxHeapCapacity:(NSUInteger)capacity;

/**
  构造函数, 通过一个给定数组创建一个最大堆


 @param items 给定数组
 */
- (void)maxHeapItems:(NSArray *)items;

/**
  返回一个布尔值, 表示堆中是否为空


 @return <#return value description#>
 */
- (BOOL)isEmpty;

/**
 返回堆中的元素个数

 @return <#return value description#>
 */
- (int)size;

/**
 向最大堆中插入一个新的元素 item

 @param item <#item description#>
 */
- (void)insertItem:(id )item;

/**
 从最大堆中取出堆顶元素, 即堆中所存储的最大数据

 @return <#return value description#>
 */
- (id)extractMax;

/**
 获取最大堆中的堆顶元素

 @return <#return value description#>
 */
- (id)getMax;

@end
