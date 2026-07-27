---
title: "GDCPC 2022 E 黑白大陆"
slug: gdcpc-2022-e
description: "DFS、BFS与最短路的碰撞"
date: 2023-04-11T13:17:06+08:00
tags: ["题解", "图论", "BFS", "DFS", "最短路"]
series: "ACM题解"
categories: "月魂"
---

## 题目

> **代码长度限制** 16 KB  
> **Java (javac)**  
> 时间限制 2000 ms  
> 内存限制 512 MB
>
> **其他编译器**  
> 时间限制 1000 ms  
> 内存限制 512 MB

---

毕业出了魔法学院的 YahAHa 回到了他的家乡---黑白大陆。

黑白大陆是一块由 $n \times m$ 个格子组成的方形大陆，在每一个格子上标有黑色或白色，在黑白大陆上，不同颜色的相邻格子之间时常会发生战争。

热爱和平的 YahAHa 想要把黑白大陆统一成象征和平的白色。

YahAHa 会一种神奇的魔法，他可以把**连通的白色区域变成黑色**，**连通的黑色区域变成白色**。

YahAHa 不想消耗太多法力，于是他想知道，把整个黑白大陆变成白色最少需要使用几次魔法。

---

**输入格式**  
第一行两个整数 $n, m$（$1 \leq n, m \leq 50$）表示黑白大陆的大小。  
接下来 $n$ 行，每行 $m$ 个整数 $a_{i,j}$ 表示黑白大陆每一个格子的颜色。（$0 \leq a_{i,j} \leq 1$，其中 $0$ 表示代表和平的白色，$1$ 表示黑色）

**输出格式**  
一行一个整数，表示把整个黑白大陆变成白色最少需要使用几次魔法。

**输入样例**

```text
3 3
1 0 1
0 1 0
1 0 1
```

**输出样例**

```text
3
```

## 分析

> 题意：给出一个 $ m \times n $ 的布尔矩阵，每次可以进行一下两种操作之一：
>
> - 选择一个元素 $(i,j)$ ，如果：
>   - $ a\_{i,j} = 1 $：将该点和与其相邻的所有$1$都变成$0$
>   - $ a\_{i,j} = 0 $：将该点和与其相邻的所有$0$都变成$1$
>     求把整个矩阵都变为$0$所需的最少步数

显然，我们需要用DFS来判断连通块。可以写两个DFS分别判断黑色（1）和白色（0）连通块，把连通块看作结点，判连通块的同时根据连通块之间的接壤关系组织成图。如果`a[i][j] == 1`，则`vis[i][j] = idx`，否则`vis[i][j] = -idx`，idx为结点编号

求从某一个点开始操作，把整个图都变为$0$的步数，即求从该点出发遍历整个图的步数。也就是说，我们可以用BFS求出该点到所有点的***最短路***（**特别的，如果最短路终点的值为 $1$ ，则最短路的长度要 $+1$ ，因为把整条路径都变为 $0$ 需要再多加一步**），取最短路的最大值为 $t$ ，然后对每个结点都做一次BFS，$min\\{t\\}$ 即为答案

结点数不大于 $50 \times 50 = 2500$ 个，用邻接表存图比较方便，且不会超时

注意到重边不会影响BFS（结点一入队就被打上访问标记），因此存图时不用判重，省下了 $O(\sum_{u=1}^{idx} d^{+}(u-1)!)$ （$idx$为结点编号最大值） 的时间复杂度，也就是“用空间换时间”<br>
~~（事实上，本题加上判重操作也能AC,不差这点时间复杂度）~~

总时间复杂度为：DFS + BFS<br>
$O(nm)$ + $O((n + m) \times (n + m + \sum_{u=1}^{n + m} d^{+}(u)))$

## 代码

