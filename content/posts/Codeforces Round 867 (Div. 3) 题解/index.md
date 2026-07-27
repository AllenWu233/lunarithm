---
title: Codeforces Round 867 (Div. 3) 题解
slug: contest-1822
description: 第一篇CF题解
summary: 第一篇CF题解
date: 2023-04-25T15:59:32+08:00
categories:
  - 笔记
tags:
  - 题解
  - ACM
  - Codeforces
  - 算法
---

## 前言

题目链接：[Codeforces Round 867 (Div. 3)](https://codeforces.com/contest/1822)

入坑以来打的最好的一次。特写此题解，记录一下心得

A 题为完整代码，其他题目只有核心代码（省略了模板）

## 正文

### A. TubeTube Feed

>题意：给出数组`a[]`（代表视频长度，单位：s）和`b[]`（代表视频的“entertainment value”，我们用变量`fun`来存储其最大值），整数`t`（午餐时长）。对于一个视频，可以跳过（消耗1s）,也可以决定就看这个视频，但要保证消耗的时间和视频时长之和不超过`t`。求选择观看哪一个视频（求出`a[]`的下标），使得`fun`最大

根据题意模拟即可

```C++
#include <bits/stdc++.h>

#define IOS ios::sync_with_stdio(false);cin.tie(0);cout.tie(0);
#define _all(x) (x).begin(), (x).end()
#define _abs(x) ((x >= 0) ? (x) : (-x))
#define PII pair<int, int>
#define PLL pair<LL, LL>
#define PDD pair<double, double>
#define fi first
#define se second

typedef long long LL;
typedef long double LD;
typedef unsigned long long ULL;

const int INF = 0x3f3f3f3f;
const double PI = acos(-1.0);

using namespace std;

const int N = 50 + 5;
int n, t, a[N], b[N];


void init() {
    cin >> n >> t;
    for (int i = 1; i <= n; i++) cin >> a[i];
    for (int i = 1; i <= n; i++) cin >> b[i]; 
}

void solve() {
    int ans = -1, fun = -1;
    for (int i = 1; i <= n; i++) {
        if (a[i] <= t)
            if (fun < b[i]) {
                ans = i;
                fun = b[i];
            }
        t--;
    }    
    cout << ans << "\n";
}

int main() {
    IOS
    int test_case;
    cin >> test_case;
    while (test_case--) {
        init();
        solve();
    }
    return 0;
}
```

### B. Karina and Array

>题意：给出一个数组，找到两个数，使得这两个数的积最大

排序，比较 `最大数`与`次大数`之积、`最小数`与`次小数`之积的大小即可

注意中间变量要用`long long`存储

```C++
const int N = 2e5 + 20;
int n, a[N];


void solve() {
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];
    sort(a, a+n);
    cout << max(((LL)a[0] * (LL)a[1]), ((LL)a[n-1] * (LL)a[n-2])) << "\n";
}
```

### C. Bun Lover

>题意：两个面包卷以螺旋状盘成一个边长为$ n $正方形（蚊香？），每个面包卷的内外都涂有巧克力酱。给出任意的 $ n $ ，求巧克力酱线段的总长

容易找到规律：<br> 
$ ans = 4n + (n - 1) + 2(n - 2) + 2(n - 3) + ... + 2 \times 2 + 1 \times 3 = 5n + \frac{(1+n-2)(n-2)}{2} \times 2 = n^2 + 2n + 2 $


```C++
LL n;

void solve() {
    cin >> n;
    cout << n*n + 2*n + 2 << "\n";
}

```

### D. Super-Permutation

>题意：构造一个n排列，使得其前缀和数组各元素 $ \(\mod n\ \) + 1 $ 后也是一个n排列

构造题。容易看出前缀和数组各元素模上n后为`0 ~ n-1`，根据模运算的性质：<br>
$ (a+b) \mod n = a \mod n + b \mod n $ <br>
我们可以直接对取模后的余数进行加法操作

以$ n = 6$为例。构造出`6 5 2 3 4 1`，其余数数组为`0 5 2 3 4 1`，则前缀和模n数组为`0 5 1 4 2 3`
比较一下构造出来的数列和前缀和数组模n:
```
6 5 2 3 4 1
0 5 1 4 2 3
```
发现规律了吗？

对于任意的n，两个两个地构造前缀和模n数组：
```
b = [0, n-1, 1, n-2, 2, n-3, ......]
```
即可。不过我们不需要构造出这个数组再来构造n排列，直接计算就行（具体细节参考代码）

#### 关于正确性的分析

先来构造前缀和模n数组。首先考虑0。0必须放在首位，否则会出现两个相同的元素

其次，n为奇数一定无解，反之一定有解。

对于该数组，$ sum = \frac{(1 + n)n}{2} $，令 $ k = \frac{1 + n}{2} $ ，则 $ sum = kn $

当 $ n $ 为奇数时，$ k $为整数，则 $ sum \mod n = 0 $ ，与已存在的 0 相矛盾

当 $ n $ 为偶数时，$ k $不为整数，且 $ sum \mod n = \frac{n}{2} $ ，不存在矛盾

#### 代码

```C++
int n;

void solve() {
    cin >> n;
    if (n == 1) { cout << 1 << "\n"; return; }
    if ((n & 1) == 1) {
        cout << -1 << "\n";
        return;
    }
    cout << n << ' ' << n-1 << ' ';
    for (int i = 1; i < n / 2; i++) {
        cout << i*2 << ' ' << n - i*2 - 1 << ' ';
    }
    cout << "\n";
}
```

### E. Making Anti-Palindromes

### F. Gardening Friends

### G1. Magic Triples (Easy Version)

### G2. Magic Triples (Hard Version)

(To be continued...)