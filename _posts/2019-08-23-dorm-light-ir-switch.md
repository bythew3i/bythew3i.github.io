---
layout:         post
title:          Dorm Light IR Switch
subtitle:       How do lazy people turn off the bedroom light?
date:           2019-08-23
author:         bythew3i
img-path:       /img/2019-08-23-dorm-light-ir-switch/
header-img:     img/2019-08-23-dorm-light-ir-switch/IR_arduino.png
catalog:        true
tags:
    - Arduino
    - Robotics
    - C/C++
    - Yale
---

> Recently I started my master program at Yale University. During my first week, I was so tired of walking all the way to turn off the light in the dorm. Because the bed is soooo far away from the light switch. Then, guess what? I built a remote switch!!!

Oh! By the way, you can not find my dorm... because it is 404...hahaha (404 NOT FOUND)
<img src="{{page.img-path}}404.jpeg" alt="404" width="40%">

### Brainstorming
My initial plan was using `bluetooth`. But it might be time-consuming to write a interface for the front end for iPhone. Another alternative is using PS4 controller to connect the Arduino, but I felt it was such a waste on PS4 controller. 

Then I thought the optimal plan wass `IOT` (Internet of Things) by `Wi-Fi` or `Ethernet` port. By setting up a server, I could control the light switch on web in any device. But bad news was that the Ethernet port seemed broken in my dorm. I called the Yale IT service, I was told I can not set up my own server in dorm. 

Finally, I realized I could set up a remote control with IR components. So I used `arduino`, `IR sensor` and `IR remote` to build a light switch . Check out the video below...


### Showcase
<iframe src="https://www.youtube.com/embed/QKVqRtLmnKw" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>