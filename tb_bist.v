`timescale 1ns/1ps

module tb_bist;

    reg clk;
    reg rst;

    // --------------------------------
    // BIST signals
    // --------------------------------
    wire [7:0] bist_tx_data;
    wire       bist_tx_start;

    wire [7:0] bist_rx_data;
    wire       bist_rx_valid;

    wire       bist_done;
    wire       bist_pass;
    wire       bist_fail;

    // --------------------------------
    // UART signals
    // --------------------------------
    wire       tx;
    wire       rx;

    wire       tx_busy;

    wire       baud_tick;

    // Loopback
    assign rx = tx;

    // --------------------------------
    // 32 MHz clock
    // --------------------------------
    always #15.625 clk = ~clk;


    // --------------------------------
    // Baud Generator
    // 9600 baud
    // --------------------------------
    baud_generator baud_gen (

        .clk       (clk),
        .rst       (rst),
        .divisor   (16'd208),
        .baud_tick (baud_tick)

    );


    // --------------------------------
    // BIST Controller
    // --------------------------------
    bist_controller bist (

        .clk        (clk),
        .rst        (rst),

        .tx_data    (bist_tx_data),
        .tx_start   (bist_tx_start),

        .rx_data    (bist_rx_data),
        .rx_valid   (bist_rx_valid),

        .bist_done  (bist_done),
        .bist_pass  (bist_pass),
        .bist_fail  (bist_fail)

    );


    // --------------------------------
    // UART FIFO Channel
    // --------------------------------
    uart_fifo_channel uart0 (

        .clk       (clk),
        .rst       (rst),
        .baud_tick (baud_tick),

        .tx_data   (bist_tx_data),
        .tx_start  (bist_tx_start),

        .tx_busy   (tx_busy),

        .rx        (rx),

        .rx_data   (bist_rx_data),
        .rx_valid  (bist_rx_valid),

        .tx        (tx)

    );


    // --------------------------------
    // Test
    // --------------------------------
    initial begin

        clk = 1'b0;
        rst = 1'b1;

        #100;

        rst = 1'b0;

        $display("================================");
        $display("BIST TEST START");
        $display("================================");

        // Wait for BIST to complete
        wait (bist_done == 1'b1);

        #100;

        if (bist_pass && !bist_fail)
            $display("BIST RESULT = PASS");
        else
            $display("BIST RESULT = FAIL");

        $display("================================");
        $display("BIST TEST COMPLETE");
        $display("================================");

        #100;

        $finish;

    end

endmodule