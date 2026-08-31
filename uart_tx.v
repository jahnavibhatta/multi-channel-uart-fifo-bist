module uart_tx (
    input  wire       clk,
    input  wire       rst,
    input  wire       baud_tick,
    input  wire [7:0] tx_data,
    input  wire       tx_start,

    output reg        tx,
    output reg        tx_busy
);

    reg [9:0] shift_reg;
    reg [3:0] tick_count;
    reg [3:0] bit_count;

    always @(posedge clk) begin

        if (rst) begin
            shift_reg <= 10'b1111111111;
            tick_count <= 4'd0;
            bit_count <= 4'd0;
            tx <= 1'b1;
            tx_busy <= 1'b0;
        end

        else begin

            if (tx_start && !tx_busy) begin

                // Stop + data + start
                shift_reg <= {1'b1, tx_data, 1'b0};

                tick_count <= 4'd0;
                bit_count <= 4'd0;

                tx_busy <= 1'b1;
                tx <= 1'b0;

            end

            else if (tx_busy && baud_tick) begin

                if (tick_count == 4'd15) begin

                    tick_count <= 4'd0;

                    if (bit_count == 4'd9) begin

                        tx_busy <= 1'b0;
                        tx <= 1'b1;

                    end

                    else begin

                        bit_count <= bit_count + 1'b1;
                        shift_reg <= {1'b1, shift_reg[9:1]};
                        tx <= shift_reg[1];

                    end

                end

                else begin
                    tick_count <= tick_count + 1'b1;
                end

            end

        end

    end

endmodule