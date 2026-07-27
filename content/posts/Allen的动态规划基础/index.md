---
title: Allen的动态规划基础
slug: Allen-dynamic-programming
description: 状态和状态转移方程
summary: 状态和状态转移方程
date: 2023-03-13T21:58:57+08:00
draft: false
categories: 月魂
tags:
  - 算法
  - ACM
  - DP
---

> 来点BGM

<center><iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width=400 height=86 src="//music.163.com/outchain/player?type=2&id=28990792&auto=0&height=66"></iframe></center>

## 引言

### 概念

**动态规划（英语：Dynamic programming，简称DP）** 是一种在数学、管理科学、计算机科学、经济学和生物信息学中使用的，通过把原问题分解为相对简单的子问题的方式求解复杂问题的方法。

动态规划常常适用于有**重叠子问题**和**最优子结构**性质的问题，动态规划方法所耗时间往往远少于朴素解法。

### 适用情况

- **最优子结构性质**。
  如果问题的最优解所包含的子问题的解也是最优的，我们就称该问题具有最优子结构性质（即满足最优化原理）。最优子结构性质为动态规划算法解决问题提供了重要线索。

- **无后效性**。即子问题的解一旦确定，就不再改变，不受在这之后、包含它的更大的问题的求解决策影响。

- **子问题重叠性质**。子问题重叠性质是指在用递归算法自顶向下对问题进行求解时，每次产生的子问题并不总是新问题，有些子问题会被重复计算多次。动态规划算法正是利用了这种子问题的重叠性质，对每一个子问题只计算一次，然后将其计算结果保存在一个表格中，当再次需要计算已经计算过的子问题时，只是在表格中简单地查看一下结果，从而获得较高的效率，降低了时间复杂度。

