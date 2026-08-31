`timescale 1ns/1ps

module tb_uart_loopback;

    reg clk;
    reg rst;

    reg [7:0] tx_data;
    reg tx_start;

    wire tx;
    wire tx_busy;

    wire [7:0] rx_data;
    wire rx_valid;

    wire baud_tick;

    // --------------------------------
    // Clock: 32 MHz
    // --------------------------------
    always #15.625 clk = ~clk;


    // --------------------------------
    // Baud Generator
    // 9600 baud, 16x
    // --------------------------------
    baud_generator baud_gen (
        .clk(clk),
        .rst(rst),
        .divisor(16'd208),
        .baud_tick(baud_tick)
    );


    // --------------------------------
    // UART Transmitter
    // --------------------------------
    uart_tx transmitter (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .tx(tx),
        .tx_busy(tx_busy)
    );


    // --------------------------------
    // UART Receiver
    // --------------------------------
    uart_rx receiver (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .rx(tx),              // TX connected directly to RX
        .rx_data(rx_data),
        .rx_valid(rx_valid)
    );
// Display TX whenever it changes during transmission
always @(tx) begin
    if (tx_busy)
        $display("Time = %0t ns : TX = %b", $time, tx);
end

    // --------------------------------
    // Test
    // --------------------------------
    initial begin

        clk      = 1'b0;
        rst      = 1'b1;

        tx_data  = 8'h00;
        tx_start = 1'b0;

        #100;

        rst = 1'b0;

        // Send AE
        tx_data  = 8'hAE;
        tx_start = 1'b1;

        #31.25;

        tx_start = 1'b0;

        // Wait for transmission/reception
        #1200000;

        $finish;

    end

endmodule