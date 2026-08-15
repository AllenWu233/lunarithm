+++
title = "给i3wm装颗“心脏”——一个Rofi菜单的三生三世"
slug = "rofi-heart"
description = "Arch Linux + i3wm 下的 Rofi 脚本选择器"
date = "2026-08-06T22:55:44+08:00"
lastmod = "2026-08-12T19:50:00+08:00"
tags = ["Arch Linux", "Rofi", "Shell", "Python", "Bash", "dmenu", "i3wm"]
series = "教程"
categories = "月魂"
+++

## 引言

### 什么是 WM

作为一名 [K.I.S.S 主义](https://en.wikipedia.org/wiki/KISS_principle) 的 Arch Linuxer，桌面环境也是我极（折）简（腾）的一部分——由 [DE (Desktop Environment)](https://wiki.archlinux.org/title/Desktop_environment) 走向 [WM (Window Manager)](https://wiki.archlinux.org/title/Window_manager) 是自然的~~归宿~~结果。

不同于捆绑了工具栏、桌面小部件等一系列应用的 DE (桌面环境)，**WM (窗口管理器)** 只提供基础的窗口绘制功能，管理窗口的大小、位置、边框等。一些 WM 是 DE 的一部分，如 Windows 的 [dwm](https://learn.microsoft.com/en-us/windows/win32/dwm/dwm-overview)（不要与 Linux 上的 [dwm](https://wiki.archlinux.org/title/Dwm) 混淆）、KDE 的 [KWin](https://en.wikipedia.org/wiki/KWin)、Gnome 的 [Mutter](<https://en.wikipedia.org/wiki/Mutter_(window_manager)>) 等；而另一些 WM 被设计为独立使用，用户可根据喜好选择其他应用（如状态栏、壁纸管理器），组合成更轻量的专属桌面环境。

WM 的窗口管理类型是其特色：

- **堆叠（悬浮）**：就像 KDE、Windows 下的窗口管理，用鼠标调整窗口大小、拖拽位置，不同窗口能像桌上的纸张一样部分重叠放置。
- **平铺**：窗口之间不重叠，大小、位置能被自动或手动调整，以占满整个屏幕——例如，只有一个窗口时，几乎全屏；有两个窗口时，左右各一半铺满屏幕。另外广泛地使用键绑定，可以完全不用鼠标来管理和定位窗口（Vimer 狂喜）。
- **动态**：可在堆叠和平铺之间切换。

我用的是 [i3wm](https://i3wm.org)——默认平铺，但也支持一键切换为悬浮或标签页模式；轻量、配置清晰、功能丰富而恰到好处。相关配置可查阅 [AllenWu233/dotfiles](https://github.com/AllenWu233/dotfiles)。如下图所示：

![i3wm Example](rofi-heart-fastfetch.png)

### 为什么 i3wm 要装颗“心脏”

i3wm 虽好，但毕竟只是 WM，~~想要桌面环境般的体验，还得自己拼~~。程序启动器就是一个：在 Windows、KDE 和 Gnome 等 DE 下启动应用程序，一般通过桌面快捷方式或按 Win (Meta) 键弹出的启动菜单。而 i3 没有桌面快捷方式——从上图能看出我的桌面只有一张壁纸（笑），也没有内置启动菜单，于是只能用专用的应用启动器——[dmenu](https://wiki.archlinux.org/title/Dmenu) 或是类 dmenu 软件，通过快捷键唤出应用菜单，输入应用名或移动光标选项来启动。如下图：

![Rofi Application Launcher Menu](rofi-heart-apps.jpg)

这类软件不仅能用作应用启动器，还能作为脚本选择器：将脚本菜单文本作为管道输入，显示为 dmenu-like 菜单来让用户选择。我用的是 [Rofi](https://wiki.archlinux.org/title/Rofi)，除了基础的文本过滤选择，还支持绑定键位到选项上，一键选择，省去输入脚本名和按回车。

i3 我也用了三年了，积累了一些 dmenu-like 脚本，如管理 dotfiles、管理多显示器、电源菜单、剪贴板菜单、Emoji 选择器等等。每个脚本都绑定一个 i3 快捷键，既麻烦又浪费键位。如果用一个 Rofi 菜单统一管理这些脚本，不就只用一个键位就能打开指定脚本了？于是就有了 **rofi-heart**。

## rofi-heart 的三生三世

rofi-heart 的设计很简单：呈现一个菜单，通过快捷键或输入文本来选择选项，再执行相应命令或脚本。

### 第一世：混沌初开

先从 Rofi 的基本语法开始：

```Shell
echo "[a] Item 1\n[b] Item 2" | rofi -dmenu -i -p "Selection" -kb-custom-1 "a" -kb-custom-2 "b"
```

管道符左边是菜单文本。来看右边的 Rofi 主命令：

- `-dmenu`: 启用 dmenu 模式。
- `-i`: 输入文本搜索时大小写不敏感。
- `-p [string]`: Prompt，即输入框左侧的提示符。
- `-kb-custom-x [string]`: 绑定按键到选项上，x 为 1-19。

> [!NOTE] 选择选项后，Rofi 会打印**光标处**的文本，并返回进程的返回值。
> 如果通过搜索文本或移动光标，按回车来选择，返回的文本是期望的结果，且返回值为 0；
> 如果直接用快捷键选择，返回的文本是光标处的结果（往往不是想要的结果），此时应以返回值（10-28，如 `-kb-custom-1` 对应返回值 10）为准

> 完整的 rofi-heart-1.0 如下：

```bash
#!/usr/bin/env bash
# Rofi launcher with quick shortcut bindings

BIN="$HOME/.local/bin"

CLIPBOARD="clipcat-menu"
DOTFILES="$BIN/dmenu-dotfiles"
EMOJI="rofi -show emoji"
WIKI="$BIN/dmenu-arch-wiki"
MONITOR="$BIN/dmenu-monitor"
POWER="$BIN/dmenu-power"

# Define menu items
items="[c] Clipboard
[d] Dotfiles
[e] Emoji
[w] Arch Wiki (en)
[z] Arch Wiki (zh-CN)
[m] Monitor
[p] Power"

# Prompt user selection
choice=$(
    printf "%s" "$items" | rofi -dmenu -i -p "󰣐 Heart" \
        -kb-custom-1 "c" \
        -kb-custom-2 "d" \
        -kb-custom-3 "e" \
        -kb-custom-4 "w" \
        -kb-custom-5 "z" \
        -kb-custom-6 "m" \
        -kb-custom-7 "p"
)
code=$?

# Match key code or menu selection
case "$code:$choice" in
10:* | 0:*"[c]"*) exec $CLIPBOARD ;;
11:* | 0:*"[d]"*) exec $DOTFILES ;;
12:* | 0:*"[e]"*) exec $EMOJI ;;
13:* | 0:*"[w]"*) exec $WIKI ;;
14:* | 0:*"[z]"*) exec $WIKI zh ;;
15:* | 0:*"[m]"*) exec $MONITOR ;;
16:* | 0:*"[p]"*) exec $POWER ;;
*) exit 0 ;;
esac
```

其中 `case` 中的 `10:* | 0:*"[c]"*) exec $CLIPBOARD ;;` 就实现了兼容搜索/光标选择和按键选择。

效果图如下：

![rofi-heart Main Menu](rofi-heart-main.jpg)

![rofi-heart Emoji Menu](rofi-heart-emoji.jpg)

代码清晰易懂，像在 Shell 里输命令一样直白。但维护起来就很难受：修改一个脚本，就要同时改`items`、`choice`、`case` 三处，效率低下且易出错。

像电源菜单这样写好了就基本不改的脚本，这个版本很合适。但 rofi-heart 要频繁维护子脚本项，显然不太行。

### 第二世：束薪为栅

1.0 的 Shell 维护起来这么麻烦，有没有办法把所有相关配置放在开头呢？
有的，朋友，有的——用 Bash 数组，以字符串存储的自定义的数据结构，再通过 **IFS (Internal Field Separator，内部字段分隔符)** 处理分隔符来解析变量。

> 自定义数据结构：

```Bash
# Menu items with format: key|label|command
MENU_ITEMS=(
    "c|Clipboard|clipcat-menu"
    "d|Dotfiles|$BIN/dmenu-dotfiles"
)
```

> 从自定义数据结构解析变量

```Bash
for i in "${!MENU_ITEMS[@]}"; do
    # Extract `key` and `label`
    # Set inline temporary environment variable (IFS) for this command only
    IFS='|' read -r key label _ <<<"${MENU_ITEMS[i]}"
    # Use `key` and `label` here...
done

# Extract `command` by stripping prefix
cmd="${entry#*|*|}"
```

此处配合 `<<<`（Here-String）把数组元素传给 `read`，避免了管道符创建子 Shell 导致的变量作用域失效。

可以看出 `read` 的多变量赋值用法，跟 Python 的解包、Rust 的模式匹配有异曲同工之妙（假设下面 MENU_ITEMS 里存的是元组 `(key, label, command)`）：

```Python
key, label, _ = MENU_ITEMS[i]
```

```Rust
let (key, label, _) = MENU_ITEMS[i];
```

> 完整的 rofi-heart-2.0

> [!NOTE] 此段代码只是为了展示“演进完整性”。如果你不熟悉 Shell 高级语法，完全可以直接跳过，不影响最终理解。

```Bash
#!/usr/bin/env bash
# @title: rofi-heart
# @desc: Control heart for custom rofi actions and tools

set -euo pipefail

BIN="${HOME}/.local/bin"

# Menu items with format: key|label|command
MENU_ITEMS=(
    "c|Clipboard|clipcat-menu"
    "d|Dotfiles|$BIN/dmenu-dotfiles"
    "e|Emoji|rofi -show emoji"
    "w|Arch Wiki (en)|$BIN/dmenu-arch-wiki"
    "z|Arch Wiki (zh-CN)|$BIN/dmenu-arch-wiki zh"
    "m|Monitor|$BIN/dmenu-monitor"
    "p|Power|$BIN/dmenu-power"
)

items=""
rofi_cmd=(rofi -dmenu -i -p "󰣐 Heart")

# Build rofi menu text and keybindings
for i in "${!MENU_ITEMS[@]}"; do
    IFS='|' read -r key label _ <<<"${MENU_ITEMS[i]}"
    items+="[$key] $label"$'\n'
    rofi_cmd+=("-kb-custom-$((i + 1))" "$key")
done

# Launch rofi and capture return code
code=0
choice=$(printf "%s" "$items" | "${rofi_cmd[@]}") || code=$?

# Run target command safely
run_cmd() {
    local entry="$1"
    local cmd="${entry#*|*|}"
    exec bash -c "$cmd"
}

# Resolve custom hotkey selection
if ((code >= 10 && code < 10 + ${#MENU_ITEMS[@]})); then
    run_cmd "${MENU_ITEMS[code - 10]}"
# Resolve default Enter key selection
elif ((code == 0)) && [[ -n "$choice" ]]; then
    for item in "${MENU_ITEMS[@]}"; do
        IFS='|' read -r key _ <<<"$item"
        if [[ "$choice" == "[$key]"* ]]; then
            run_cmd "$item"
        fi
    done
fi
```

如果你有勇气读到这里，不妨来看看其中几个最有代表性的“黑魔法”：

1. **`${entry#*|*|}` (Parameter Expansion 模式匹配)**  
   利用 Bash 内置的参数展开删除前缀，非贪婪模式匹配到第二个 `|` 并将其连同左侧文本全部剔除，从而高效提取出末尾的 command。
2. **`rofi_cmd=(...)` 与 `"${rofi_cmd[@]}"` (动态命令数组)**  
   在 Shell 里动态构建带复杂参数的命令时，抛弃了危险的 `eval` 或易出错的字符串转义，而是将整个 Rofi 命令作为数组构建并展开执行，保证每个参数界限的安全。
3. **`${!MENU_ITEMS[@]}` (原生数组索引提取)**  
   不依赖外部的 `seq` 或 `expr` 命令，也不用 C 语言风格的 `for ((i=0;...))`，直接使用 `${!array[@]}` 提取数组的键名/索引进行循环，干脆利落。
4. **`[[ "$choice" == "[$key]"* ]]` (双方括号 Glob 前缀匹配)**  
   判断输入文本前缀时，不调用 `grep`、`sed` 或正则，直接利用 Bash `[[ ]]` 的原生 Glob 通配符匹配，完全在内存进程内部完成比对，零 Fork 性能开销。
5. **`choice=$(...) || code=$?` (巧解 `set -e` 机制)**  
   脚本开头开启了严格模式 `set -e`（遇到非 0 返回值立即退出）。但 Rofi 按快捷键选择时会故意返回 10~28 的非零退出码。用 `|| code=$?` 处理管道短路，一行代码兼顾了严格错误捕获与自定义状态码处理。

### 第三世：庖丁解牛

虽然 2.0 解决了维护不便的问题，但是引入了许多“黑魔法”——地道、优雅且高级的现代 Bash 技巧。
~~对于并不精通 Bash 的我，脚本写完后今天还能看懂，几周后只有上帝和 AI 能看懂了 XD。~~

换言之，语法过于高级和精简、逻辑复杂的代码，维护起来是地狱级难度——
比如哪天想换成 Fuzzel 或 Wofi 作为 dmenu 后端，就要先把之前的代码都捋一遍。即使是精通 Shell 的高手，也得皱着眉头看半天吧。

正处踌躇之际，我突然想起我的白月光——Python！复杂脚本就应该交给脚本语言！

没有什么比抽象成类更合适的了。Python 中开启了 `slots=True, frozen=True` 的 `dataclass`，
简直就是 Rust 界的 `#[derive(Debug, PartialEq)] struct`，既消除了样板代码，又保证了只读与紧凑的内存布局：

```Python
# Immutable, memory-optimized data container for menu items.
@dataclass(slots=True, frozen=True)
class Item:
    key: str
    label: str
    cmd: str


MENU_ITEMS = [
    Item("c", "Clipboard", "clipcat-menu"),
    Item("d", "Dotfiles", f"{BIN}/dmenu-dotfiles"),
    ...
]
```

而且对于参数的字符串拼接更是降维打击：

```Python
items_text = "\n".join(f"[{item.key}] {item.label}" for item in menu_items)
```

各种逻辑判断的简化更不用多说，请看下文：

> rofi-heart-3.0

```Python
#!/usr/bin/env python3
"""
@title: rofi-heart
@desc: Control heart for custom rofi actions and tools
@usage: rofi-heart
@deps: rofi, clipcat, dmenu-arch-wiki, autorandr
@date: 2026
@auth: Allen
@insp: [Unixchad's heart script](https://github.com/gnuunixchad/dotfiles/blob/master/.local/bin/heart)
"""

from dataclasses import dataclass
from pathlib import Path
import subprocess
import os


@dataclass(slots=True, frozen=True)
class Item:
    key: str
    label: str
    cmd: str


HOME = Path.home()
BIN = HOME / ".local" / "bin"

MENU_ITEMS = [
    Item("c", "Clipboard", "clipcat-menu"),
    Item("d", "Dotfiles", f"{BIN}/dmenu-dotfiles"),
    Item("e", "Emoji", "rofi -show emoji"),
    Item("w", "Arch Wiki (en)", f"{BIN}/dmenu-arch-wiki"),
    Item("z", "Arch Wiki (zh-CN)", f"{BIN}/dmenu-arch-wiki zh"),
    Item("m", "Monitor", f"{BIN}/dmenu-monitor"),
    Item("p", "Power", f"{BIN}/dmenu-power"),
]


def get_selected_item(menu_items: list[Item]) -> Item | None:
    """Launch rofi menu and return the selected `Item` object."""
    items_text = "\n".join(f"[{item.key}] {item.label}" for item in menu_items)

    rofi_cmd = ["rofi", "-dmenu", "-i", "-p", "󰣐 Heart"]
    for i, item in enumerate(menu_items, start=1):
        rofi_cmd.extend([f"-kb-custom-{i}", item.key])

    # Launch rofi and capture execution result
    res = subprocess.run(rofi_cmd, input=items_text, text=True, capture_output=True)
    code = res.returncode
    choice = res.stdout.strip()

    # Resolve selection by hotkey exit code (10, 11, 12...)
    if 10 <= code < 10 + len(menu_items):
        return menu_items[code - 10]

    # Resolve selection by Enter/Mouse choice (exit code 0)
    if code == 0 and choice:
        for item in menu_items:
            if choice.startswith(f"[{item.key}]"):
                return item

    return None


def main():
    if target := get_selected_item(MENU_ITEMS):
        # Replace Python process with Bash to execute the target command (POSIX execve)
        os.execlp("bash", "bash", "-c", target.cmd)


if __name__ == "__main__":
    main()
```

其中 `os.execlp("bash", "bash", "-c", target.cmd)` 用 `exec` 而不是 `subprocess.run`，
区别在于**进程替换**与**进程创建**：

- 前者（`os.execlp`）会用新的程序映像直接替换当前 Python 进程，PID 保持不变，原进程的内存空间被新程序接管。系统里始终只有一个进程在跑，不会额外留下一个 Python 进程空等。
- 后者（`subprocess.run`）会 fork 出一个全新的子进程，父进程（Python）要么阻塞等待，要么继续驻留内存。对于 `rofi-heart` 这种“启动即退场”的 launcher 而言，父进程在子命令执行完毕后没有活能干了，留着它只会白白占用一份进程资源。

因此，用 `exec` 直接“让位”给目标命令，既省去了进程间等待和通信的开销，也使资源占用降到了与纯 Shell 脚本相当的水平。

其实在 Shell 脚本中，对于最后一行外部命令，如果无需处理返回的结果，用 `exec` 命令也是同理的——第二世中 `run_cmd()` 函数的实现就用到了。

## 结语

从第一世的硬编码 Shell 分支，到第二世充满现代 Bash 黑魔法的数组解析，再到第三世用 Python `dataclass` 构建的面向对象小工具，`rofi-heart` 走完了它的三生三世。看似是在为了几十行代码反复折腾，但折腾的终点从来不是堆砌语法糖或炫技，而是找到**运行效率**与**维护难度**之间的平衡。

现在，我只需在 i3wm 里给 `rofi-heart` 绑定一个快捷键，就能通过这颗“心脏”瞬间唤醒所有的日常工作流，简单且优雅。

```conf
bindsym $mod+o exec ~/.local/bin/rofi-heart
```

如果你也在用 WM，且苦于庞杂的快捷键配置与记忆，不妨也尝试写一个属于你自己的 `heart`，体验对操作系统触手可及的爽快感。

## 参考文献

1. [桌面环境 - Arch Linux 中文维基](https://wiki.archlinuxcn.org/wiki/桌面环境)
2. [窗口管理器 - Arch Linux 中文维基](https://wiki.archlinuxcn.org/wiki/窗口管理器)
3. [Rofi - Arch Wiki](https://wiki.archlinux.org/title/Rofi)
4. [heart - gnuunixchad/dotfiles](https://github.com/gnuunixchad/dotfiles/blob/master/.local/bin/heart)

![python-chan](python-chan.jpg)
