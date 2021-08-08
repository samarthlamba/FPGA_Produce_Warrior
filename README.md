# FPGA Based Fruit Ninja (aka Produce Warriors)

The game utilizes the [NEXYS A7 FPGA](https://reference.digilentinc.com/_media/nexys:nexys4:nexys4_rm.pdf). The game also uses a VGA screen to show animation, sound, accelerometer, among others. Produce Warrior, is very similar in concept to Fruit Ninja, but we made a few changes. Rather than implementing fruit slicing, we use a hammer to “smash” the fruits. The scoring mechanism took inspiration from the popular game Temple Run: players’ points are based on how long they can stay in the game, and if they miss nine fruits the game ends. It also uses real "slicing action" to get the fruit using accelerometer.

### Prerequisites

Software needed to successfully run the project:

```
Vivado
Icarus Verilog
GTKWave
```

Hardware needed to successfully run the project:

```
NEXYS A7 FPGA
VGA Screen
Headphones or output device
```
### Video Demo

https://user-images.githubusercontent.com/48296928/128646391-a4d4488b-93ea-4f18-be70-a7dce312929e.MOV


### Acknowledgement and Credits
We utilized public images present in the github https://github.com/surajrampure/Fruit-Ninja-Final-Project/tree/master/Fruit%20Images. 
