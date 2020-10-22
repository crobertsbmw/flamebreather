# Flame Breathing Pumpkin Mod

![](https://imgur.com/EnnLEEy.jpg)

### Print the STL files

Open the STL files in your favorite slicer program. I use [Cura]("https://ultimaker.com/software/ultimaker-cura"), it's free, easy to setup, and I haven't had any trouble with it. 

For the main flamethrower housing, print it standing up.  It uses more plastic than if you print it on it's back, but it probably needs supports either way, and it's easier if the supports don't interface with the sides that hold the hairspray and the candle.

![](https://i.imgur.com/kyeALLs.jpg)

### Prepare the Stepper Motor

![](https://imgur.com/3Iwt8bm.png) 

You're going to need a stepper motor and a stepper motor controller. I used a NEMA 17 Stepper Motor with a metal GT2 gear installed on shaft, but now that I'm looking these up, I'm having a hard time finding another just like it. I would suggest you just buy a stepper motor, and then if neither of the gears included in the project fit on the stepper motor shaft, you can make your own in Tinkercad. It's not terribly difficult; YOU CAN DO IT! 

You also need a motor controller. There are two types of stepper motors, Bipolar and Unipolar. The Nema 17 is a bipolar motor, so I'm using the L298N Dual H Bridge. Just make sure the motor controller you get matches the type of stepper motor you have. Either one should be pretty straightforward to wire up.

I used an Arduino UNO, and I'm sure every different stepper motor controller is going to wire up a little differently, but if you got the same controller I did, then you can hook up the controller like this:
```
UNO     Controller
D8 ---- IN1
D9 ---- IN2
D10 --- IN3
D11 --- IN4
GND --- GND
```

![](https://imgur.com/YZGbBMs.jpg)
![](https://imgur.com/Fl40oif.jpg)
![](https://imgur.com/1XUphLm.jpg)
https://imgur.com/mndwOSv.jpg
Also, note that the stepper motor runs off of 12 volts and needs it's own power supply.

### Run the Arduino

Load the flamethrower.ini file onto your Arduino. You should then be able to send a number to the Arduino over the Serial Monitor (Tools -> Serial Monitor), and see your motor move that number of steps. You may also need to edit the `stepsPerRevolution` variable in the .ini file based on your specific motor.

You can also add a bluetooth module to the Arduino. You can get an HM10 module from ebay for about $3, which works great. The TX and RX pins on the bluetooth module hook up to pins D2 and D3 of the Arduino respectively. The only real quark with the bluetooth implementation is that I wanted to send the number of steps in a single byte over the bluetooth. A byte gives you values from 0 to 255. So if I am sending a negative value, I just added 100 to that value. So sending a `50` to the Arduino over bluetooth would be decoded as `50` steps, and sending a value of `125` over the bluetooth to the Arduino would be decoded as a `-25` step rotation.

### Run the App

iOS only right now. And unfortunately, the app isn't yet on the app store. But if you have xCode installed, and have a developer's license with apple, then you can load the app on your phone. If you have a developer's license, then I'll assume you know how to do this part.


### Make it Flame

Once you have everything loaded up, you can just tap the BURN button in the app. When you press the button down, the number of steps (as selected by the slider), gets sent to the Arduino to turn the stepper motor (opening the flame), and when you release the button, the app sends the negative of that number to the Arduino to turn the motor back (closing the flame)! There are also buttons in the top right corner to turn the motor without automatically turning it back.

### Conclusion

If you have any questions, or if I missed anything, please let me know!