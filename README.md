![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# Morse Code Translator

This project is a SystemVerilog implementation of a Morse code translator.

It decodes a Morse code input into alphabetical characters A-Z and
displays the translation on seven segment displays. Users input Morse code 
with an external push button and a flashing LED light blinks every one second
to help users stay on-beat. The most recent two translated characters are 
displayed on the two seven segment displays of the Digilent Pmod SSD.

This is a Tiny Tapeout Verilog project.

- [Read the documentation for project](docs/info.md)

## How it works

Morse code is input using a push button. A hold for one second is a "dit" 
(a dot .) and a hold for three seconds is a "dah" (a dash -). A release for 
one second distinguishes the end of a dit or dah, a release for three seconds 
is the end of a letter, and a release for seven seconds is the end of a word. 
This matches with standard Morse code conventions. The button press is 
translated into the characters A-Z and output as seven-segment encodings to be 
displayed on two seven segment displays through the Digilent Pmod SSD. An 
external LED blinks at a 1 second rate to help users keep time.

## How to test it

Test the SV modules with test/tb_counting.sv and tb_translation.sv. To verify
the translator, connect the external hardware (push button, LED, Digilent
Pmod SSD) according to the pinout defined in info.yaml. Use an external button 
to input the Morse code and input test characters according to the Morse code
timing conventions. Verify that the decoded letters appear on the external 
seven segment displays. See docs/info.md for more information.