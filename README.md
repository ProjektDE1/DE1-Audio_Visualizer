# DE1-Audio-Visualizer

Repository for project in class DE1

# Team Members:

- Matouš Huczala -> discord: matyskovo 
- Jerguš Gecík
- Samuel Pažítka
- Pavel Uher

# Overview

Our project is an Audio Visualizer which will be realised on a Nexys A7 50T FPGA board. It will sample real time audio and display the volume on a series of 16x LEDs and a 7 segment display. To realise this we are using the build in MEMS microphone and LEDs.

## Inputs

The system is controlled using the integrated buttons and clock signal on the Nexys A7 board:

**Clock signal:**
* **`clk`** - System clock signal 100 MHz, pin E3.

**Buttons:**
* **`rst` (`BTNC`)** - Resets the system to its default state, pin N17.

**Microphone:**
* **`mic_data_in`** - PDM data input from the onboard ADMP421 microphone, pin H5.

## Outputs

The measured sound level values are output to the following peripherals:

**Seven-segment display:**
* **Segment 0 (DISP 0)** - Displays the units digit of the sound level value in dB.
* **Segment 1 (DISP 1)** - Displays the tens digit of the sound level value in dB.
* **Segment 2 (DISP 2)** - Displays the character `b` 
* **Segment 3 (DISP 3)** - Displays the character `d` 

**LED bargraph:**
* **`LD0–LD15`** - Visual indication of the sound level. Each LED represents ~6 dB. No LEDs are lit during silence, all LEDs are lit at maximum volume.

**Microphone control outputs:**
* **`mic_clk_out`** - PDM clock signal for the ADMP421 microphone (~1.19 MHz), pin J5.
* **`mic_lr_sel`** - Microphone channel select, permanently set to `'0'` (left channel), pin F5.
