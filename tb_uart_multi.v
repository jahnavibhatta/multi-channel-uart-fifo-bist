`timescale 1ns/1ps

module tb_uart_multi;

    reg clk;
    reg rst;

    // --------------------------------
    // UART 0
    // --------------------------------
    reg  [7:0] tx0_data;
    reg        tx0_start;
    wire       tx0_busy;
    wire [7:0] rx0_data;
    wire       rx0_valid;
    wire       tx0;
    wire       rx0;

    // --------------------------------
    // UART 1
    // --------------------------------
    reg  [7:0] tx1_data;
    reg        tx1_start;
    wire       tx1_busy;
    wire [7:0] rx1_data;
    wire       rx1_valid;
    wire       tx1;
    wire       rx1;

    // --------------------------------
    // UART 2
    // --------------------------------
    reg  [7:0] tx2_data;
    reg        tx2_start;
    wire       tx2_busy;
    wire [7:0] rx2_data;
    wire       rx2_valid;
    wire       tx2;
    wire       rx2;

    // --------------------------------
    // UART 3
    // --------------------------------
    reg  [7:0] tx3_data;
    reg        tx3_start;
    wire       tx3_busy;
    wire [7:0] rx3_data;
    wire       rx3_valid;
    wire       tx3;
    wire       rx3;


    // --------------------------------
    // Loopback connections
    // --------------------------------
    assign rx0 = tx0;
    assign rx1 = tx1;
    assign rx2 = tx2;
    assign rx3 = tx3;


    // --------------------------------
    // 32 MHz Clock
    // --------------------------------
    always #15.625 clk = ~clk;


    // --------------------------------
    // DUT: 4 UART system
    // --------------------------------
    uart_multi_top dut (

        .clk(clk),
        .rst(rst),

        // UART 0
        .tx0_data(tx0_data),
        .tx0_start(tx0_start),
        .tx0_busy(tx0_busy),
        .rx0_data(rx0_data),
        .rx0_valid(rx0_valid),
        .rx0(rx0),
        .tx0(tx0),

        // UART 1
        .tx1_data(tx1_data),
        .tx1_start(tx1_start),
        .tx1_busy(tx1_busy),
        .rx1_data(rx1_data),
        .rx1_valid(rx1_valid),
        .rx1(rx1),
        .tx1(tx1),

        // UART 2
        .tx2_data(tx2_data),
        .tx2_start(tx2_start),
        .tx2_busy(tx2_busy),
        .rx2_data(rx2_data),
        .rx2_valid(rx2_valid),
        .rx2(rx2),
        .tx2(tx2),

                // UART 3
        .tx3_data(tx3_data),
        .tx3_start(tx3_start),
        .tx3_busy(tx3_busy),
        .rx3_data(rx3_data),
        .rx3_valid(rx3_valid),
        .rx3(rx3),
        .tx3(tx3)
    );


    // --------------------------------
    // Test
    // --------------------------------
    initial begin

        clk = 1'b0;
        rst = 1'b1;

        tx0_data  = 8'h00;
        tx1_data  = 8'h00;
        tx2_data  = 8'h00;
        tx3_data  = 8'h00;

        tx0_start = 1'b0;
        tx1_start = 1'b0;
        tx2_start = 1'b0;
        tx3_start = 1'b0;

        // Reset
        #100;

        rst = 1'b0;

        // --------------------------------
        // Send data on all 4 UARTs
        // --------------------------------

        tx0_data  = 8'hAA;
        tx1_data  = 8'hBB;
        tx2_data  = 8'hCC;
        tx3_data  = 8'hDD;

        tx0_start = 1'b1;
        tx1_start = 1'b1;
        tx2_start = 1'b1;
        tx3_start = 1'b1;

        #31.25;

        tx0_start = 1'b0;
        tx1_start = 1'b0;
        tx2_start = 1'b0;
        tx3_start = 1'b0;

        // Wait for all transmissions
#8000000;
        $finish;

    end


    // --------------------------------
    // UART 0 verification
    // --------------------------------
    always @(posedge rx0_valid) begin

        $display("UART0: TX = %h, RX = %h",
                 tx0_data, rx0_data);

        if (rx0_data == tx0_data)
            $display("UART0 PASS");
        else
            $display("UART0 FAIL");

    end


    // --------------------------------
    // UART 1 verification
    // --------------------------------
    always @(posedge rx1_valid) begin

        $display("UART1: TX = %h, RX = %h",
                 tx1_data, rx1_data);

        if (rx1_data == tx1_data)
            $display("UART1 PASS");
        else
            $display("UART1 FAIL");

    end


    // --------------------------------
    // UART 2 verification
    // --------------------------------
    always @(posedge rx2_valid) begin

        $display("UART2: TX = %h, RX = %h",
                 tx2_data, rx2_data);

        if (rx2_data == tx2_data)
            $display("UART2 PASS");
        else
            $display("UART2 FAIL");

    end


    // --------------------------------
    // UART 3 verification
    // --------------------------------
    always @(posedge rx3_valid) begin

        $display("UART3: TX = %h, RX = %h",
                 tx3_data, rx3_data);

        if (rx3_data == tx3_data)
            $display("UART3 PASS");
        else
            $display("UART3 FAIL");

    end

endmodule