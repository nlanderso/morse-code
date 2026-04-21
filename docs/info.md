<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

Morse code is input as a button press. A hold for one second is a "dit" and a 
hold for three seconds is a "dah". A release for one second distinguishes the 
end of a dit or dah, a release for three seconds is the end of a letter, and a
release for seven seconds is the end of a word. The button press is translated
into A-Z and output as seven-segment encodings to be displayed on two seven
segment displays. An external LED blinks at a 1 second rate to help users 
keep time.

## How to test

Use an external button to input the Morse code. Use an external LED to help
keep time as you input. The decoded letters should appear on the external 
seven segment displays

## External hardware

Button
LED
Digilent Pmod SSD
