
`timescale 1ns/1ps

module tb_uart_fifo_channel;

    reg clk;
    reg rst;

    reg [7:0] tx_data;
    reg       tx_start;

    wire      tx_busy;

    wire [7:0] rx_data;
    wire       rx_valid;

    wire tx;
    wire rx;

    wire baud_tick;

    integer rx_count;


    // --------------------------------
    // Baud Generator
    // --------------------------------

    baud_generator baud_gen (

        .clk       (clk),
        .rst       (rst),
        .divisor   (16'd208),
        .baud_tick (baud_tick)

    );


    // --------------------------------
    // UART FIFO CHANNEL
    // --------------------------------

    uart_fifo_channel dut (

        .clk       (clk),
        .rst       (rst),
        .baud_tick (baud_tick),

        .tx_data   (tx_data),
        .tx_start  (tx_start),
        .tx_busy   (tx_busy),

        .rx        (rx),
        .rx_data   (rx_data),
        .rx_valid  (rx_valid),

        .tx        (tx)

    );


    // --------------------------------
    // LOOPBACK
    // TX → RX
    // --------------------------------

    assign rx = tx;


    // --------------------------------
    // 32 MHz CLOCK
    // --------------------------------

    always #15.625 clk = ~clk;


    // --------------------------------
    // TEST
    // --------------------------------

    initial begin

        clk = 1'b0;
        rst = 1'b1;

        tx_data  = 8'h00;
        tx_start = 1'b0;

        rx_count = 0;


        // --------------------------------
        // RESET
        // --------------------------------

        #100;

        rst = 1'b0;

        $display("================================");
        $display("UART FIFO CHANNEL TEST START");
        $display("================================");


        // --------------------------------
        // SEND AA
        // --------------------------------

        @(negedge clk);

        tx_data  = 8'hAA;
        tx_start = 1'b1;

        @(negedge clk);

        tx_start = 1'b0;

        $display("TX DATA = AA");


        // --------------------------------
        // SEND BB
        // --------------------------------

        @(negedge clk);

        tx_data  = 8'hBB;
        tx_start = 1'b1;

        @(negedge clk);

        tx_start = 1'b0;

        $display("TX DATA = BB");


        // --------------------------------
        // SEND CC
        // --------------------------------

        @(negedge clk);

        tx_data  = 8'hCC;
        tx_start = 1'b1;

        @(negedge clk);

        tx_start = 1'b0;

        $display("TX DATA = CC");


        // --------------------------------
        // SEND DD
        // --------------------------------

        @(negedge clk);

        tx_data  = 8'hDD;
        tx_start = 1'b1;

        @(negedge clk);

        tx_start = 1'b0;

        $display("TX DATA = DD");


        // --------------------------------
        // WAIT FOR UART TRANSMISSION
        // --------------------------------

#8000000;

        $display("================================");
        $display("UART FIFO CHANNEL TEST COMPLETE");
        $display("================================");

        $finish;

    end


    // --------------------------------
    // RECEIVE VERIFICATION
    // --------------------------------

    always @(posedge rx_valid) begin

        #1;

        rx_count = rx_count + 1;

        $display("RX DATA = %h", rx_data);

        if (rx_data == 8'hAA)
            $display("AA PASS");

        else if (rx_data == 8'hBB)
            $display("BB PASS");

        else if (rx_data == 8'hCC)
            $display("CC PASS");

        else if (rx_data == 8'hDD)
            $display("DD PASS");

        else
            $display("RX DATA FAIL");

    end

endmodule
