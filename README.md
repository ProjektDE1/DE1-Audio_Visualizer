# DE1-Audio-Visualizer

# Team Members:

- Matouš Huczala 
- Jerguš Gecík 
- Samuel Pažítka
- Pavel Uher

# Overview

Our project is an Audio Visualizer realised on a Nexys A7-50T FPGA board. It samples real-time audio using the onboard ADMP421 MEMS microphone and processes the PDM signal to measure the current sound level. The result is displayed as a dB value on the 7-segment display and as a visual bargraph across 16 LEDs.
The design consists of four components: [pdm_interface](source%20files/pdm_interface.vhd), [acumulator](source%20files/acumulator.vhd), [a LED driver](source%20files/LED_driver.vhd) and a [signal_processor](source%20files/signal_processor.vhd).

## Top Diagram

![Block Diagram](source%20files/audio-visualiser%20(1).png)

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
* **Segment 0 (DISP 1)** - Displays the units digit of the sound level value in dB, pin `J17`.
* **Segment 1 (DISP 2)** - Displays the tens digit of the sound level value in dB, pin `J18`.
* **Segment 2 (DISP 3)** - Displays the hundreds digit of the sound level value in dB, pin `T9`.
* **Segment 2 (DISP 4)** - Displays the character `b`, pin `J14`.
* **Segment 3 (DISP 5)** - Displays the character `d`, pin `P14`.
* **Decimal point (DP)** - pin `H15`, permanently off.

**LED bargraph:**
* **`LD0–LD15`** - Visual indication of the sound level. No LEDs are lit during silence, all LEDs are lit at maximum volume.

**Microphone control outputs:**
* **`mic_clk_out`** - PDM clock signal for the ADMP421 microphone (~3.03 MHz), pin J5.
* **`mic_lr_sel`** - Microphone channel select, permanently set to `'0'` (left channel), pin F5.

* ## Simulation Results
Showcase of the simulations for each individual module used in the project.

### PDM Interface
![pdm_interface simulation](testbench/screenshots/pdm_inteface.png)
*Simulation showing the generated PDM clock (`m_clk`) toggling at ~3.03 MHz.

### Accumulator
![accumulator simulation](testbench/screenshots/acumulator.png)
*The accumulator counting PDM ones over a window of 4096 samples, asserting `data_valid` and outputting the 13bit result at the end of each window.*

### Signal Processor
![signal_processor simulation](testbench/screenshots/signal_processor2.png)
*LUT converting the accumulator output to a calibrated dB value. The `db_out` signal updates on each `data_valid` pulse.*

### LED Driver
![led_driver simulation](testbench/screenshots/led_driver.png)
*Three input samples (66, 90 and 120 dB) are applied via `data_valid`, with `led_out` stepping from `0x0000` to `0xffff` which confirms correct behaviour. The `an` and `seg` signals cycle through all 8 display digits.*

## Media

## References and Tools
### Tools
- **Vivado Design Suite:** Used for synthesis and bitstream generation.
- **Vivado Simulator:** Used for verification of functionality of each module.
- **Git:** Documentation.
- **Claude/Gemini:** Used for general tech-support and verification.
  
 ### References
- **[IEEE Standard 1076-2008 - VHDL Language Reference Manual](<https://0x04.net/~mwk/vstd/ieee-1076-2008.pdf>)** 
- **[Nexys A7 Digilent Reference](<https://digilent.com/reference/programmable-logic/nexys-a7/start>)** 
- **[Online VHDL Testbench Template Generator](<https://vhdl.lapinoo.net>)**
- **[Reference Tone Generator](<https://www.szynalski.com/tone-generator>)** 

