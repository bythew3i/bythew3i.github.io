---
layout:         post
title:          微信「跳一跳」破解程序开发记录
subtitle:       使用 Mac 与 iPhone 7 实现自动化刷分
date:           2018-01-04
author:         bythew3i
img-path:       /img/2018-01-04-wechat-jump-game-hack/
header-img:     img/2018-01-04-wechat-jump-game-hack/jumpgame_bg.png
catalog:        true
tags:
    - ios
    - hack
    - Python
---

> 闲来没事，赶赶程序员们的新潮，做了一番研究， 写了些代码，自动刷分微信跳一跳小程序

## 引子
前几日（2017年12月28日），微信发布了一款 `跳一跳` 的小程序。而我是大概在今年一月2号才第一次玩这个游戏，由于手残，分数一直在 10 分左右徘徊。

那天，正好看到一条关于跳一跳“伪POST刷分”的微信推送，评论里说腾讯已经及时修补了该漏洞。于是，我纳闷是否还有其他破解方法，然后我就看到 `github` 上的确有这样类似的项目：

https://github.com/wangshub/wechat_jump_game

之前没有写这种外挂的经验，一看他 `python` 脚本里用到的库 `PIL` 啊什么的都是我非常熟悉的库。于是我就放弃阅读了，准备自己试着写一个破解程序。

#### 物理攻击

> 在微博上看到的，应该算是程序员的物理攻击

<iframe src="https://www.youtube.com/embed/PTqf7Qbi0BM" frameborder="0" gesture="media" allow="encrypted-media" allowfullscreen></iframe>


#### 魔法伤害

> 接下来给大家看看什么才是程序员的魔法伤害 -- 这是我的成品，全自动无限刷分

<iframe src="https://www.youtube.com/embed/thoQPGUqHGw" frameborder="0" gesture="media" allow="encrypted-media" allowfullscreen></iframe>



## 准备工作
#### 设备
- Mac
- iPhone 6/7/8

