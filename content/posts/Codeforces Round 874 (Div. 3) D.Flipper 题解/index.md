---
title: "Codeforces Round 874 (Div. 3) D.Flipper 题解"
slug: contest-1833-D
description: "" 
summary: "" 
date: 2023-05-25T21:56:26+08:00
lastmod: 
image: 
math: katex
hidden: false
comments: true
categories: ["学习月魂"]
tags: ["贪心", "构造"]
---

## 题目

[D. Flipper](https://codeforces.com/contest/1833/problem/D)

题意：给出一个 $ n $ 排列`p[]`，选择一个区间`[l, r]` (l <= r)，构造一个新的排列：`a[r+1 : ] + a[l : r].reverse() + a[1 : l]` (在这里我用 Python 切片表示，即左闭右开区间)，求能构造出的字典序最大的排列

## 分析

假设答案用 $ ans_i $ 表示

初步分析，当 $ r = n $ 时，$ans_1 = r_{n}$，否则 $ans_1 = r_{n+1}$。为了保证字典序最大，我们需要选取尽可能大的 $ r $

易知当 $ p_1 = n $ 时，$ r $ 应选取 $ n-1 $，否则选取 $ n $

确定 $ r $ 后再来看 $ l $，这里有个技巧：先输出`a[r+1 : ] + a[r]`，再从`a[r-1]`开始往前遍历，只要 `a[i] < a[1]`（说明如果 $ l $ 选 $ i $ 的话，操作之后字典序反而变小，所以 $ l $ 选 $ i+1 $），就马上输出 `a[1 : i+1]` (注意这里还是左闭右开区间)

这是 CF 上的题解：
>In these constraints we could solve the problem for $ O(n^2) $. Let us note that there can be no more than two candidates for the value $r$. Since the first number in the permutation will be either $p_r+1$ if $r<n$, or $p_r$ if $r=n$. Then let's go through the value of $r$ and choose the one in which the first number in the resulting permutation is as large as possible. Next, if $p_n=n$, then we can have two candidates for $r$ is $n$,$n−1$, but note that it is always advantageous to put $r=n$ in that case, since it will not spoil the answer. Then we can go through $l$, and get the solution by the square, but we can do something smarter.
>
>Notice now that the answer already contains all the numbers $p_i$
where $i>r$. And then we write $p_r$, $p_r−1$, …, $p_l$ where $l$ is still unknown, and then $p_1$, $p_2$, …, $p_l−1$. In that case, let's write pr as $l≤r$ and then write $p_r−1$, $p_r−2$, … as long as they are larger than $p_1$. Otherwise, we immediately determine the value of $l$ and finish the answer to the end. Thus, constructively we construct the maximal permutation.

## 代码

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
const LL LINF = 0x3f3f3f3f3f3f3f3f;
const double PI = acos(-1.0);

using namespace std;

const int N = 2000 + 20;
int n, a[N];


void init() {
    cin >> n;
    for (int i = 1; i <= n; i++) cin >> a[i];
}

void solve() {
    int r = 1;
    // choose r, i.e. find the largest num in a[1:n] and record its index
    // if a[i] == n, choose a[r] == n-1
    // else a[r] == n
    for (int i = 1; i <= n; i++) {
        if (a[min(n, r+1)] <= a[min(n, i+1)]) r = i;
    }

    // cout << a[r+1:]
    for (int i = r+1; i <= n; i++) cout << a[i] << ' ';

    cout << a[r] << ' ';

    // cout << a[r-1]..a[l] << a[1:l]
    for (int i = r-1; i > 0; i--) {
        if (a[i] > a[1]) {
            cout << a[i] << ' ';
        }
        // find l: l = i-1
        else {
            for (int j = 1; j <= i; j++) {
                cout << a[j] << ' ';
            }
            break;
        }
    }
    cout << "\n";
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

CF 上的题解写的很妙：
```C++
int r = 1;
for (int i = 1; i <= n; i++) {
    if (a[min(n, r+1)] <= a[min(n, i+1)]) r = i;
}
```

等价于：
```C++
int r = 1;
if (a[1] == n) {
    if (a[n] == n-1) {
        r = n;
    }
    else for (int i = 2; i <= n; i++) {
        if (a[i] == n-1) {
            r = i-1;
            break;
        }
    }
}
else {
    if (a[n] == n) {
        r = n;
    }
    else for (int i = 1; i <= n; i++) {
        if (a[i] == n) {
            r = i-1;
            break;
        }
    }
}
```

优雅地把我当时写的十几行代码压缩成两三行

![真是漂亮滴很呐](content/zh/posts/Codeforces%20Round%20874%20(Div.%203)%20D.Flipper%20题解/B784EC3F47E31090269A04FC58C874D8.jpg)

## 总结

当时卡在这题了，找出 $ r $ 后就不会了。其实只要稍微转换一下思路，反向思考就好啦 （￣▽￣）
