# Assembly-8086-NASM-Snake
Snake in 8086 NASM assembly

Fully functional bootloader than runs snake game. Snake is controllable with WASD and grows when it eats apples.

Made because I wanted to learn assembly.

Controls: WASD

## Compilation

First, the assembly file needs to be compiled to binary.

```
chmod +x compile.sh
./compile.sh
```

After that's done, you can boot from the resulting `.img` file using VirtualBox. Alternatively, you can copy the binary to a physical drive using `dd` to boot a physical device using the bootloader.

<img height=250 width=250 src="http://g.recordit.co/Q80r7qWULv.gif"></img>
