//
//  MBHeap.m
//  Play-With-Sort-OC
//
//  Created by MisterBooo on 2017/8/1.
//  Copyright © 2017年 MisterBooo. All rights reserved.
//

#import "MBHeap.h"

@interface MBHeap()
@property(nonatomic, strong) NSMutableArray *data;
@property(nonatomic, assign) int count;
@property(nonatomic, assign) NSUInteger capacity;


@end

@implementation MBHeap

#pragma mark - Public
- (void)maxHeapCapacity:(NSUInteger )capacity{
    _data = [NSMutableArray arrayWithCapacity:capacity];
    _count = 0;
    _capacity = capacity;
}
- (void)maxHeapItems:(NSArray *)items{
    _capacity = items.count + 1;
    _data = [NSMutableArray arrayWithCapacity:_capacity];
    for (int i = 0; i < items.count; i++) {
        _data[i+1] = items[i];
    }
    _count = (int)items.count;
    for (int i = _count / 2; i >= 1; i--) {
        [self shiftDown:i];
    }
    
}
/**
 返回一个布尔值, 表示堆中是否为空
 
 
 @return <#return value description#>
 */
- (BOOL)isEmpty{
    return _count == 0;
}

/**
 返回堆中的元素个数
 
 @return <#return value description#>
 */
- (int)size{
    return _count;
}

/**
 向最大堆中插入一个新的元素 item
 
 @param item <#item description#>
 */
- (void)insertItem:(id )item{
    _data[_count + 1] = item;
    [self shiftUp:_count + 1];
    _count++;
}

/**
 从最大堆中取出堆顶元素, 即堆中所存储的最大数据
 
 */
- (id)extractMax{
    id ret = _data[1];
    [_data exchangeObjectAtIndex:1 withObjectAtIndex:_count];
    _count--;
    [self shiftDown:1];
    return ret;
}

/**
 获取最大堆中的堆顶元素
 
 */
- (id)getMax{
    return _data[1];
}

#pragma mark - Private
- (void)shiftUp:(int )k{
    
}
- (void)shiftDown:(int )k{
    
}


@end
