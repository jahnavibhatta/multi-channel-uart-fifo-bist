module uart_rx (
    input  wire       clk,
    input  wire       rst,
    input  wire       baud_tick,
    input  wire       rx,

    output reg [7:0]  rx_data,
    output reg        rx_valid
);

    reg [3:0] sample_count;
    reg [3:0] bit_count;
    reg [7:0] shift_reg;
    reg       receiving;

    always @(posedge clk) begin

        if (rst) begin

            sample_count <= 4'd0;
            bit_count    <= 4'd0;
            shift_reg    <= 8'd0;
            rx_data      <= 8'd0;
            rx_valid     <= 1'b0;
            receiving    <= 1'b0;

        end

        else begin

            // rx_valid is a one-clock pulse
            rx_valid <= 1'b0;

            // --------------------------------
            // Waiting for START bit
            // --------------------------------
            if (!receiving) begin

                if (rx == 1'b0) begin

                    receiving    <= 1'b1;
                    sample_count <= 4'd0;
                    bit_count    <= 4'd0;

                end

            end

            // --------------------------------
            // Receiving UART frame
            // --------------------------------
            else if (baud_tick) begin

                sample_count <= sample_count + 1'b1;

                // --------------------------------
                // Check START bit at middle
                // --------------------------------
                if (bit_count == 4'd0 &&
                    sample_count == 4'd7) begin

                    if (rx == 1'b0) begin

                        // Valid START bit
                        sample_count <= 4'd0;
                        bit_count    <= 4'd1;

                    end

                    else begin

                        // False start
                        receiving <= 1'b0;

                    end

                end

                // --------------------------------
                // Sample DATA bits
                // --------------------------------
                else if (bit_count >= 4'd1 &&
                         bit_count <= 4'd8 &&
                         sample_count == 4'd15) begin

                    sample_count <= 4'd0;

                    // Store data bit
                    shift_reg <= {rx, shift_reg[7:1]};

                    bit_count <= bit_count + 1'b1;

                end

                // --------------------------------
                // Sample STOP bit
                // --------------------------------
                else if (bit_count == 4'd9 &&
                         sample_count == 4'd15) begin

                    receiving <= 1'b0;
                    sample_count <= 4'd0;

                    rx_data <= shift_reg;
                    rx_valid <= 1'b1;

                end

            end

        end

    end

endmodule