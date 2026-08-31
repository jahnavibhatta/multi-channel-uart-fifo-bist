`timescale 1ns/1ps

module uart_multi_top (

    input  wire clk,
    input  wire rst,

    // UART 0
    input  wire [7:0] tx0_data,
    input  wire       tx0_start,
    output wire       tx0_busy,
    output wire [7:0] rx0_data,
    output wire       rx0_valid,
    input  wire       rx0,
    output wire       tx0,

    // UART 1
    input  wire [7:0] tx1_data,
    input  wire       tx1_start,
    output wire       tx1_busy,
    output wire [7:0] rx1_data,
    output wire       rx1_valid,
    input  wire       rx1,
    output wire       tx1,

    // UART 2
    input  wire [7:0] tx2_data,
    input  wire       tx2_start,
    output wire       tx2_busy,
    output wire [7:0] rx2_data,
    output wire       rx2_valid,
    input  wire       rx2,
    output wire       tx2,

    // UART 3
    input  wire [7:0] tx3_data,
    input  wire       tx3_start,
    output wire       tx3_busy,
    output wire [7:0] rx3_data,
    output wire       rx3_valid,
    input  wire       rx3,
    output wire       tx3
);

    // =====================================================
    // BAUD TICKS
    // =====================================================

    wire baud_tick0;
    wire baud_tick1;
    wire baud_tick2;
    wire baud_tick3;


    // =====================================================
    // UART 0 : 9600 BAUD
    // =====================================================

    baud_generator baud_gen0 (
        .clk       (clk),
        .rst       (rst),
        .divisor   (16'd208),
        .baud_tick (baud_tick0)
    );


    // =====================================================
    // UART 1 : 19200 BAUD
    // =====================================================

    baud_generator baud_gen1 (
        .clk       (clk),
        .rst       (rst),
        .divisor   (16'd104),
        .baud_tick (baud_tick1)
    );


    // =====================================================
    // UART 2 : 38400 BAUD
    // =====================================================

    baud_generator baud_gen2 (
        .clk       (clk),
        .rst       (rst),
        .divisor   (16'd52),
        .baud_tick (baud_tick2)
    );


    // =====================================================
    // UART 3 : 4800 BAUD
    // =====================================================

    baud_generator baud_gen3 (
        .clk       (clk),
        .rst       (rst),
        .divisor   (16'd417),
        .baud_tick (baud_tick3)
    );


    // =====================================================
    // UART 0 + FIFO
    // =====================================================

    uart_fifo_channel uart0 (

        .clk       (clk),
        .rst       (rst),
        .baud_tick (baud_tick0),

        .tx_data   (tx0_data),
        .tx_start  (tx0_start),
        .tx_busy   (tx0_busy),

        .rx        (rx0),
        .rx_data   (rx0_data),
        .rx_valid  (rx0_valid),

        .tx        (tx0)
    );


    // =====================================================
    // UART 1 + FIFO
    // =====================================================

    uart_fifo_channel uart1 (

        .clk       (clk),
        .rst       (rst),
        .baud_tick (baud_tick1),

        .tx_data   (tx1_data),
        .tx_start  (tx1_start),
        .tx_busy   (tx1_busy),

        .rx        (rx1),
        .rx_data   (rx1_data),
        .rx_valid  (rx1_valid),

        .tx        (tx1)
    );


    // =====================================================
    // UART 2 + FIFO
    // =====================================================

    uart_fifo_channel uart2 (

        .clk       (clk),
        .rst       (rst),
        .baud_tick (baud_tick2),

        .tx_data   (tx2_data),
        .tx_start  (tx2_start),
        .tx_busy   (tx2_busy),

        .rx        (rx2),
        .rx_data   (rx2_data),
        .rx_valid  (rx2_valid),

        .tx        (tx2)
    );


    // =====================================================
    // UART 3 + FIFO
    // =====================================================

    uart_fifo_channel uart3 (

        .clk       (clk),
        .rst       (rst),
        .baud_tick (baud_tick3),

        .tx_data   (tx3_data),
        .tx_start  (tx3_start),
        .tx_busy   (tx3_busy),

        .rx        (rx3),
        .rx_data   (rx3_data),
        .rx_valid  (rx3_valid),

        .tx        (tx3)
    );

endmodule