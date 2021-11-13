---
layout:         post
title:          EV3 + DualShock4 + GoPro5
subtitle:       Use PS4 Controller to remote EV3 cart
date:           2018-01-03
author:         bythew3i
img-path:       /img/2018-01-03-ev3-dualshock4-gopro5/
header-img:     img/2018-01-03-ev3-dualshock4-gopro5/exp.jpg
catalog:        true
tags:
    - Python
    - EV3
    - Robotics
    - LEGO
---
> During 2017 summer break, I tried to find a way to connect Sony DualShock 4 Controller to EV3. However there was not so much information online, finally I figured it out by my own and the PS4 controller now can be fully programmed.



## Requirements

- Download [ev3dev](http://www.ev3dev.org/)
- Read [python-ev3dev API](http://python-ev3dev.readthedocs.io/en/stable/)

## Controller Key Mapping
> It took me a while to test the key map. Finally I concluded a full version of key mapping.

![ps4mapping1]({{page.img-path}}ps41.jpg)
![ps4mapping2]({{page.img-path}}ps42.jpg)


## Remote Control EV3 LEGO Cart

#### Video
<iframe src="https://www.youtube.com/embed/VmpZEG375fI" frameborder="0" gesture="media" allow="encrypted-media" allowfullscreen></iframe>


#### Code 
``` python
#!/usr/bin/env python3
__author__ = "bythew3i"

import evdev
import ev3dev.auto as ev3
import threading


def scale(val, src, dst):
    return (float(val - src[0]) / (src[1] - src[0])) * (dst[1] - dst[0]) + dst[0]

def scale_stick(value):
    return scale(value, (0,255),(-100,100))


# ps4 controller set up
print("Finding ps4 controller...")
devices = [evdev.InputDevice(fn) for fn in evdev.list_devices()]
ps4dev = devices[0].fn

gamepad = evdev.InputDevice(ps4dev)
running = True



# wheel set up
wheel_speed = 0

class MotorThread(threading.Thread):
    def __init__(self):
        self.motor = ev3.LargeMotor(ev3.OUTPUT_A)
        threading.Thread.__init__(self)

    def run(self):
        print("Wheels Ready...")
        while running:
            self.motor.run_direct(duty_cycle_sp=wheel_speed)

        self.motor.stop()

motor_thread = MotorThread()
motor_thread.setDaemon(True)
motor_thread.start()


# steer set up
steer_speed = 0

class DirectionThread(threading.Thread):
    def __init__(self):
        self.motor = ev3.MediumMotor(ev3.OUTPUT_D)
        threading.Thread.__init__(self)

    def run(self):
        print("Steer Ready...")
        while running:
            self.motor.run_direct(duty_cycle_sp=steer_speed)

steer_thread = DirectionThread()
steer_thread.setDaemon(True)
steer_thread.start()


# event listner
for event in gamepad.read_loop():   #this loops infinitely
    if event.type == 3:             #A stick is moved
        if event.code == 5:         #Y axis on right stick
            wheel_speed = scale_stick(event.value)
        if event.code == 0:
            steer_speed = scale_stick(event.value)/3.0

    if event.type == 1 and event.code == 302 and event.value == 1:
        print("X button is pressed. Stopping.")
        running = False
        break
```


## Voice Control GoPro5 Camera

#### Video
<iframe src="https://www.youtube.com/embed/9SgoKhi-LiQ" frameborder="0" gesture="media" allow="encrypted-media" allowfullscreen></iframe>

#### Code

```python
#!/usr/bin/env python3
__author__ = "bythew3i"

import evdev
import ev3dev.auto as ev3
import threading
import ev3dev.ev3 as brickman


### general classes
class MotorThread(threading.Thread):
    def __init__(self, side, out):
        self.pause = False
        self.speed = 0
        self.work = True
        self.side = side
        self.motor = ev3.LargeMotor(ev3.OUTPUT_A)
        if out.upper() == "B":
            self.motor = ev3.LargeMotor(ev3.OUTPUT_B)
        elif out.upper() == "C":
            self.motor = ev3.LargeMotor(ev3.OUTPUT_C)
        elif out.upper() == "D":
            self.motor = ev3.LargeMotor(ev3.OUTPUT_D)

        threading.Thread.__init__(self)

    def run(self):
        print(self.side, "wheel is ready")
        while self.work:
            if self.pause:
                self.speed = 0
            self.motor.run_direct(duty_cycle_sp=self.speed)

        self.motor.stop()



### general functions
def scale(val, src, dst):
    return (float(val - src[0]) / (src[1] - src[0])) * (dst[1] - dst[0]) + dst[0]

def scale_stick(value):
    return scale(value, (0,255), (-100, 100))


def main():
    ### controller setup
    print("Controller Set Up ...")
    devices = [evdev.InputDevice(fn) for fn in evdev.list_devices()]
    gamepad = evdev.InputDevice(devices[0].fn)

    ### left motor
    l_motor_thread = MotorThread("LEFT", "A")
    l_motor_thread.setDaemon(True)
    l_motor_thread.start()

    ### right motor
    r_motor_thread = MotorThread("RIGHT", "D")
    r_motor_thread.setDaemon(True)
    r_motor_thread.start()


    ### controller listener
    sqr_cnt = 0
    cir_cnt = 0
    gopro_pow = False
    sound_config = '-a 300 -s 110'
    for event in gamepad.read_loop():
        if event.type == 3: # analog
            if event.code == 5: # right stick Y
                l_motor_thread.speed = -scale_stick(event.value)
                r_motor_thread.speed = -scale_stick(event.value)

            if event.code == 0: # left stick X
                if event.value > 133:
                    r_motor_thread.pause = True
                elif event.value < 122:
                    l_motor_thread.pause = True
                else:
                    l_motor_thread.pause = False
                    r_motor_thread.pause = False

        if event.type == 1: # key pressed
            if event.value == 1:
                if event.code == 304: # SQR btn -> gopro photo mode
                    option = sqr_cnt % 2
                    if option == 0:
                        cmd = "go pro photo mode"
                    elif option == 1:
                        cmd = "go pro take a photo"
                    brickman.Sound.speak(cmd, sound_config)
                    sqr_cnt += 1

                elif event.code == 305: # X btn -> turn off go pro
                    brickman.Sound.speak("Go pro turn off", sound_config)

                elif event.code == 306: # O btn -> go pro video mode
                    option = cir_cnt % 3
                    if option == 0:
                        cmd = "go pro video mode"
                    elif option == 1:
                        cmd = "go pro start recording"
                    else:
                        cmd = "go pro stop recording"
                    brickman.Sound.speak(cmd, sound_config)
                    cir_cnt += 1

                elif event.code == 307 and gopro_pow == False: # TRI btn -> turn on go pro
                    gopro_pow = True
                    pass
                elif event.code == 316: # PS btn -> quit the program
                    print("Quiting ...")
                    l_motor_thread.work = False
                    r_motor_thread.work = False
                    break
            if event.value == -1:
                if event.code == 16: # left btn
                    pass
                elif event.code == 17: # up btn
                    pass
main()

```