```C++
#include <bits/stdc++.h>
#define IOS ios::sync_with_stdio(false);cin.tie(0);cout.tie(0);
using namespace std;

const int N = 50 + 5;
const int dx[] = {1,0,-1,0};
const int dy[] = {0,1,0,-1};
const int INF = 0x3f3f3f3f;
int n, m, a[N][N], vis[N][N], c[N*N], idx = 1, ans = INF;
// a存储输入，vis存储连同块（结点）编号，c存储结点颜色
bool bvis[N*N];  // 用于BFS判断结点是否已访问
vector<vector<int>> G;  // 邻接表


struct Node {
    int idx, step;
};

// 检查是否在界线内
bool check(int x, int y) {
    return 1 <= x && x <= n && 1 <= y && y <= m;
}

// 判断黑连通块并建图
bool dfs1(int x, int y) {
    if (vis[x][y] > 0) return false;  // 不是黑连通块
    // 与白连通块接壤，建边
    if (a[x][y] == 0) {
        if (vis[x][y] < 0) {  // 重边不影响BFS,不用判重
            G[idx].push_back(-vis[x][y]);
            G[-vis[x][y]].push_back(idx);
        }
        return false;
    }

    vis[x][y] = idx;  // 访问标记，也是结点编号
    c[idx] = 1;  // 结点颜色为黑（1）

    // 继续DFS
    for (int i = 0; i < 4; i++) {
        int nx = x + dx[i], ny = y + dy[i];
        if (check(nx, ny) && vis[nx][ny] <= 0) dfs1(nx, ny);
    }
    return true;  // 是黑连通块
}

// 判断白连通块并建图
bool dfs0(int x, int y) {
    if (vis[x][y] < 0) return false;
    // 与黑连通块接壤，建边
    if (a[x][y] == 1) {  // 重边不影响BFS,不用判重
        if (vis[x][y] > 0) {
            G[idx].push_back(vis[x][y]);
            G[vis[x][y]].push_back(idx);
        }
        return false;
    }

    vis[x][y] = -idx;  // 访问标记，也是结点编号
    // 结点颜色为白（0）。不做操作，因为 c 初始值为 0

    // 继续DFS
    for (int i = 0; i < 4; i++) {
        int nx = x + dx[i], ny = y + dy[i];
        if (check(nx, ny) && vis[nx][ny] >= 0) dfs0(nx, ny);
    }
    return true;
}

// 求无权图上的最短路
void bfs(int k) {
    memset(bvis, 0, sizeof(bvis));
    int t = -INF;  // 存储到各个结点的最短路的最大值
    Node tmp;
    queue<Node> q;
    q.push({k, 0});
    bvis[k] = true;
    while (!q.empty()) {
        tmp = q.front();
        q.pop();
        t = max(t, (c[tmp.idx] ? tmp.step+1 : tmp.step));  // 如果最短路终点为黑色（1），则步数+1
        for (auto i : G[tmp.idx]) {
            if (!bvis[i] && i != idx) {
                q.push({i, tmp.step+1});
                bvis[i] = true;
            }
        }
    }
    ans = min(ans, t);
}

// 求出从各点出发到所有点的最短路的最大值的最小值
void solve() {
    for (int i = 1; i < idx; i++) bfs(i);
    cout << ans << endl;
}

// 读入数据并建图
void init() {
    cin >> n >> m;
    for (int i = 1; i <= n; i++)
        for (int j = 1; j <= m; j++) cin >> a[i][j];

    G.resize(2500+1);

    for (int i = 1; i <= n; i++)
        for (int j = 1; j <= m; j++) {
            if (a[i][j]) if (dfs1(i, j)) idx++;
            if (!a[i][j]) if (dfs0(i, j)) idx++;
        }
}

int main() {
#ifdef LOCAL
    freopen("E_2.in", "r", stdin);
#endif
    IOS
    init();
    solve();

    // 遍历结点颜色
    // for (int i = 1; i < idx; i++) cout << c[i] << ' ';
    // cout << endl << endl;

    // 遍历访问数组
    // for (int i = 1; i <= n; i++) {
    //     for (int j = 1; j <= m; j++) cout << vis[i][j] << ' ';
    //     cout << endl;
    // } cout << endl;

    // 遍历邻接表
    // for (int i = 1; i < idx; i++) {
    //     cout << i << ": ";
    //     for (auto j : G[i]) cout << j << ' ';
    //     cout << endl;
    // }

    return 0;
}

```

## 优化（2026-07-27）

显然两个 DFS 可以合并成一个，下面是 Kimi-2.6 给出的代码（未验证）。

### Kimi-2.6

**思路没有复杂化，但代码实现确实可以简化。**

这道题的标准做法就是「连通块缩点 → 建图 → 求带权图的偏心距」，原题解的核心逻辑（DFS 找连通块 + BFS 求最短路）是合理且必要的。不过原代码用了两个几乎一样的 DFS、用 `vis` 正负号来区分颜色等，属于实现层面的冗余。

### 为什么思路是自然的？

1. **操作的本质是连通块级别的**：  
   每次操作会将整个同色连通块翻转，然后与相邻的异色连通块合并。因此单个格子没有独立意义，必须把连通块当作一个「超级节点」。

