---
title: Python生成多项式与牛顿法
description: Python 与数学的碰撞
summary: Python 与数学的碰撞
date: 2022-10-02
slug: poly-newton
tags:
  - 算法
  - Python
  - 数学
  - 模拟
  - ACM
categories: 月魂
---

事情的起因还得从昨天说起：

博主在刷几道简单的算法题，其中有一道是[多项式输出](https://ac.nowcoder.com/acm/problem/16622)，看似简单决定首先AC，无奈博主 C 语言能力不足，转战Python。
~~结果还是眼高手低，这么简单的程序要这么多判断~~

![简单的题目](poly-newton-problem.jpg)

## 生成多项式

参考了原题，但是输入输出的格式稍有不同

> get_polynomial_feature.py

```Python
def get_polynomial(*n):
    """生成多项式。第一个形参为次数，其他形参为系数"""
    power, coefficients = n[0], {}
    for i in range(power+1):
        coefficients['a' + str(i+1)] = n[i+1]  # 存储系数的字典

    counter = 0
    polynomial = ""
    while counter <= power:
        poly = coefficients[f'a{counter+1}']
        if abs(poly) != 1:  # 判断系数绝对值是否为1
            if counter != 0:  # 判断是否为最高次项
                if power-counter != 1:  # 判断是否为一次项
                    if counter != power:  # 判断是否为常数项
                        if poly > 0:
                            polynomial += f"+{poly}*x**{power-counter}"
                        elif poly < 0:
                            polynomial += f"{poly}*x**{power-counter}"
                        else:
                            pass
                    else:
                        if poly > 0:
                            polynomial += '+' + str(poly)
                        elif poly < 0:
                            polynomial += '-' + str(poly)
                        else:
                            pass
                else:
                    if poly > 0:
                        polynomial +=  "+" + str(poly) + "*x"
                    elif poly < 0:
                        polynomial +=  "-" + str(poly) + "*x"
                    else:
                        pass
            else:
                if poly > 0:
                    polynomial += f"{poly}*x**{power-counter}"
                elif poly < 0:
                    polynomial += f"{poly}*x**{power-counter}"
                else:
                    pass
        else:
            if counter != 0:
                if power-counter != 1:
                    if counter != power:
                        if poly > 0:
                            polynomial += f"+x**{power-counter}"
                        else:
                            polynomial += f"-x**{power-counter}"
                    else:
                        if poly > 0:
                            polynomial += '+1'
                        else:
                            polynomial += '-1'
                else:
                    if poly > 0:
                        polynomial += "+x"
                    else:
                        polynomial += "-x"
            else:
                if poly > 0:
                    polynomial += f"x**{power-counter}"
                elif poly < 0:
                    polynomial += f"-x**{power-counter}"
                else:
                    pass
        counter += 1
    return polynomial


if __name__ == '__main__':
    print(get_polynomial(3, 5, -1, 0, 11))
```

关于上面代码的吐槽：

- ~~高情商：为锻炼编程能力，坚决不使用第三方库；~~
- ~~低情商：瞎堆砌代码，头铁重新发明轮子~~

## 牛顿法求多项式近似根

最近在复习普林斯顿，正好来试试牛顿法

### 理论基础

#### 牛顿法

假设a是对方程 $f(x) = 0$ 的解的一个近似.
如果令 $b = a - f(a) / f'(a)$，
则在很多情况下，$b$ 是个比 $a$ 更好的近似.

~~暂时不考虑牛顿法失效的情况（详见《普林斯顿微积分读本》P260~262）~~

### 代码

> newtons_method.py

```Python
from sympy import *

from get_polynomial_feature import *

x = symbols('x')  # x为符号变量
x0 = -0.5  # 初值
x_list = [x0]
i = 0  # 计数器
polynomial_feature = get_polynomial(3, 5, -1, 0, 11)  # 待求解多项式


def f(x):
    f = eval(polynomial_feature)
    return f


while True:
    if diff(f(x), x).subs(x, x0) == 0:  # subs()将变量x替换为x0;若f'(x0)=0
        print("极值点：", x0)
        break
    else:
        x0 = x0 - f(x0) / diff(f(x), x).subs(x, x0)  # 牛顿法
        x_list.append(x0)
    if len(x_list) > 1:
        i += 1
        error = abs((x_list[-1] - x_list[-2]) / x_list[-1])  # 计算误差
        if error < 10 ** (-6):
            print(f"迭代第 {i} 次后，误差小于 10^(-6)，误差为 {error}")
            break
    else:
        pass
print(f"{polynomial_feature} 的根为 {x_list[-1]}")

```

> 运行结果示例

```json
迭代第 7 次后，误差小于 10^(-6)，误差为 4.12656549474007E-8
5*x**3-x**2+11 的根为 -1.23722554155332

***Repl Closed***

```

## 总结

当 Python 遇上数学，还挺有意思的

有机会博主要学一下`SymPy`和`Numpy`库

## 源代码仓库

感兴趣的话可以[star](https://github.com/AllenWu233/newtons_method)一下（真的会有人star这么无聊的代码吗）

<a href="https://github.com/AllenWu233/newtons_method"><img src="https://github-link-card.s3.ap-northeast-1.amazonaws.com/AllenWu233/newtons_method.png" width="460px"></a>

![cirno](poly-newton-cover.jpg)

## 参考文献

[1]（美）阿德里安·班纳.普林斯顿微积分读本[M].北京：人民邮电出版社2016.

[2] [牛顿迭代法（Newton’s Method）迭代求根的Python程序](https://blog.csdn.net/weixin_48615832/article/details/109285701)