——From [维基百科·动态规划](https://zh.wikipedia.org/wiki/%E5%8A%A8%E6%80%81%E8%A7%84%E5%88%92)

动态规划其实不是一种具体的算法，而是解决问题的思想和方法。简单来说，动态规划就是把问题分解成一个个子问题，通过求子问题的最优解得到全局最优解（这就是所谓的**最优子结构（optimal substructure）**）

## 正文

### 状态和状态转移方程

动态规划的核心是**状态**和**状态转移方程**

> 动态规划中状态就是子问题的结果，而本阶段的状态往往是上一阶段状态和上一阶段决策的结果，描述这种前后阶段关系的方程，就是**状态转移方程**

如 $ f(i, j) = \max \\{f(i, k) , f(k+1, j)+1\\} $ 就是一个状态转移方程

来看看几道例题

### 数字三角形

> 题目：有一个由非负整数组成的三角形，第一行只有一个数。从第一行的数开始，每次可以往左下或右下走一格，直到走到最下行，把沿途经过的数加起来，求怎么走才能使得数字之和最大？

数字三角形如下所示：

```
      1
     / \
    3   2
   / \ / \
  4   10  1
 / \ / \ / \
4   3   2   20
```

### 分析

#### 贪心法？

按照贪心法，求出的路径为：`1 --> 3 --> 10 --> 3`

而实际最大和的路径为：`1 --> 2 --> 1 --> 20`

显然，贪心法不能保证全局最优解

#### 回溯法？

每一个结点都有两种选择，如果用回溯法求出所有可能的的路径，就能找到最优解

然而回溯法的效率太低：一个$ n $层的三角形有 $ 2^{n-1} $ 条路线，复杂度之大让人无法接受

可以看出，这是一个动态的决策问题——每次可以选择往左下走或往右下走，由此引出我们今天的主角——动态规划

#### 动态规划

假设用下三角矩阵（主对角线上方所有元素为0的二维数组）`a`、`d`分别存储数字三角形和`d[i][j]`出发路径的最大和

根据动态规划的思想，求第一层（`d[1][1]`，即整个数字三角形路径的最大和）出发的最大和，得先求出从第二层出发的最大和；求第二层出发的最大和，得先求出从第三层出发的最大和......由此类推，我们可以把整个问题分解成多个子问题。显然，这道题符合动态规划的条件：

- **最优子结构性质**。求出第`n`层的最优解，就能求出第`n-1`层的最优解，子问题的最优解最终保证整个问题的最优解
- **无后效性**。第`n`层的最优解一旦确定，就不受前面层的影响
- **子问题重叠性质**。比如要计算`d[2][1]`,就要先计算`d[3][1]`和`d[3][2]`；而要计算`d[2][2]`,也要先计算`d[3][2]`。由此可见问题的解答树大量重叠，正是动态规划的用武之地

状态转移方程如下

$ d(i, j) = a(i, j) + max\\{d(i+1, j), d(i+1, j+1)\\} $

下面介绍两种基本的动态规划写法

##### 方法一：记忆化搜索

直接递归的写法是可以的，但由于子问题的重叠，会导致大量无用的重复计算，因此要用到记忆化搜索来提前返回

核心代码如下

```C++
// 因为题目说每个数都是非负整数，所以d[]初始化为-1，d[i] >= 0 表示未计算
int solve(int i, int j) {
    if (d[i][j] >= 0) return d[i][j];  // 已经搜索过，直接返回
    return d[i][j] = a[i][j] + (i == n ? 0 : max(solve(i+1, j), solve(i+1, j+1)));  // 保存计算结果的同时并返回值
}
```

这里利用了C语言“赋值语句具有返回值”的特性来简化代码

##### 方法二：递推

注意计算顺序，要从后往前推

核心代码如下

```C++
void solve() {
    for (int i = 1; i <= n; i++) d[n][i] = a[n][i];  // 初始化最后一层
    for (int i = n-1; i >= 1; i--)  // 从后往前递推
        for (int j = 1; j <= i; j++)
            d[i][j] = a[i][j] + max(d[i+1][j], d[i+1][j+1]);
    cout << d[1][1] << endl;
}
```

完整代码可参考[仓库](https://github.com/AllenWu233/algorithm_study/tree/main/chapter_9)（附赠数据生成器Python脚本）

### DAG上的动态规划

跟图论扯上关系了（￣▽￣）

相关月魂：[Allen的图论基础](https://blog-allenwu233.netlify.app/p/allen-graph/)

**DAG（Directed Acyclic Graph，有向无环图）**，即从任意顶点出发无法经过若干条边回到该点的有向图。

#### 不固定终点的最长路和字典序

> 例题：嵌套矩形。
> 题意：给出若干个矩形，选出尽量多的矩形拍成一排，使得除了最后一个之外，每一个矩形都可以嵌套（矩形的长和宽必须严格小于下一个矩形的长和宽；矩形可以旋转）在下一个矩形内。如果有多解，矩形编号的字典序应尽量小

可以看出，“嵌套”是一个二元关系，可以用图来表示。我们使用邻接矩阵来存图

状态转移方程为：$ d(i) = max\\{d(i), d(j)+1\\} $

代码如下：

```C++
#define IOS ios::sync_with_stdio(false);cin.tie(0);cout.tie(0);
#include <iostream>
#include <algorithm>
#include <cstring>
using namespace std;

const int N = 100 + 10;
int n;
int G[N][N], a[N], b[N], d[N];  // d[i] 表示从结点 i 出发的最长路长度

// 读入数据并建图
void read_input() {
    cin >> n;
    int x, y;
    for (int i = 1; i <= n; i++) {
        cin >> x >> y;
        a[i] = min(x, y);
        b[i] = max(x, y);
    }
    for (int i = 1; i <= n; i++)
        for (int j = 1; j <= n; j++)
            if (a[i] < a[j] && b[i] < b[j]) G[i][j] = 1;
}
// 记忆化搜索，注意 d[] 要初始化为0
int dp(int i) {
    int &ans = d[i];  // 用引用来简化读写
    if (ans > 0) return ans;
    ans = 1;
    for (int j = 1; j <= n; j++)
        if (G[i][j]) ans = max(ans, dp(j)+1);
    return ans;
}
// 递归打印答案，保证字典序最小：尽量选择最小的 i 和 j
void print_ans(int i) {
    cout << i << ' ';
    for (int j = 1; j <= n; j++) if (G[i][j] && d[i] == d[j]+1) {
        print_ans(j);
        break;  // 递归返回后退出循环
    }
}

int main() {
#ifdef LOCAL
    freopen("nested_rectangle.in", "r", stdin);
    freopen("nested_rectangle_.out", "w", stdout);
#endif
    int t;
    cin >> t;
    while (t--) {
        memset(d, 0, sizeof(d));
        memset(G, 0, sizeof(G));
        read_input();
        for (int i = 1; i <= n; i++) dp(i);
        int Max = -1, maxi = 1;
        for (int i = 1; i <= n; i++)
            if (d[i] > Max) { Max = d[i]; maxi = i; }
        print_ans(maxi);
        cout << "\n\n";
    }
    return 0;
}
```

> EX: [UVa 437 The Tower of Babylon](https://www.luogu.com.cn/problem/UVA437)

例题的升级版，只是多了一个维度，完全可以套用例题的模板

[AC代码参考](https://github.com/AllenWu233/algorithm_study/blob/main/chapter_9/uva437_the_tower_of_babylon.cpp)

#### 固定终点的最长路和最短路

> 例题：硬币问题。
> 有 n 种硬币，面值分别为 V1, V2, ... , Vn, 每种都有无限多。

> EX: [Uva 1347 Tour](https://www.luogu.com.cn/problem/UVA1347)

原题可转化为：两人从同一起点出发，每次其中一人走动，最后都走到终点

[AC代码参考](https://github.com/AllenWu233/algorithm_study/blob/main/chapter_9/uva1347_tour.cpp)

## 附录

### 参考文献

[1][维基百科·动态规划](https://zh.wikipedia.org/wiki/%E5%8A%A8%E6%80%81%E8%A7%84%E5%88%92)

[2]刘汝佳《算法竞赛入门基础（第2版）》
