/*
 * Disclosure: Copyright (C) Infineon Technologies AG.
 * This code belongs to Infineon Technologies AG and must not be redistributed
 * or made publicly available without prior written consent of the owner.
 */

`define WAIT_NS(TIME) #(``TIME``*1ns);
`define WAIT_US(TIME) #(``TIME``*1us);
`define WAIT_MS(TIME) #(``TIME``*1ms);
`define WAIT_PS(TIME) #(``TIME``*1ps);

`define DWIDTH    16    // Data bus width
`define AWIDTH    3
`define EXT_INPUTS_NB 16

`define CTRL0_ADDR            3'd0
`define PWM_MODE_ADDR         3'd1
`define CNT_TIMER_MODE0_ADDR  3'd2
`define CNT_TIMER_MODE1_ADDR  3'd3
`define ACT_CNT_VALUE_ADDR    3'd4
`define COMMAND_ADDR          3'd5
`define CAPTURE_STATUS_ADDR   3'd6