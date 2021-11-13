---
layout:         post
title:          Face Classifier
subtitle:       A Deep Learning Practice
date:           2019-10-19
author:         bythew3i
assets-path:       /assets/2019-10-19-face-classifier/
header-img:     assets/2019-10-19-face-classifier/o1.png
header-mask:    0.5
catalog:        true
tags:
    - AI/ML
    - CNN
    - Vision
    - Tensorflow
    - Python
    - Yale
---

> In this project, I finished two tasks of deep learning practice. The first one is Approximating a Non-Linear Function and the second one is Building a Face Classifier.

## Requirements
```
tensorflow-gpu==2.0.0
opencv-python==4.1.1.26
matplotlib==2.1.1
```

## Approximating a Non-Linear Function

The input data file is a set of points. A matplotlib plot shows the visualization as below:

![inpd]({{page.assets-path}}inputd.png)


My goal was trying to train a model that maps the points with average `L2 error` on test set less than 200.

Firstly I trained the data with only one hiden layer, 16 `batch size`, 1e-2 `learning rate` and 500 `epochs`. 

```python
inputs = tf.keras.layers.Input(shape=(num_inputs,), name="inputs")
lyer = tf.keras.layers.Dense(64, use_bias=True)(inputs)
outputs = tf.keras.layers.Dense(1, use_bias=True)(lyer)
model = tf.keras.models.Model(inputs=inputs, outputs=outputs, name="monkey_model")
```

Then, I got this output:
![linear]({{page.assets-path}}l.png)

`L2 Error` on Testing Set: 856.107943739

So I added more hidden layers. Soon it became `overfit` as the `epoch_mae` read from `Tensorboard`:
![overfit]({{page.assets-path}}II-10.png)

Finally after keeping tuning the parameters and layers, I ended up with 3 hiden layers, 16 `batch size`, 1e-2 `learning rate` and 500 `epochs`.

```python
inputs = tf.keras.layers.Input(shape=(num_inputs,), name="inputs")
layer = tf.keras.layers.Dense(64, use_bias=True)(inputs)
layer = tf.keras.layers.Dense(64, activation='tanh')(layer)
layer = tf.keras.layers.Dense(64, use_bias=True)(layer)
outputs = tf.keras.layers.Dense(1, use_bias=True)(layer)
model = tf.keras.models.Model(inputs=inputs, outputs=outputs, name="monkey_model")
```
![overfit]({{page.assets-path}}II-9.png)

The `L2 Error` on Testing Set is 148.846732932 which reaches my goal -- below 200.


## Building a Face Classifier
Now I need to train the deep learning model and build a face classifier. 

The face detection trainning data set was requested from [Face Detection Dataset and Benchmark](http://vis-www.cs.umass.edu/fddb/) and you can download the `numpy npz file` [here](https://drive.google.com/file/d/1JIIalRu5WZQ01p-S6mBxzHV8ZMqAJcdH/view).


There 11038 training examples. And one sample picture is shown as below:

![overfit]({{page.assets-path}}sample.png)

Note that the `input` is organized as a 4-D tensor of dimension NxHxWxC, where N corresponds to the number of examples, H is the height of input images, W is their width, and C is the number of channels per image. In general, the dataset has color images of 64x64 pixels (i.e., W=H=64 and C=3). The channels are organized in Blue-Green-Red (bgr) order.

The `target` is a single number: 1 if the corresponding input image shows a face, or 0 otherwise. Thus, the `target` tensor is 2D. It has shape Nx1.

By looking at [Tiny DarkNet Network](https://pjreddie.com/darknet/tiny-darknet/) as a reference, finally I ended up like this:

```python
...

in_lyer = tf.keras.layers.Input(shape=(64,64,3), name="inputs")
lyer = tf.keras.layers.Conv2D(16, 1, activation='relu')(in_lyer)
lyer = tf.keras.layers.MaxPooling2D(2)(lyer)
lyer = tf.keras.layers.Conv2D(32, 1, activation='relu')(lyer)
lyer = tf.keras.layers.Flatten()(lyer)
out_lyer = tf.keras.layers.Dense(1, use_bias=True, activation='sigmoid')(lyer)

model = tf.keras.models.Model(inputs=in_lyer, outputs=out_lyer, name="face_model")
model.summary()

model.compile(optimizer=tf.keras.optimizers.Adam(lr=lr),
            loss='binary_crossentropy',
            metrics=['binary_accuracy'])
```

The ROC curve is shown as below:

![overfit]({{page.assets-path}}III-2.png)

Finally I tried to run my classifer on other two images. The original image inputs are shown below:

![overfit]({{page.assets-path}}i1.jpg)
![overfit]({{page.assets-path}}i2.jpg)

And my outputs are:

![overfit]({{page.assets-path}}o1.png)
![overfit]({{page.assets-path}}o2.png)