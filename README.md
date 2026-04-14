# DE1-Audio-Visualizer

# Team Members:

- Matouš Huczala -> discord: matyskovo 
- Jerguš Gecík
- Samuel Pažítka
- Pavel Uher

# Overview

Our project is an Audio Visualizer realised on a Nexys A7-50T FPGA board. It samples real-time audio using the onboard ADMP421 MEMS microphone and processes the PDM signal to measure the current sound level. The result is displayed as a dB value on the 7-segment display and as a visual bargraph across 16 LEDs, where each LED represents approximately 6 dB of dynamic range.
The design is implemented in VHDL and consists of five components: a clock divider, an accumulator enable counter, a PDM microphone interface, a sample accumulator, and a signal processor with a logarithmic LUT for dB conversion.

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
