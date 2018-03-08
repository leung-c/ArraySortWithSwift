//
//  SortTool.swift
//  ArraySortWithSwift
//
//  Created by liangchao on 2018/2/28.
//  Copyright © 2018年 lch. All rights reserved.
//

import UIKit

typealias IndexMoved = (Int,Int)->();
typealias SortComplete = ([Float])->();

enum SortType {
    case Bubble
    case Select
    case Insert
    case Quick
    //待添加
    case Heap
}

class SortTool: NSObject {
    
    class func sortWith(type:SortType,forVlaues:[Float],indexChangeCallback:IndexMoved,complete:SortComplete)->Void {
        switch type {
        case .Bubble:
            bubbleSort(values: forVlaues, movedIndex: indexChangeCallback, compelete: complete);
            break;
        case .Select:
            selectorSort(values: forVlaues, movedIndex: indexChangeCallback, compelete: complete);
            break;
        case .Insert:
            insertSort(values: forVlaues, movedIndex: indexChangeCallback, compelete: complete);
            break;
        case.Quick:
            startQuickSort(values: forVlaues, movedIndex: indexChangeCallback, compelete: complete);
            break;
        default:
            break;
        }
    }
    
    //冒泡排序
    //就是不断比较相邻的两个数，让较大的元素不断地往后移。经过一轮比较，就选出最大的数；经过第2轮比较，就选出次大的数，以此类推。
    class func bubbleSort( values:[Float],movedIndex:IndexMoved,compelete:SortComplete) -> Void {
        
        var values = values
        
        for i in 0..<values.count-1{
            var j = 0;
            for _  in 0..<values.count-1-i{
                if(values[j] > values[j+1]){
                    values.swapAt(j, j+1);
                    movedIndex(j,j+1);
                }
                j = j+1;
            }
        }
        compelete(values);
    }
    
    //首先，选出最小的数，放在第一个位置；然后，选出第二小的数，放在第二个位置；以此类推，直到所有的数从小到大排序。
    //在实现上，我们通常是先确定第i小的数所在的位置，然后，将其与第i个数进行交换。
    class func selectorSort( values:[Float],movedIndex:IndexMoved,compelete:SortComplete) -> () {
        
        var values = values
        
        for i in 0..<values.count-1{
            var minIndex = i;
            
            for j  in i+1...values.count-1{
                if(values[j] < values[minIndex]){
                    minIndex = j;
                }
            }
            values.swapAt(i,minIndex);
            movedIndex(i,minIndex);
        }
        compelete(values);
    }
    
    //将数组分成已排序部分和未排序部分，每次从排序中找到最大的元素，在已排序部分中比较，插入都整却位置
    class func insertSort( values:[Float],movedIndex:IndexMoved,compelete:SortComplete) -> () {
        if(values.count <= 1){
            return;
        }
        var values = values

        for i in 0..<values.count-1{
            //取未排序中的第一个元素
            //这里是优化，在查找正确位置的同时进行元素位置交换，将j位置的元素在比较的同时进行位置交换直到遇到不小于它的值
            var targetIndex = i + 1;
            while(targetIndex > 0 && values[targetIndex] < values[targetIndex-1]){
                values.swapAt(targetIndex, targetIndex - 1);
                movedIndex(targetIndex,targetIndex - 1);
                targetIndex -= 1;
            }
        }
 
        /*
        //一般版本:
        for i in 1..<values.count {
            var j = 0;
            while(values[j] < values[i] && j < i){
                j += 1;
            }
            if(i != j){
                let valueI = values[i];
                var k = i
                while(k > j){
                    values[k] = values[k-1];
                    k -= 1;
                }
                values[j] = valueI;
            }
        }
        */
        
        compelete(values);
        
        
    }
    
    //将所要进行排序的数分为左右两个部分，其中一部分的所有数据都比另外一 部分的数据小，然后将所分得的两部分数据进行同样的划分，重复执行以上的划分操作，直 到所有要进行排序的数据变为有序为止。
    class func startQuickSort( values:[Float],movedIndex:IndexMoved,compelete:SortComplete) -> () {
        var v = values;
        quickSortFor(values: &v, start: 0, end: values.count-1, movedIndex: movedIndex);
        compelete(v);
    }
    
    class func quickSortFor( values:inout [Float],start:Int,end:Int,movedIndex:IndexMoved){
        if(start >= end){
            return;
        }
        let pivot = parttionSort(values: &values, low: start, high: end,movedIndex: movedIndex);
        quickSortFor(values: &values, start: start, end: pivot-1,movedIndex: movedIndex);
        quickSortFor(values: &values, start: pivot+1, end:end,movedIndex: movedIndex);
    }
    
    class func parttionSort( values:inout [Float],low:Int,high:Int,movedIndex:IndexMoved )-> Int{
        let key = values[low];
        var highIndex = high;
        var lowIndex = low;
        while (lowIndex < highIndex) {
            while (highIndex > lowIndex && values[highIndex] >= key ) {
                highIndex -= 1;
            }
            //找到了比key小的元素，小值给low
            if(highIndex > lowIndex){
//                values[lowIndex] = values[highIndex];
                values.swapAt(lowIndex, highIndex);
                movedIndex(lowIndex,highIndex);
                lowIndex += 1;
            }
            
            while (lowIndex < highIndex && values[lowIndex] <= key) {
                lowIndex += 1;
            }
            //找到比key大的元素，大值给high
            if(lowIndex < highIndex){
//                values[highIndex] = values[lowIndex];
                values.swapAt(lowIndex, highIndex);
                movedIndex(lowIndex,highIndex);
                highIndex -= 1;
            }
        }
        values[lowIndex] = key;
        return lowIndex;
    }
    
    
    
    class func heapSort( values:[Float],movedIndex:IndexMoved,compelete:SortComplete) -> () {
        
    }
    
    
    class func supportSortTypes()->[(name:String,type:SortType)]{
        return [(name:"冒泡",type:SortType.Bubble),(name:"选择",type:SortType.Select),(name:"插入",type:SortType.Insert),(name:"快速",type:SortType.Quick)];
    }
    
}



