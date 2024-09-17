// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InsertionSort {
    // 定义一个动态数组，用于存储整数
    uint[]  public numbers;

    // 构造函数，用于初始化数组
    constructor(uint[] memory _numbers) {
        numbers = _numbers;
    }

    function insertionSort() public {
        for (uint i = 1; i < numbers.length; i++) {
            uint key = numbers[i];
            uint j = i - 1;
            // 将选中的元素与前面的元素比较，如果前面的元素大于选中的元素，则将前面的元素向后移动
            while (j >= 0 && numbers[j] > key) {
                numbers[j + 1] = numbers[j];
                j = j - 1;
            }
            // 将选中的元素放到正确的位置
            numbers[j + 1] = key;
        }
    }

    // 获取排序后的数组
    function getSortNumbers() public view returns (uint[] memory) {
        return numbers;
    }
}
