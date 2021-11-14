---
layout:         post
title:          Train AI to play Atari Enduro
subtitle:       A Reinforcement Learning (DQN) based AI agent
date:           2019-12-12
author:         bythew3i
assets-path:       /assets/2019-12-12-train-ai-to-play-atari-enduro/
header-img:     assets/2019-12-12-train-ai-to-play-atari-enduro/bg.gif
header-mask:    0.1
catalog:        true
tags:
    - AI/ML
    - Reinforcement Learning
    - Gym
    - Python
category:       Teach AI Everything - Atari
---

> During the 2019 Thanksgiving break, I trained a DQN based agent which can play Enduro atari game. 

## Game Rule
The number of cars you must pass is posted at the beginning of each day in the lower right corner of your instrument panel (200 on the first day, 300 on subsequent days). Each time you pass a car, this meter counts off by one. When you pass the required number of cars, green flags appear. But keep going. All additional kilometres are added to your total. You'll move on to the next day when the present day ends. If you don't pass the required number of cars by daybreak, the game ends.

## Requirements
tensorflow==1.14.0
numpy==1.16.4
gym==0.15.4
keras-rl
matplotlib



## Results
After 1.5 hours training, I get these results:
![episode_reward_500000]({{page.assets-path}}episode_reward_500000.png)
![episode_steps_500000]({{page.assets-path}}episode_steps_500000.png)


)ter 10 hours training, I get these results:
![episode_reward_4000000]({{page.assets-path}}episode_reward_4000000.png)
![episode_steps_4000000]({{page.assets-path}}episode_steps_4000000.png)



## Demo
<iframe src="https://www.youtube.com/embed/qv9AVpAmpJI" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>