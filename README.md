# 在Object-C中学习数据结构与算法之排序算法

![](http://oriq21dog.bkt.clouddn.com/bloc/2017-07-15-Snip20170715_24.png)

> 笔者在学习数据结构与算法时，尝试着将排序算法以动画的形式呈现出来更加方便理解记忆，本文配合[Demo 在Object-C中学习数据结构与算法之排序算法](https://github.com/MisterBooo/Play-With-Sort-OC)阅读更佳。

> 你可以在公众号 **五分钟学算法** 获取更多数据结构与算法相关的内容

> 公众号回复 **github** 获取十大经典排序动画。




## 目录
 * 选择排序
 * 冒泡排序
 * 插入排序
 * 快速排序
 * 双路快速排序
 * 三路快速排序
 * 堆排序
 * 总结与收获
 * 参考与阅读

### 选择排序
选择排序是一种简单直观的排序算法，无论什么数据进去都是 O(n²) 的时间复杂度。所以用到它的时候，数据规模越小越好。唯一的好处可能就是不占用额外的内存空间了吧。

#### 1.算法步骤
1. 首先在未排序序列中找到最小（大）元素，存放到排序序列的起始位置

2. 再从剩余未排序元素中继续寻找最小（大）元素，然后放到已排序序列的末尾。

3. 重复第二步，直到所有元素均排序完毕。

#### 2.动画演示
![](http://oriq21dog.bkt.clouddn.com/bloc/2017-08-02-%E9%80%89%E6%8B%A9%E6%8E%92%E5%BA%8F.gif)

#### 3.代码实现
```
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
```
### 冒泡排序
冒泡排序（Bubble Sort）也是一种简单直观的排序算法。它重复地走访过要排序的数列，一次比较两个元素，如果他们的顺序错误就把他们交换过来。走访数列的工作是重复地进行直到没有再需要交换，也就是说该数列已经排序完成。这个算法的名字由来是因为越小的元素会经由交换慢慢“浮”到数列的顶端。

#### 1.算法步骤
1. 比较相邻的元素。如果第一个比第二个大，就交换他们两个。

2. 对每一对相邻元素作同样的工作，从开始第一对到结尾的最后一对。这步做完后，最后的元素会是最大的数。

3. 针对所有的元素重复以上的步骤，除了最后一个。

4. 持续每次对越来越少的元素重复上面的步骤，直到没有任何一对数字需要比较。

#### 2.动画演示
![](http://oriq21dog.bkt.clouddn.com/bloc/2017-08-02-%E5%86%92%E6%B3%A1%E6%8E%92%E5%BA%8F.gif)
#### 3.代码实现
```
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
```
### 插入排序
插入排序的代码实现虽然没有冒泡排序和选择排序那么简单粗暴，但它的原理应该是最容易理解的了，因为只要打过扑克牌的人都应该能够秒懂。插入排序是一种最简单直观的排序算法，它的工作原理是通过构建有序序列，对于未排序数据，在已排序序列中从后向前扫描，找到相应位置并插入。
![](http://oriq21dog.bkt.clouddn.com/bloc/2017-08-02-Snip20170802_30.png)

#### 1.算法步骤
1. 将第一待排序序列第一个元素看做一个有序序列，把第二个元素到最后一个元素当成是未排序序列。

2. 从头到尾依次扫描未排序序列，将扫描到的每个元素插入有序序列的适当位置。（如果待插入的元素与有序序列中的某个元素相等，则将待插入元素插入到相等元素的后面。）

#### 2.动画演示
![](http://oriq21dog.bkt.clouddn.com/bloc/2017-08-02-%E6%8F%92%E5%85%A5%E6%8E%92%E5%BA%8F.gif)

#### 3.代码实现
```
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
```

### 归并排序
归并排序（Merge sort）是建立在归并操作上的一种有效的排序算法。该算法是采用分治法（Divide and Conquer）的一个非常典型的应用。

作为一种典型的分而治之思想的算法应用，归并排序的实现由两种方法：

>1. 自上而下的递归（所有递归的方法都可以用迭代重写，所以就有了第 2 种方法）  
>2. 自下而上的迭代；

本文使用的是**自顶向下**的归并排序
#### 1.算法步骤 
1. 申请空间，使其大小为两个已经排序序列之和，该空间用来存放合并后的序列；

2. 设定两个指针，最初位置分别为两个已经排序序列的起始位置；

3. 比较两个指针所指向的元素，选择相对小的元素放入到合并空间，并移动指针到下一位置；

4. 重复步骤 3 直到某一指针达到序列尾；

5. 将另一序列剩下的所有元素直接复制到合并序列尾。

#### 2.动画演示
![](http://oriq21dog.bkt.clouddn.com/bloc/2017-08-02-%E5%BD%92%E5%B9%B6%E6%8E%92%E5%BA%8F.gif)

#### 3.代码实现
```
#pragma mark - /**归并排序 自顶向下*/
- (void)mb_mergeSort{
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
```
### 快速排序
快速排序是由东尼·霍尔所发展的一种排序算法。在平均状况下，排序 n 个项目要 Ο(nlogn) 次比较。在最坏状况下则需要 Ο(n2) 次比较，但这种状况并不常见。事实上，快速排序通常明显比其他 Ο(nlogn) 算法更快，因为它的内部循环（inner loop）可以在大部分的架构上很有效率地被实现出来。

快速排序使用分治法（Divide and conquer）策略来把一个串行（list）分为两个子串行（sub-lists）。

快速排序又是一种分而治之思想在排序算法上的典型应用。本质上来看，快速排序应该算是在冒泡排序基础上的递归分治法。

快速排序的名字起的是简单粗暴，因为一听到这个名字你就知道它存在的意义，就是快，而且效率高！它是处理大数据最快的排序算法之一了。

#### 1.算法步骤
1. 从数列中挑出一个元素，称为 “基准”（pivot）;

2. 重新排序数列，所有元素比基准值小的摆放在基准前面，所有元素比基准值大的摆在基准的后面（相同的数可以到任一边）。在这个分区退出之后，该基准就处于数列的中间位置。这个称为分区（partition）操作；

3. 递归地（recursive）把小于基准值元素的子数列和大于基准值元素的子数列排序；

**快速排序的优化可考虑当分区间隔小的的时候转而使用插入排序**
#### 2.动画演示
![](http://oriq21dog.bkt.clouddn.com/bloc/2017-08-02-%E5%BF%AB%E9%80%9F%E6%8E%92%E5%BA%8F.gif)

#### 3.代码实现
```
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
```

### 双路快速排序
过多重复键值使Quick Sort降至O(n^2)  
使用双快速排序后, 我们的快速排序算法可以轻松的处理包含大量元素的数组  
**快速排序的优化可考虑当分区间隔小的的时候转而使用插入排序**

#### 1.算法图示
![](http://oriq21dog.bkt.clouddn.com/bloc/2017-08-02-Snip20170802_31.png)

#### 2.动画演示
![](http://oriq21dog.bkt.clouddn.com/bloc/2017-08-02-%E5%8F%8C%E8%B7%AF%E6%8E%92%E5%BA%8F.gif)

#### 3.代码实现
```
#pragma mark - /**双路快排*/
///使用双快速排序后, 我们的快速排序算法可以轻松的处理包含大量元素的数组
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

```
### 三路快速排序
对于包含有大量重复数据的数组, 三路快排有巨大的优势  
对于一般性的随机数组和近乎有序的数组, 三路快排的效率虽然不是最优的, 但是是在非常可以接受的范围里  
因此, 在一些语言中, 三路快排是默认的语言库函数中使用的排序算法。比如Java:)

**快速排序的优化可考虑当分区间隔小的的时候转而使用插入排序**

#### 1.算法图示
![](http://oriq21dog.bkt.clouddn.com/bloc/2017-08-02-Snip20170802_32.png)

#### 2.动画演示
![](http://oriq21dog.bkt.clouddn.com/bloc/2017-08-02-%E4%B8%89%E8%B7%AF%E6%8E%92%E5%BA%8F.gif)
#### 3.代码实现
```
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

```
### 堆排序
堆排序（Heapsort）是指利用堆这种数据结构所设计的一种排序算法。堆积是一个近似完全二叉树的结构，并同时满足堆积的性质：即子结点的键值或索引总是小于（或者大于）它的父节点。堆排序可以说是一种利用堆的概念来排序的选择排序。分为两种方法：

大顶堆：每个节点的值都大于或等于其子节点的值，在堆排序算法中用于升序排列；  
小顶堆：每个节点的值都小于或等于其子节点的值，在堆排序算法中用于降序排列；  
堆排序的平均时间复杂度为 Ο(nlogn)。

#### 1.算法步骤
1. 创建一个堆 H[0……n-1]；

2. 把堆首（最大值）和堆尾互换；

3. 把堆的尺寸缩小 1，并调用 shift_down(1)，目的是把新的数组顶端数据调整到相应位置；

4. 重复步骤 2，直到堆的尺寸为 1


#### 2.动画演示
![](http://oriq21dog.bkt.clouddn.com/bloc/2017-08-02-%E5%A0%86%E6%8E%92%E5%BA%8F.gif)

#### 3.代码实现
```
///shift_down操作
- (void)shiftDown:(int )k{
    while (2 * k <= _count) {
        int j = 2 * k;
        if (j + 1 <= _count && [self heapCompareWithBarOne:_data[j + 1] andBarTwo:_data[j]] == NSOrderedDescending) j++;//左孩子小于右孩子
        if ([self heapCompareWithBarOne:_data[k] andBarTwo:_data[j]] == NSOrderedDescending) break;//父节点大于子节点
        self.comparator(nil, nil);
        [_data mb_exchangeWithIndexA:k indexB:j];
        k = j;
    }
}

```

### 总结与收获
**总结**： 在这次重新学习数据结构与算法的过程中笔者充分认识到了学习这些所谓的**基础知识**的重要性，了解了要想进一步提供iOS开发的水平恰恰不能忽视基础环节，也恰好在这次学习中用到了图的深度遍历解决了在研究埋点过程中找到回溯源的问题。  

**收获**：
> 1. 基本排序的白板编程
> 2. runtime的添加分类
> 3. runtime的objc_msgSend()
> 4. 深拷贝与浅拷贝
> 5. GCD信号量的使用

**如果各位读者看完有所收获欢迎在[Github](https://github.com/MisterBooo/Play-With-Sort-OC)上给个star (*^__^*)**
### 参考与阅读
* [一本关于排序算法的 GitBook 在线书籍 《十大经典排序算法》，使用 JavaScript & Python & Go 实现](https://github.com/hustcc/JS-Sorting-Algorithm)
* [在 JavaScript 中学习数据结构与算法](https://juejin.im/post/594dfe795188250d725a220a)
* [排序动画](https://github.com/JiongXing/JXSort)
#### 欢迎关注
![](https://user-gold-cdn.xitu.io/2018/10/29/166bdc7cde6c4fd8?w=258&h=258&f=jpeg&s=27779)
