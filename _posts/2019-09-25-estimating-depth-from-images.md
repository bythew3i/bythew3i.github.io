---
layout:         post
title:          Estimating depth from images
subtitle:       Simple experiment of Intel Realsense Camera
date:           2019-09-25
author:         bythew3i
img-path:       /img/2019-09-25-estimating-depth-from-images/
header-img:     img/2019-09-25-estimating-depth-from-images/bg.png
catalog:        true
tags:
    - ROS
    - Robotics
    - Vision
    - Python
    - Yale
---

> Depth estimation is critical in interactive machines. In general, it is impossible to estimate the absolute scale of a scene based only on an image of it. However, if we know the true size of an object in the world, we can take advantage of this piece of information to estimate how far the object is from the camera (i.e., its depth). This is my goal for this project.

## Environment
- Ubuntu 18.04
- [ROS Melodic](http://wiki.ros.org/melodic/Installation/Ubuntu.)
- RealSense D435 camera

## Requirement
- [RealSense driver](https://github.com/IntelRealSense/librealsense/blob/master/doc/distribution_linux.md)
- [realsense2_camera ROS package](https://github.com/IntelRealSense/realsense-ros)

## Code
```python
#!/usr/bin/env python
# Example script to load the data, visualize the images, and capture clicks to identify the book
# Run the script as: ./process_images.py images.npz

import sys
import cv2
import numpy as np
from extract_coordinates import extract_coordinates

# -------------------------------------------------------------------------------
# get input path
images_file = sys.argv[1]

# load data
print("Loading {}".format(images_file))
data = np.load(images_file)

gray=data['gray']              # gray image captured by the camera
depth=data['depth']            # aligned depth image (transformed to match the gray image)
width=data['width']            # images width
height=data['height']          # images height
K=np.reshape(data['K'], (3,3)) # camera intrinsic parameters

# -------------------------------------------------------------------------------
# display the depth image
# but first normalize it so that all parts are visible and not too dark...
scaled_depth = 255 * depth / depth.max() # normalize data to 0 to 255
depth_as_int = scaled_depth.astype(np.uint8)

cv2.imshow("Depth", depth_as_int)
cv2.moveWindow("Depth", 20,20);

# display the gray image
cv2.imshow("Gray", gray)
cv2.moveWindow("Gray", 20 + width, 20)

print("You should now see the depth and gray image. Press any key to continue...")
cv2.waitKey(0)

# close all windows
cv2.destroyAllWindows() 

# -------------------------------------------------------------------------------
# get coordinates of book in the gray image
image_coordinates = []
image = gray 

cv2.namedWindow('select')
cv2.setMouseCallback('select', extract_coordinates, param=(image_coordinates, image))
cv2.imshow("select", gray)

print("Identify the object of interest by clicking the top-left corner of the front cover of the book with the left mouse button, holding the press until the mouse is in the bottom-right corner of the book, and then releasing the left button...")

while len(image_coordinates) < 2:
    cv2.waitKey(1) # wait until the region of interest is selected on the image...

cv2.destroyAllWindows()

print("Top-left: {}".format(image_coordinates[0]))
print("Bottom-right: {}".format(image_coordinates[1]))

# -------------------------------------------------------------------------------
# Implement your code donw below...

## pV-2
object_height = float(sys.argv[2])

x1, y1 = image_coordinates[0]
x2, y2 = image_coordinates[1]

Y1z = (y1-K[1][2])/K[1][1]
Y2z = (y2-K[1][2])/K[1][1]

Z = object_height/abs(Y1z-Y2z)
print("Estimated depth: {}m".format(Z))


## pV-3
cnt = 0
tot = 0
for r in range(y1, y2+1):
    for c in range(x1, x2+1):
        if depth[r][c]== 0.:
            continue
        cnt += 1
        tot += depth[r][c]
average_depth = tot/cnt
print("Estimated depth from depth image: {}m".format(average_depth)) # where average_depth is computed from the depth image
print("Difference between estimates: {}".format(average_depth - Z))

```

## Result

#### Input

> My black Yale notes binder’s height is 29.7cm.

![V-4-1]({{page.img-path}}V-4-1.png)
![V-4-2]({{page.img-path}}V-4-2.png)
![V-4-3]({{page.img-path}}V-4-3.png)

#### Output:

![V-4-4]({{page.img-path}}V-4-4.png)

```
Top-left: (321, 161)
Bottom-right: (411, 275)
Estimated depth: 1.6076545619m
Estimated depth from depth image: 1.53564919162m 
Difference between estimates: -0.0720053702764
```