#### 安装 WDA
- [iOS 真机如何安装 WebDriverAgent](https://testerhome.com/topics/7220)
- 安装 [python-wda](https://github.com/openatx/facebook-wda)
- [WDA API docs](https://github.com/openatx/facebook-wda)

> 发现这个 `WDA` 和我之前开发抢课软件用到的 `ChromeDriver` 异曲同工。以后也将更方便我做此类自动化项目。


#### 整体思路
- 跳之前，拍一张游戏截图传到电脑
- 算法识别 `棋子位置` 和 `目的地中心位置` （也就是下个着陆点）
- 计算距离，转化时间
- 通过 WDA 控制 iPhone 完成跳跃
- 回到第一步


#### 数据分析

此过程简单解释了 数据分析，完成 [安装 WDA](#安装-wda)的读者可直接跳至 [使用说明](#使用说明)

#### 采样 

```python
# test.py
__author__="bythew3i"

import wda

c=wda.Client()
cnt = 1
while input("Enter CMD: ")!="n":
    c.screenshot('img_data/screenshot{}.png'.format(cnt))
    cnt += 1
```

得到屏幕 N 张 screenshot

Again, [WDA 使用教程](https://github.com/openatx/facebook-wda)

#### 分析
```python
# imgtest.py, testall.py
__author__="bythew3i"

from PIL import Image, ImageDraw
from math import sqrt

PLAYERCOLOR = (56, 59, 102) # player color reference
PCOLORAPPR = 5 # player color approximation (tryin to find the pixel whose color distance with PLAYERCOLR is less than this value)
BCOLORDIFF = 30 # board color difference (calculate the color distance of a pixel and background color, if greater than this value, we consider this pixel is from board)
BCOLORAPPR = 5 # board color approximation (After finding topmost board pixel, use it to find the rightmost pixel by calling "isCloseColor" function with this value)

def aimTarget(im, tx, ty, color=33):
    imw = im.size[0] # width
    imh = im.size[1] # height
    draw = ImageDraw.Draw(im)
    draw.line((0, ty, imw-1, ty), fill=color)
    draw.line((tx, 0, tx, imh-1), fill=color)
    del draw

def colorDistance(c1, c2):
    return sqrt((c1[0]-c2[0])**2+(c1[1]-c2[1])**2+(c1[2]-c2[2])**2)

def isCloseColor(c1, c2, ref):
    return -ref < c1[0]-c2[0] < ref \
        and -ref < c1[1]-c2[1] < ref \
        and -ref < c1[2]-c2[2] < ref

def setFrame(im, color=200):
    imw = im.size[0] # width
    imh = im.size[1] # height
    draw = ImageDraw.Draw(im)
    # draw.line((0, imh//2, imw-1, imh//2), fill=color)
    draw.line((imw//2, 0, imw//2, imh-1), fill=color)
    draw.line((0, imh//3, imw-1, imh//3), fill=color)
    draw.line((0, imh*2//3, imw-1, imh*2//3), fill=color)
    del draw

def findPlayer(im):
    offsetX = 5
    offsetY = -10
    imw = im.size[0]
    imh = im.size[1]
    for y in range(imh*2//3, imh//2, -1):
        for x in range(imw):
            cur = im.getpixel((x, y))
            if colorDistance(cur, PLAYERCOLOR) <= PCOLORAPPR:
                return x+offsetX, y+offsetY
    return None


def findBoard(im, right=True): # only search left half
    offsetY = 3
    boardColor = None
    topX = None

    imw = im.size[0]
    imh = im.size[1]

    xfrm, xto = imw//2, 0
    if right:
        xfrm, xto = imw-1, imw//2
    # find the top and board color
    for y in range(int(imh/3), int(imh/2)):
        preColor = im.getpixel((xto, y))
        for x in range(xfrm, xto, -1):
            curColor = im.getpixel((x, y))
            if colorDistance(curColor, preColor) > BCOLORDIFF:
                # return x, y
                topX = x
                boardColor = im.getpixel((x, y+offsetY))
                break
        if boardColor!=None:
            break

    # find left/right edge
    for x in range(imw-1, 0, -1):
        for y in range(int(imh/3), int(imh/2)):
            curColor = im.getpixel((x, y))
            if isCloseColor(curColor, boardColor, BCOLORAPPR):
                return topX, y

    return None

for i in range(19):
    im = Image.open("img_data/screenshot{}.png".format(i+1))
    # 750 x 1334
    tx, ty = findPlayer(im)
    bx, by = findBoard(im, tx < im.size[0]//2) ## check the next board location
    # print(bx, by)
    # setFrame(im) ## draw the frame
    aimTarget(im, tx, ty)
    aimTarget(im, bx, by, 200)

    im.save("research/sample{}.png".format(i+1))
```

通过以上算法可以定位 `棋子` 和 `目的地中心位置`
![sample]({{page.img-path}}sample.png)

#### 结果

```python
# hackjump.py
__author__="bythew3i"

from math import sqrt
import wda
from PIL import Image, ImageDraw
import time

MAGICNUM = 0.0020 # coeffcient = time/physicalDistance
PLAYERCOLOR = (56, 59, 102) # player color reference
PCOLORAPPR = 5 # player color approximation (tryin to find the pixel whose color distance with PLAYERCOLR is less than this value)
BCOLORDIFF = 30 # board color difference (calculate the color distance of a pixel and background color, if greater than this value, we consider this pixel is from board)
BCOLORAPPR = 5 # board color approximation (After finding topmost board pixel, use it to find the rightmost pixel by calling "isCloseColor" function with this value)

def colorDistance(c1, c2):
    return sqrt((c1[0]-c2[0])**2+(c1[1]-c2[1])**2+(c1[2]-c2[2])**2)

def phyDistance(x1, y1, x2, y2):
    return sqrt((x1-x2)**2 + (y1-y2)**2)

def isCloseColor(c1, c2, ref):
    return -ref < c1[0]-c2[0] < ref \
        and -ref < c1[1]-c2[1] < ref \
        and -ref < c1[2]-c2[2] < ref

def findPlayer(im):
    offsetX = 5
    offsetY = -10
    imw = im.size[0]
    imh = im.size[1]
    for y in range(imh*2//3, imh//2, -1):
        for x in range(imw):
            cur = im.getpixel((x, y))
            if colorDistance(cur, PLAYERCOLOR) <= PCOLORAPPR:
                return x+offsetX, y+offsetY
    return None


def findBoard(im, right=True): # only search left half
    offsetY = 3
    boardColor = None
    topX = None

    imw = im.size[0]
    imh = im.size[1]

    xfrm, xto = imw//2, 0
    if right:
        xfrm, xto = imw-1, imw//2
    # find the top and board color
    for y in range(int(imh/3), int(imh/2)):
        preColor = im.getpixel((xto, y))
        for x in range(xfrm, xto, -1):
            curColor = im.getpixel((x, y))
            if colorDistance(curColor, preColor) > BCOLORDIFF:
                # return x, y
                topX = x
                boardColor = im.getpixel((x, y+offsetY))
                break
        if boardColor!=None:
            break

    # find left/right edge
    for x in range(imw-1, 0, -1):
        for y in range(int(imh/3), int(imh/2)):
            curColor = im.getpixel((x, y))
            if isCloseColor(curColor, boardColor, BCOLORAPPR):
                return topX, y
    return None


def getDistance(path):
    im = Image.open(path)
    # 750 x 1334
    tx, ty = findPlayer(im)
    bx, by = findBoard(im, tx < im.size[0]//2) ## check the next board location
    return phyDistance(tx, ty, bx, by)


def main():
    tapX = 50
    tapY = 50
    path = 'buffer/resource.png'
    wait = 2

    c = wda.Client()
    s =  c.session()

    while True:
        c.screenshot(path)
        t = getDistance(path)*MAGICNUM
        # print(t)
        s.tap_hold(tapX, tapY, t) # tap element
        time.sleep(wait)


main()
```


## 使用说明

#### 参数调节

**注意**：本教程直接适用于 iPhone6/7/8 (4.7寸显示屏)。其他 iPhone 机型请参考 [数据分析](#数据分析) 来调试以下数据

```python
MAGICNUM = 0.0020 # coeffcient = time/physicalDistance
PLAYERCOLOR = (56, 59, 102) # player color reference
PCOLORAPPR = 5 # player color approximation (tryin to find the pixel whose color distance with PLAYERCOLR is less than this value)
BCOLORDIFF = 30 # board color difference (calculate the color distance of a pixel and background color, if greater than this value, we consider this pixel is from board)
BCOLORAPPR = 5 # board color approximation (After finding topmost board pixel, use it to find the rightmost pixel by calling "isCloseColor" function with this value)
```

完成 [安装 WDA](#安装-wda) 后，

- ***Xcode > Product > Scheme > WebDriverAgentRunner***
- ***Xcode > Product > Destination > {your iPhone}***
- ***Xcode > Product > Test***

打开一个 `terminal`
 ```bash
iproxy 8100 8100
 ```

打开另一个 `terminal`
```bash
git clone https://github.com/bythew3i/WeChat-JumpGame-hack-iPhone.git
cd WeChat-JumpGame-hack-iPhone
```

微信打开跳一跳小程序，点击`开始游戏`

```bash
python3 hackjump.py
```

不要太 `high` 哦. 差不多就行了 ...
<img src="{{page.img-path}}high.png" alt="ad3" width="50%">

#### 项目地址
Github: https://github.com/bythew3i/WeChat-JumpGame-hack-iPhone
