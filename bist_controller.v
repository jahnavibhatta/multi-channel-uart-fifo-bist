`timescale 1ns/1ps

module bist_controller (

    input  wire       clk,
    input  wire       rst,

    // UART interface
    output reg [7:0]  tx_data,
    output reg        tx_start,
    input  wire [7:0] rx_data,
    input  wire       rx_valid,

    // BIST result
    output reg        bist_done,
    output reg        bist_pass,
    output reg        bist_fail
);

    reg [2:0] pattern_count;
    reg [7:0] expected_data;
    reg       waiting_for_rx;

    // Test patterns
    function [7:0] test_pattern;
        input [2:0] index;

        begin
            case (index)
                3'd0: test_pattern = 8'hAA;
                3'd1: test_pattern = 8'h55;
                3'd2: test_pattern = 8'hCC;
                3'd3: test_pattern = 8'h33;
                default: test_pattern = 8'h00;
            endcase
        end
    endfunction


    always @(posedge clk) begin

        if (rst) begin

            tx_data       <= 8'h00;
            tx_start      <= 1'b0;

            expected_data <= 8'h00;

            pattern_count <= 3'd0;
            waiting_for_rx <= 1'b0;

            bist_done     <= 1'b0;
            bist_pass     <= 1'b0;
            bist_fail     <= 1'b0;

        end

        else begin

            tx_start <= 1'b0;

            // --------------------------------
            // Send next test pattern
            // --------------------------------
            if (!waiting_for_rx && !bist_done) begin

                tx_data       <= test_pattern(pattern_count);
                expected_data <= test_pattern(pattern_count);

                tx_start      <= 1'b1;
                waiting_for_rx <= 1'b1;

            end


            // --------------------------------
            // Check received data
            // --------------------------------
            if (rx_valid && waiting_for_rx) begin

               if (rx_data == expected_data) begin

    $display("BIST PATTERN = %h, RX = %h : PASS",
             expected_data, rx_data);

    bist_pass <= 1'b1;

end

else begin

    $display("BIST PATTERN = %h, RX = %h : FAIL",
             expected_data, rx_data);

    bist_fail <= 1'b1;

end

                waiting_for_rx <= 1'b0;


                // --------------------------------
                // All 4 patterns tested
                // --------------------------------
                if (pattern_count == 3'd3) begin

                    bist_done <= 1'b1;

                end

                else begin

                    pattern_count <= pattern_count + 1'b1;

                end

            end

        end

    end

endmodule