2. **扩散过程等价于图上的最短路**：  
   从某个连通块出发，每操作一次，当前区域就向相邻连通块扩散一层。覆盖到距离为 $d$ 的连通块恰好需要 $d$ 步。如果最后被覆盖的连通块是黑色（1），翻转后整个大图会变成黑色，需要再多操作一次才能全变 0。因此总代价为 $d + \text{color}(v)$。

3. **问题转化为**：  
   对每个起点 $s$，求 $\max_{v} \{\text{dist}(s, v) + \text{color}(v)\}$，再对所有 $s$ 取最小值。这就是原题解做的 BFS。

### 代码可以如何简化？

原题解的两个 DFS（`dfs1` / `dfs0`）可以合并为一个；`vis` 数组直接用正编号存储，颜色单独用数组记录；建图时统一遍历相邻格子即可。

下面是一个更简洁的等价实现（核心逻辑不变，代码量更少）：

```cpp
#include <bits/stdc++.h>
using namespace std;

int n, m, a[55][55], vis[55][55], col[2505], idx = 0;
vector<int> G[2505];
int dx[4] = {1, -1, 0, 0}, dy[4] = {0, 0, 1, -1};

// 一个 DFS 处理所有连通块
void dfs(int x, int y, int c) {
    vis[x][y] = idx;
    for (int i = 0; i < 4; i++) {
        int nx = x + dx[i], ny = y + dy[i];
        if (nx < 1 || nx > n || ny < 1 || ny > m) continue;
        if (a[nx][ny] != c || vis[nx][ny]) continue;
        dfs(nx, ny, c);
    }
}

int main() {
    cin >> n >> m;
    for (int i = 1; i <= n; i++)
        for (int j = 1; j <= m; j++)
            cin >> a[i][j];

    // 1. 找连通块
    for (int i = 1; i <= n; i++)
        for (int j = 1; j <= m; j++)
            if (!vis[i][j]) {
                col[++idx] = a[i][j];
                dfs(i, j, a[i][j]);
            }

    // 2. 建图（遍历相邻格子，不同连通块就连边）
    for (int i = 1; i <= n; i++)
        for (int j = 1; j <= m; j++)
            for (int k = 0; k < 4; k++) {
                int ni = i + dx[k], nj = j + dy[k];
                if (ni < 1 || ni > n || nj < 1 || nj > m) continue;
                int u = vis[i][j], v = vis[ni][nj];
                if (u != v) G[u].push_back(v);
            }

    // 3. 对每个起点 BFS
    int ans = 1e9;
    for (int s = 1; s <= idx; s++) {
        vector<int> dist(idx + 1, -1);
        queue<int> q;
        q.push(s); dist[s] = 0;
        while (!q.empty()) {
            int u = q.front(); q.pop();
            for (int v : G[u]) if (dist[v] == -1) {
                dist[v] = dist[u] + 1;
                q.push(v);
            }
        }
        int mx = 0;
        for (int i = 1; i <= idx; i++)
            mx = max(mx, dist[i] + col[i]);  // 黑块(+1)，白块(+0)
        ans = min(ans, mx);
    }
    cout << ans << endl;
}
```

**主要简化点**：

- 一个通用 DFS 代替两个颜色特化 DFS
- `vis` 只存编号，颜色由 `col` 数组显式记录
- 建图逻辑统一，不依赖 DFS 内部处理边界

### 还能不能更简单？

对于 $50 \times 50$（最多约 2500 个连通块）的数据范围，$O(V \cdot (V+E))$ 的 BFS 已经足够快，不需要更复杂的优化。

如果硬要追求理论上的「更简单」，可以利用该图是**二分图**的性质：所有白点到黑点的距离为奇数，白点到白点为偶数。因此从白点出发的答案一定是偶数，从黑点出发一定是奇数。但这只是奇偶性观察，并不能直接推出一个 $O(1)$ 或 $O(V)$ 的闭式解来替代 BFS。

**结论**：算法框架已经是最简路径之一，不必再寻找更高层的抽象；但代码实现上完全可以写得更干净。

## 附赠数据生成器

> E_in.py

```Python
from random import *
import sys

sys.stdout = open(r"E_2.in", "w")

# n = randint(1, 50)
# m = randint(1, 50)
n, m = 50, 50

print(n, m)
for _ in range(n):
    for _ in range(m):
        print(randint(0, 1), end=" ")
    print()
```

## 总结

上周末打的虚拟赛，我负责E题。虽然一上来就想到了DFS建图，然而还不熟练，错漏百出：邻接表建图出错、BFS漏写访问标记，~~以至于全程挂机（bushi）~~。还要加强训练，~~我也是加把劲ACMer~~
