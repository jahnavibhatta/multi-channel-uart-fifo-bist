module baud_generator (
    input  wire       clk,       // 32 MHz system clock
    input  wire       rst,       // active-high reset
    input  wire [15:0] divisor,  // baud-rate divider
    output reg        baud_tick
);

    reg [15:0] count;

    always @(posedge clk) begin

        if (rst) begin
            count     <= 16'd0;
            baud_tick <= 1'b0;
        end

        else begin

            if (count == divisor - 1) begin
                count     <= 16'd0;
                baud_tick <= 1'b1;
            end

            else begin
                count     <= count + 1'b1;
                baud_tick <= 1'b0;
            end

        end

    end

endmodule