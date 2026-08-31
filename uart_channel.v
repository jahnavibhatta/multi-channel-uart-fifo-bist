module uart_channel (
    input  wire       clk,
    input  wire       rst,

    // Common baud tick from top module
    input  wire       baud_tick,

    // -------------------------
    // Transmit side
    // -------------------------
    input  wire [7:0] tx_data,
    input  wire       tx_start,
    output wire       tx_busy,

    // -------------------------
    // Receive side
    // -------------------------
    input  wire       rx,
    output wire [7:0] rx_data,
    output wire       rx_valid,

    // -------------------------
    // Serial output
    // -------------------------
    output wire       tx
);


    // -------------------------
    // UART Transmitter
    // -------------------------
    uart_tx transmitter (
        .clk       (clk),
        .rst       (rst),
        .baud_tick (baud_tick),
        .tx_data   (tx_data),
        .tx_start  (tx_start),
        .tx        (tx),
        .tx_busy   (tx_busy)
    );


    // -------------------------
    // UART Receiver
    // -------------------------
    uart_rx receiver (
        .clk       (clk),
        .rst       (rst),
        .baud_tick (baud_tick),
        .rx        (rx),
        .rx_data   (rx_data),
        .rx_valid  (rx_valid)
    );

endmodule