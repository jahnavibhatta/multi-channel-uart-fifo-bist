`timescale 1ns/1ps

module tb_uart_tx;

    reg clk;
    reg rst;
    reg baud_tick;
    reg [7:0] tx_data;
    reg tx_start;

    wire tx;
    wire tx_busy;

    // DUT
    uart_tx uut (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick),
        .tx_data(tx_data),
        .tx_start(tx_start),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    // 32 MHz clock
    always #15.625 clk = ~clk;

    // Generate baud tick for simulation
    // Here we simply create a tick every 10 clock cycles
    always begin
        baud_tick = 1'b0;
        #312.5;

        baud_tick = 1'b1;
        #31.25;
    end

    initial begin

        clk      = 1'b0;
        rst      = 1'b1;
        tx_data  = 8'b00000000;
        tx_start = 1'b0;

        #100;

        rst = 1'b0;

        // Send AE = 10101110
        tx_data  = 8'b10101110;
        tx_start = 1'b1;

        #31.25;

        tx_start = 1'b0;

        // Wait for complete transmission
        #4000;

        $finish;

    end

endmodule