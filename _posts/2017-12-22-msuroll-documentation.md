---
layout:         post
title:          MSUroll 抢课神器指南
subtitle:       A desktop Software ( Mac/Windows ) for enrolling MSU classes.
date:           2017-12-22
author:         bythew3i
img-path:       /img/2017-12-22-msuroll-documentation/
header-img:     img/2017-12-22-msuroll-documentation/msu.jpeg
header-mask:    0.4
catalog:        true
tags:
    - Python
    - App
    - MSU
    - 中文
---

> 此文内容仅适用于 MSU (Michigan State University) 学生。


## 入坑须知
`起源`：本人为 MSU 大四 CSE 学生。由于大一时抢不到专业课，便立志有朝一日必写一个“抢课程序”。加之毕业在即，本人利用平常空闲时间开发了MSUroll，希望可以为抢课烦恼的同学们带来帮助。

`简介`：MSUroll有以下两点主要功能
- *秒 enroll*（如果该课有位置，可以在 3 秒内完成 enroll）
- *秒抢课* （如果该课已满，能在第一时间检测到有人drop，并自动完成 enroll）

`注意`：MSUroll **不是黑客攻击程序**，所以不存在违反校规校纪的情况。全程操作属于 **合法合规** 地选课。

`源代码`: [Github](https://github.com/by-the-w3i/MSU_ROLL) , [Documents](https://by-the-w3i.github.io/MSU_ROLL/)

## MAC 安装
#### Step 0: 检查 Mac 版本
Mac 系统版本 必须 >= `10.13.1` `macOS High Sierra`， 否则 MSUroll 将无法运行

#### Step 1: 下载 MSUroll APP
下载 `MSUroll_disk.dmg`：[https://github.com/by-the-w3i/MSU_ROLL/releases](https://github.com/by-the-w3i/MSU_ROLL/releases)


#### Step 2: 下载安装 chromedriver

>下载最新版 [chromedriver](https://sites.google.com/a/chromium.org/chromedriver/)（for mac）

解压并移动到 *电脑桌面*

![chromedriver]({{page.img-path}}mac_download/screenshots/chromedriver.png)


#### Step 3: 安装 MSUroll

打开 `MSUroll_disk.dmg`

![open dmg file]({{page.img-path}}mac_download/screenshots/open_dmg.png)

`spotlight` 搜索 `terminal` 并回车

![spotlight search]({{page.img-path}}mac_download/screenshots/spotlight.png)

在 `terminal` 里粘贴以下代码并回车

```bash
sh /Volumes/MSU_ROLL/mac_chromedriver_install.sh
```
![sudo password]({{page.img-path}}mac_download/screenshots/pass.png)

在 `terminal` 输入以下代码， 检查 `chromedriver`  插件是否成功安装

```bash
ls /usr/local/bin/ | grep chrom
```
![check install]({{page.img-path}}mac_download/screenshots/check.png)

将 MSUroll 拽入 *应用程序文件夹* (`Applications`)

![drag]({{page.img-path}}mac_download/screenshots/drag_app.png)

打开程序

![open app]({{page.img-path}}mac_download/screenshots/open.png)

如果碰到以下问题：

![warning]({{page.img-path}}mac_download/screenshots/warning.png)

解决方案：

```
System Preferences >> Security & Privacy >> open MSUroll anyway
```

![step 1]({{page.img-path}}mac_download/screenshots/step1.png)

成功打开 APP

![success]({{page.img-path}}mac_download/screenshots/success.png)

#### Step 4：传送至[使用说明](#intro)

## Windows 安装
#### Step 1: 下载 MSUroll APP
下载 `MSUroll_win.zip` : [https://github.com/by-the-w3i/MSU_ROLL/releases](https://github.com/by-the-w3i/MSU_ROLL/releases)

#### Step 2: 安装 MSUroll
解压 `MSUroll_win.zip` 得到 `MSUroll_win` 文件夹

![decompress]({{page.img-path}}win_download/screenshots/decompress.png)

打开 `MSUroll_win` 文件夹，拷贝 `MSUroll` 文件夹

![copy]({{page.img-path}}win_download/screenshots/copy.png)

将 `MSUroll` 文件夹粘贴至 `C盘` *（必须是 **C盘** exactly）*

![paste]({{page.img-path}}win_download/screenshots/paste.png)


#### Step 3: 下载安装 chromedriver

> 下载最新版 [chromedriver](https://sites.google.com/a/chromium.org/chromedriver/)（for windows)

![chromedriver]({{page.img-path}}win_download/screenshots/chromedriver.png)

#### Step 4: 创建桌面快捷方式

在 `MSUroll` 文件夹，找到 `MSUroll.exe` 文件， 右击创建桌面快捷方式

![send]({{page.img-path}}win_download/screenshots/send.png)

回到电脑桌面，你将看到

![desktop]({{page.img-path}}win_download/screenshots/desktop.png)

打开 `MSUroll.exe`

![gui]({{page.img-path}}win_download/screenshots/gui.png)

如果碰到以下问题：

![warn]({{page.img-path}}win_download/screenshots/warn.png)

解决方案：

![solve 1]({{page.img-path}}win_download/screenshots/solve1.png)

![solve 2]({{page.img-path}}win_download/screenshots/solve2.png)


#### Step 5：传送至[使用说明](#intro)


## 使用说明
### 声明：
**MSUroll 需要实时监测是否有人drop了课，为了保证能在第一时间抢到课，必须保持电脑持续开机和连网。最理想的状态是，每次重新打开电脑或者断网后重新连接后，必须关闭 MSUroll， 重新打开，重新选课，开启 自动抢课 状态后，可以选择最小化，然后可以放心去做其他事情。**


### windows 用户请注意
> 如果有以下类似弹窗，属于正常现象，请选择 **忽略** 或者 **最小化**，***千万不能关闭***

![pop up]({{page.img-path}}win_download/screenshots/popup.png)



### 选课

![choose classes]({{page.img-path}}mac_download/screenshots/choose.png)

![confirm]({{page.img-path}}mac_download/screenshots/confirm.png)



### 抢课

![validating classes]({{page.img-path}}mac_download/screenshots/waiting.png)

![status]({{page.img-path}}mac_download/screenshots/status.png)

![live status]({{page.img-path}}mac_download/screenshots/live_status.png)

![done]({{page.img-path}}mac_download/screenshots/finish.png)


<!--
> ### Mac 用户请注意
>
> 如果有选课界面出现异常的 `[ERROR]`
>
> 请下载 [MSUroll_disk_debug.dmg](https://github.com/by-the-w3i/MSU_ROLL/releases)
>
> ![warning]({{page.img-path}}mac_download/screenshots/download.png)
>
> 出现弹窗属于正常现象
>
> ![warning]({{page.img-path}}mac_download/screenshots/pop.png)
)
-->


## 问题反馈与技术交流：

`email` : jevin0change@gmail.com

