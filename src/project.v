/*
 * Copyright (c) 2024 Nancy Anderson
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_nlanderso_morse_code (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  // assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  // assign uio_out = 0;
  // assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, uio_in[7:0], ui_in[7:1], 1'b0};

  wire [7:0] led_out;

  // Button press is the input
  // Output 8 bits to control the seven segments
  // Output 8 LED bits but only care about the LSB
  ChipInterface morse_code(.AA(uo_out[0]), .AB(uo_out[1]), .AC(uo_out[2]), 
                           .AD(uo_out[3]), .AE(uo_out[4]), .AF(uo_out[5]), 
                           .AG(uo_out[6]), .CAT(uo_out[7]), .led(led_out),
                           .clock(clk), .reset_n(rst_n), .btn_up(ui_in[0]));
  assign uio_oe = 8'h01;
  assign uio_out[7:1] = 7'b0;
  assign uio_out[0] = led_out[0];

endmodule
