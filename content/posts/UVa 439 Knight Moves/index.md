---
title: UVa 439 Knight Moves
description: 来下国际象棋吧
date: 2023-01-09T18:33:00+08:00
lastmod: 2023-01-09T18:33:00+08:00
slug: uva439
cover:
  image: /img/uva439_cover.jpg
tags: [题解, 算法, 图, 最短路, BFS, 队列, C++]
categories:
    - 学习笔记
---

![](content/zh/posts/UVa%20439%20Knight%20Moves/cover_.jpg)
第一次写题解惹~

简单，但是卡了好一会，最后发现是忘了清零数组 XD

题目：[洛谷·UVa439](https://www.luogu.com.cn/problem/UVA439)
## 题意

输入8*8国际象棋棋盘的两个坐标（起点和终点。列：a~h，行：1~8），求出马（Knight）从起点到终点所需最少步数

## 分析
典型的BFS求最短路问题。二维数组`id[10][10]`存储从该格再走一步后的步数，队列`qx`,`qy`存储坐标

注意到每个格子不能重复，否则无法算出最短路

## 代码
```C++
#include <iostream>
#include <string>
#include <queue>
#include <cstring>
using namespace std;
// 偏移量：马能走的八个方向
const int dx[8] = {-1,-2,-2,-1,1,2,2,1};
const int dy[8] = {2,1,-1,-2,-2,-1,1,2};
int id[10][10];

int bfs(int x, int y, int x_target, int y_target) {
    if (x == x_target && y == y_target) return 0;  // 起点即终点
    queue<int> qx, qy;
    qx.push(x), qy.push(y);
    id[x][y] = 1;
    while (1) {
        x = qx.front(), y = qy.front();
        for (int i = 0; i < 8; i++) {
            int newx = x + dx[i], newy = y + dy[i];
            if (newx == x_target && newy == y_target) return id[x][y];
            if (newx < 1 || newy < 1 || newx > 8 || newy > 8 || id[newx][newy])  // 出界或已走过的点
                continue;
            qx.push(newx), qy.push(newy);
            id[newx][newy] = id[x][y] + 1;
        }
        qx.pop(), qy.pop();
    }
}

int main() {
#ifdef LOCAL
    freopen("knight_moves.in", "r", stdin);
    freopen("knight_moves.out", "w", stdout);
#endif
    string start, target;
    while (cin >> start >> target && start.length() && target.length()) {
        memset(id, 0, sizeof(id));  // 记得清零！
        cout<<"To get from "<<start<<" to "<<target<<" takes ";
        cout<<bfs(start[1]-'0', start[0]-'a'+1, target[1]-'0', target[0]-'a'+1)<<" knight moves.\n";
    }
}
```

## P.S.小技巧
你应该注意到了，我采用了重定向输入输出，却没有在代码里定义LOCAL符号——其实我已经在编译选项里编译了

这样做的好处是，在本地调试时默认为重定向输入输出，提交到oj时自动忽略编译重定向这段代码，方便且能避免出错

只需在编译时加上`-DLOCAL`这条参数即可。我的做法是修改Sublime Text的编译系统文件：
>c++_acm.sublime-build

```
{
   "shell_cmd": "g++ -finput-charset=UTF-8 -fexec-charset=GBK -Wall -DLOCAL \"${file_name}\" -o \"${file_base_name}\" && ${file_base_name} && echo Press ENTER to continue...",
   "file_regex": "^(..[^:]*):([0-9]+):?([0-9]+)?:? (.*)$",
   "working_dir": "${file_path}",
   "selector": "source.c++",
   "encoding": "gbk",
   "variants":
   [
       {
           "name": "Single File Build & Run in cmd",
           "shell_cmd": "g++ -finput-charset=UTF-8 -fexec-charset=GBK -g -Wall \"${file_name}\" -o \"${file_base_name}\" && start cmd /c \"\"${file_base_name}\" & pause\""
       }
   ]
}
```

按`Ctrl + Shift + B`，显示两条编译选项，第一条是重定向，第二条是通过终端窗口进行标准输入输出

~~重定向一用一时爽，一直用一直爽（~~
