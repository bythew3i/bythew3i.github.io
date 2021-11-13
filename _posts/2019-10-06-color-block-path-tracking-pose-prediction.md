---
layout:         post
title:          Color Block Path Tracking & Pose Prediction
subtitle:       How to apply Kalman Filter to tracking and prediction?
date:           2019-10-06
author:         bythew3i
img-path:       /img/2019-10-06-color-block-path-tracking-pose-prediction/
header-img:     img/2019-10-06-color-block-path-tracking-pose-prediction/bg.gif
header-mask:    0.5
catalog:        true
tags:
    - ROS
    - Robotics
    - Vision
    - Python
    - Yale
---

> In this project, I learned about the popular colorspaces used in Computer Vison and successfully implemented the Kalman Filter Algorithm to predict the movement of object (Pose Prediction).

## Environment
- Ubuntu 18.04
- [ROS Melodic](http://wiki.ros.org/melodic/Installation/Ubuntu)
- RealSense D435 camera

## Requirement
- [RealSense driver](https://github.com/IntelRealSense/librealsense/blob/master/doc/distribution_linux.md)
- [realsense2_camera ROS package](https://github.com/IntelRealSense/realsense-ros)


## Detecting a Visual Target
First, my main ideas of detecting the color block were coming from these posts:
- [Tutorial on Color Spaces in OpenCV](https://www.learnopencv.com/color-spaces-in-opencv-cpp-python/)
- [Color Filtering OpenCV Python Tutorial](https://pythonprogramming.net/color-filter-python-opencv-tutorial/)
- [Tutorial on Blob Detection](https://www.learnopencv.com/blob-detection-using-opencv-python-c/)

The `input bag` (video resource) was provided by professor [Marynel VÁZQUEZ](http://www.marynel.net/)

![input]({{page.img-path}}in.gif)

After `color filtering`, I was able to capture the movement of the blue block.

![cl]({{page.img-path}}cl.gif)




## Kalman Filter: Pose Prediction


![desc]({{page.img-path}}desc.png)
![KFA]({{page.img-path}}KFA.jpeg)

After applying Kalman Filter Algorithm, I got this output:

![kf]({{page.img-path}}kf.gif)

> The images sent over the /tracked_image topic display two trajectories: the `red line` connects the observed locations for the target (as received through the /observations topic); and the `thinner green line` connects the estimated location for the target (from the Kalman Filter belief).


## Real-Time Filtering
Based on the ROS and RealSense D435 camera, I implemented a Yellow block tracking (`red line`) and Kalman Filter Pose prediction (`green line`) in real time system.

<iframe src="https://www.youtube.com/embed/qhstN7fMYwk" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

