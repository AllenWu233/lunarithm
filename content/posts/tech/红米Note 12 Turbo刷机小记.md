---
title: "红米Note 12 Turbo刷机小记"
slug: redmi-note-12-trubo-flash
description: "生命在于折腾。"
date: 2024-03-26T20:32:38+08:00
lastmod: 2025-12-07T10:52:00+08:00
tags: ["刷机", "Android", "root", "Magisk", "LineageOS", "类原生", "手机"]
series: "教程"
categories: "月魂"
---

![](lineageos-download-rom-nougat.jpg)

## 引言

无法忍受日渐卡顿和GPS定位出问题的`Honor Play`，我换上了`Redmi Note 12 Turbo`，而前者也终于结束了它将近五年的服役

正是看中了 **易刷机** 和 **性价比高** 的特点，我才选了这款手机。于是，搁置多年的玩（折）机（腾）之旅又将继续（

自然得玩玩类原生系统了。我选择刷入[LineageOS](https://lineageos.org/)，已经有大佬上传了非官方的ROM，非常方便

## 刷机

### 解锁Bootloader

可以看看这篇教程[^1]

#### 绑定小米账号

一般新机需要绑定小米账号并插入SIM卡 **168小时（一周）** 后才能解锁Bootloader。绑定步骤如下：

- 一、开启 开发者选项：1.我的设备 – 2.全部参数 – 3.连击MIUI版本
- 二、1.更多设置 – 2.开发者选项 – 3.设备解锁状态 – 4.绑定账号和设备（需要插入SIM卡）
  等待一周后进入下一步

#### 解锁BL

这一步最好是在Windows系统下完成，虚拟机或wine可能会出现问题

去[小米官网](https://www.miui.com/unlock/download.html)下载解锁软件，
解压后运行 **MiUsbDriver.exe** ，登录后连接手机，按提示进入`Fastboot`模式（关机状态下按`电源键`+`音量下键`）操作即可

### 刷入LineageOS

建议优先参考ROM提供者的教程[^2]

#### 下载

下载[此页面](https://miracle.girlswithout.top/adrian/lineage-21/marble/)中除`lineage-21.0-20240306-UNOFFICIAL-marble.zip.sha256sum`外的所有文件，即：

> - \*-marble-boot.img
> - \*-marble-dtbo.img
> - \*-marble-recover.img
> - \*-marble-vendor_boot.img
> - \*-marble.zip

#### 刷入

需要有基本的[fastboot](https://en.wikipedia.org/wiki/Fastboot)和[adb](https://en.wikipedia.org/wiki/Android_Debug_Bridge)相关知识

在Arch Linux下安装fastboot和adb：

```bash
paru -S android-tools
```

将手机连接到PC，手机进入fastboot模式，然后依次刷入下面四个img：

```bash
fastboot flash boot <boot>.img
fastboot flash dtbo <dtbo>.img
fastboot flash vendor_boot <vendor_boot>.img
fastboot flash recovery <recovery_filename>.img
```

这里的`<boot>.img`代表你所下载的 `*-marble-boot.img`，其他几个同理

重启到`recovery`模式。可以用命令：

```bash
fastboot reboot recovery
```

也可以关机状态按`电源键`+`音量上键`进入

在recovery界面按：
**Factory Reset** - **Format data / factory reset** 以格式化

返回主菜单，按 **Apply Update** - **Apply from ADB**

在PC上运行命令以刷入`LineageOS`：

```bash
adb sideload <filename>.zip
```

根据ROM提供者的提示，PC终端上显示安装进度可能会卡在47%，然而手机提示已完成安装，是否需要安装额外的包。不用担心，其实系统已经成功安装了，此时点 **No**，然后重启到正常的系统即可

> **Tip**: Normally, adb will report Total xfer: 1.00x, but in some cases,
> even if the process succeeds the output will stop at 47% and report adb:
> failed to read command: Success. In some cases it will report adb:
> failed to read command: No error or adb: failed to read command:
> Undefined error: 0 which is also fine.

以后更新系统直接在recovery刷入ROM即可

> ⚠️ **第一次进系统时建议先不要插入SIM卡，以免出现奇奇怪怪的问题**

## Root

折腾手机自然少不了Root啦。我使用的是安装过程简便的[Magisk](https://github.com/topjohnwu/Magisk)

### 安装Magisk

推荐阅读[^3]

先在手机上安装[Magisk app](https://github.com/topjohnwu/Magisk/releases)，
然后将前面下载的`<boot>.img`拷到手机上，打开Magisk， **安装** - **选择并修补一个文件**，
选中刚刚拷的文件，修补后拷回电脑

手机上允许adb调试。重启到fastboot模式并刷入修补后的镜像：

```bash
adb reboot fastboot
fastboot flash boot <magisk_patch-filename>.img
```

重启，尽享root后的世界吧！

更新系统后Magisk会失效，可以重新执行此步骤修补镜像并刷入

### 安装Magisk modules

先在Magisk的设置里开启**Zygisk**

推荐几个好用的模块：

| Module Name                                                          | Description                                                                                                                                                            |
| -------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [AdGuardHome](https://github.com/AdguardTeam/AdGuardHome)            | 屏蔽大多数应用的广告，强烈安利                                                                                                                                         |
| [Sui](https://github.com/topjohnwu/Magisk/releases)                  | 使Magisk管理应用的逻辑更现代化，依赖Zygisk                                                                                                                             |
| [Shamiko](https://github.com/LSPosed/LSPosed.github.io/releases)[^4] | 向应用隐藏Root，强烈安利                                                                                                                                               |
| [LSPosed](https://github.com/LSPosed/LSPosed/releases)               | 类似Xposed框架，可安装许多插件                                                                                                                                         |
| [uperf](https://github.com/yc9559/uperf)                             | 用户态性能控制器，实现大部分内核态升频功能。可配合子模块[SfAnalysis](https://github.com/yc9559/uperf/releases)和[SsAnalysis](https://github.com/yc9559/uperf/releases) |
| [FingerprintPay](https://github.com/eritpchy/FingerprintPay)         | 让微信、QQ、支付宝、淘宝、云闪付支持使用指纹支付                                                                                                                       |

安装方式：**模块** - **从本地安装**
安装成功后重启即可

### Shamiko 白名单模式

创建空文件 `/data/adb/shamiko/whitelist` ，重启即可。需使用能获取 Root 权限来修改根目录的文件管理器（如质感文件、MT 管理器等）

> 白名单比黑名单有什么优势？[^5]

- 全局隐藏，更彻底，也不用设置排除列表
- 所有 app 都检测不到 root，已授权 root 的 app 可以正常使用 root 权限。
- 需要授权 root，关闭 Shamiko 模块重启手机，授权完再启用 shamiko 模块重启手机即可。

## Apps推荐

| App Name                                                       | Description                                                       |
| -------------------------------------------------------------- | ----------------------------------------------------------------- |
| [F-Droid](https://f-droid.org)                                 | 自由开源软件下载                                                  |
| [Aurora Store](https://f-droid.org/packages/com.aurora.store/) | Google Play的非官方自由/开源软件客户端                            |
| [冰箱 Ice Box](https://iceboxdoc.catchingnow.com/)             | 把暂时不用或者不需常驻后台的应用“冻结”起来                        |
| [Scene](https://github.com/helloklf/vtools)                    | 一个集高级重启、应用安装自动点击、CPU调频等多项功能于一体的工具箱 |

## 已知问题

### 重启后无法接收短信

可能是LineageOS的问题。根据[用户**aqwgtj**的回复](https://xdaforums.com/t/rom-14-unofficial-lineageos-21-for-xiaomi-poco-f5-redmi-note-12-turbo.4655286/page-4#post-89404995)，在设置里面禁用再启用SIM卡就能正常接收短信了：
**设置** - **网络和互联网** - **SIM卡** - <选择SIM卡> - 重新开关**使用SIM卡**

> aqwgtj: make sure to SMS normal must be to disable your SIM and re-enable it
> after restarting machine eachtime, either no SMS can see.

目前还没有找到根治的办法，只好每次重启都重开一次😕

> 2024-04-02 更新

ROM提供者已提供更新，优化UI的同时还修复了SMS的问题，添加老化保护（burn-in protection），并重新加入充电控制功能

[https://xdaforums.com/t/rom-14-unofficial-lineageos-21-for-xiaomi-poco-f5-redmi-note-12-turbo.4655286/post-89434291](https://xdaforums.com/t/rom-14-unofficial-lineageos-21-for-xiaomi-poco-f5-redmi-note-12-turbo.4655286/post-89434291)

## 2024.04.02 更新

更新系统。直接通过adb线刷完整系统包即可，但是Magisk的修复就要注意了。起初我不假思索的刷入之前magisk修复的包，结果直接进不了系统……

### 正确姿势

使用[payload-dumper-go](https://github.com/ssut/payload-dumper-go)提取新版本系统包的`boot.img`，再在`Magisk`里修补镜像，重新刷入修补后的镜像

安装`payload-dumper-go-bin`

```bash
paru -S payload-dumper-go-bin
```

解压系统包，要用到的是`payload.bin`

```bash
unzip <system_package>.zip payload.bin
```

提取`boot.img`

```bash
payload-dumper-go -p boot payload.bin
```

通过fastboot刷入经`Magisk`修补后的镜像即可

```bash
fastboot flash boot boot.img
```

### 关于Zygisk

重刷后关闭所有zygisk模块，重启，然后再启用zygisk模块，再重启

## 养老：2025.12.05 更新

刷回了 HyperOS 2。类原生爽是爽，但缺点也不少：耗电快、国产应用不兼容、MicroG 不能完美替代 Google 服务等。好在解了 BL，顺手就能 Root，体验差强人意。

或许是最后一台折腾的手机了，自从小米解 BL 难度大大提高后，又少了一个适合玩机的品牌。

第二天又刷了 [YiHan 的 MIUI 14.0.27 官改包](https://h5.cloud.189.cn/share.html#/t/6fiEFjR7NVra)，决定在这个包[养老](https://www.bilibili.com/video/BV1NK8UzBEZk?t=0)了。

## 附录

[^1]: [小米手机解锁Bootloader（Xiaomi手机解BL锁）](https://magiskcn.com/xiaomi-unlock)

[^2]: [\[ROM\]\[14\]\[UNOFFICIAL\] LineageOS 21 for Xiaomi POCO F5 / Redmi Note 12 Turbo](https://xdaforums.com/t/rom-14-unofficial-lineageos-21-for-xiaomi-poco-f5-redmi-note-12-turbo.4655286/)

[^3]: [Magisk安装教程](https://magiskcn.com/?utm_source=pocket_saves)

[^4]: [Shamiko安装（Shamiko install）](https://magiskcn.com/shamiko-install)

[^5] [Shamiko 白名单模式](https://magiskcn.com/shamiko-whitelist.html)
