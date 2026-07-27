---
title: Uva 1600 Patrol Robot
description: BFS求最短路的升级版
date: 2023-01-11T12:30:00+08:00
lastmod: 2023-01-11T12:30:00+08:00
slug: uva1600
image: cover.jpg
tags: [题解, 算法, 图, 最短路, BFS, 队列, C++, Python]
categories:
    - 学习笔记
---
题目：[洛谷·UVa439](https://www.luogu.com.cn/problem/UVA1600)

## 题意

输入一个`m*n`矩阵表示地图，其中1表示障碍，0表示空地。机器人要从`m*n`地图的`(1,1)`走到`(m,n)`，每次可以往上下左右的其中一个方向走一格，且最多只能连续跨过`k`个障碍。数据满足`1 <= m, n <= 20`， `0 <= k <= 20`

## 分析
首先我们可以确认这不是普通的BFS求最短路（对比：[Uva 439](https://blog-allenwu233.netlify.app/p/uva439/)），但题目多了一个条件——最多能连续跨过`k`个障碍，这意味着只用二位数组不足以判断题目条件

于是我试着用访问数组`int vis[maxn][maxn][2]`存储访问状态，其中`vis[x][y][0]`表示从该格再走一步后的步数，`vis[x][y][1]`表示走到该格需要跨越的障碍数。但这种思路存在问题：程序无法区分跨越不同数量的障碍走到同一格，而是把它们视为同一条路线

只需稍加改进，用`bool vis[maxn][maxn][maxn]`存储访问状态即可，其中`vis[x][y][cnt]`表示连续跨越`cnt`个障碍后到达`(x,y)`

利用结构体存储坐标、步数和连续跨越障碍的数量，方便BFS的入队出队操作（因为只需一个队列）

## 代码
### C++
```C++
#include <iostream>
#include <queue>
#include <cstring>
using namespace std;

const int maxn = 25;
int pic[maxn][maxn];  // 读入地图
bool vis[maxn][maxn][maxn];  // 访问数组，判断是否曾连续跨过若干个障碍到达某格
const int dx[4] = {0, 1, 0, -1};  // 偏移量
const int dy[4] = {1, 0, -1, 0};
int t, m, n, k;

struct Node {
    int x;
    int y;
    int step;  // 当前步数
    int cnt;  // 当前连续跨越障碍的数量
};

void read_lines() {
    cin >> m >> n >> k;
    for (int i = 1; i <= m; i++)
        for (int j = 1; j <= n; j++)
            cin >> pic[i][j];   
}

bool check(int x, int y) {  // 检查是否出界
    if (x < 1 || y < 1 || x > m || y > n) return true;
    return false;
}

int bfs(int x, int y, int k) {
    Node t = {x, y, 0, 0};
    queue<Node> q;
    q.push(t);
    while (!q.empty()) {
        t = q.front();
        if (t.x == m && t.y == n) return t.step;
        for (int i = 0; i < 4; i++) {
            int px = t.x + dx[i], py = t.y + dy[i];
            if (check(px, py)) continue;  // 出界
            Node tmp = {px, py, t.step, t.cnt};  // 一定要用临时变量来操作！
            if (pic[px][py]) tmp.cnt++;  // 该格为障碍
            else tmp.cnt = 0;  // 该格为空地
            if (tmp.cnt <= k && !vis[px][py][tmp.cnt]) {  // 连续跨越障碍数量<=k且未曾连续跨过t.cnt个障碍到达(px,py)
                tmp.step++;
                vis[px][py][tmp.cnt] = true;  // 已访问
                q.push(tmp);
            }
        }
        q.pop();
    }
    return -1;
}

int main() {
#ifdef LOCAL
    freopen("patrol_robot.in", "r", stdin);
    freopen("patrol_robot.out", "w", stdout);
#endif
    ios::sync_with_stdio(false); //取消cin与stdin的同步，加速输入输出
    cin.tie(0);  // 解除cin与cout的绑定，进一步加快执行效率
    cout.tie(0);
    cin >> t;
    while (t--) {
        memset(vis, false, sizeof(vis));  // 记得清零！
        read_lines();
        cout << bfs(1, 1, k) << "\n";
    }
    return 0;
}
```

我们知道cin和cout输入输出的速度比不上printf和scanf，因此可以通过一些小技巧来加速：
```C++
ios::sync_with_stdio(false); //取消cin与stdin的同步，加速输入输出
cin.tie(0);  // 解除cin与cout的绑定，进一步加快执行效率
cout.tie(0);
```
用宏定义可以方便一些：
```C++
#define IOS ios::sync_with_stdio(false);cin.tie(0);cout.tie(0);
```
这样就可以在主函数直接引用了

特别的，`ios::sync_with_stdio(false)`一般不能写在`freopen`前面，大概是会有奇奇怪怪的错误

### Python
```Python
# 重定向
# import sys
# sys.stdin = open(r'patrol_robot.in', 'r') 
# sys.stdout = open(r'patrol_robot.out', 'w')

def read_lines(m):
    pic = []
    for _ in range(m):
        pic.append(list(map(int, input().split())))
    return pic

def check(x, y, m, n):
    if (x < 0 or y < 0 or x > m or y > n):
        return True
    return False

def bfs(x, y, m, n, k):
    global pic, vis
    dx = [0, 1, 0, -1]
    dy = [1, 0, -1, 0]
    q = [[x, y, 0, 0]]  # 利用列表[x, y, step, cnt]存储状态，q为队列
    while len(q):
        t = q[0]
        if t[0] == m and t[1] == n:
            return t[2]
        for i in range(4):
            px = t[0] + dx[i]
            py = t[1] + dy[i]
            if check(px, py, m, n):
                continue
            tmp = [px, py, t[2], t[3]]
            if pic[px][py]:
                tmp[3] += 1
            else:
                tmp[3] = 0
            if tmp[3] <= k and vis[px][py][tmp[3]] == False:
                tmp[2] += 1
                vis[px][py][tmp[3]] = True
                q.append(tmp)
        q.pop(0)
    return -1


for _ in range(int(input())):
    m, n = map(int, input().split())
    k = int(input())
    pic = read_lines(m)
    vis = [[[False]*21 for _ in range(n)] for _ in range(m)]
    print(bfs(0, 0, m-1, n-1, k))
```
Python的列表一般不会像C/C++的数组一样溢出，我们只需根据m,n的大小动态地初始化pic和vis即可

由于下标从1开始，要注意差1错误
