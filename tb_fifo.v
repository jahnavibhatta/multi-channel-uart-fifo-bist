


`timescale 1ns/1ps

module tb_fifo;

    parameter DATA_WIDTH = 8;
    parameter DEPTH = 16;

    reg wr_clk;
    reg rd_clk;
    reg rst;

    reg [DATA_WIDTH-1:0] din;
    reg wr_en;
    reg rd_en;

    wire [DATA_WIDTH-1:0] dout;
    wire full;
    wire empty;

    // --------------------------------
    // FIFO DUT
    // --------------------------------
    async_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) dut (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .rst(rst),
        .din(din),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    // --------------------------------
    // Write clock = 32 MHz
    // --------------------------------
    always #15.625 wr_clk = ~wr_clk;

    // --------------------------------
    // Read clock = 25 MHz
    // --------------------------------
    always #20 rd_clk = ~rd_clk;

    // --------------------------------
    // Test
    // --------------------------------
    integer i;

    initial begin

        wr_clk = 1'b0;
        rd_clk = 1'b0;

        rst   = 1'b1;
        din   = 8'h00;
        wr_en = 1'b0;
        rd_en = 1'b0;

        // --------------------------------
        // RESET
        // --------------------------------
        #100;
        rst = 1'b0;

        $display("================================");
        $display("FIFO TEST START");
        $display("================================");

        // --------------------------------
        // WRITE 16 DATA VALUES
        // 00 to 0F
        // --------------------------------
        for (i = 0; i < 16; i = i + 1) begin

            @(negedge wr_clk);

            din   = i;
            wr_en = 1'b1;

            @(posedge wr_clk);

            #1;

            $display("WRITE DATA = %h", din);

            wr_en = 1'b0;

        end

        // Give FIFO time to update
        #50;

        // --------------------------------
        // CHECK FULL
        // --------------------------------
        if (full == 1'b1)
            $display("FIFO FULL TEST = PASS");
        else
            $display("FIFO FULL TEST = FAIL");

        // --------------------------------
        // READ 16 DATA VALUES
        // --------------------------------
        for (i = 0; i < 16; i = i + 1) begin

            @(negedge rd_clk);

            rd_en = 1'b1;

            @(posedge rd_clk);

            #1;

            $display("READ DATA = %h", dout);

            rd_en = 1'b0;

        end

        // Give FIFO time to update
        #50;

        // --------------------------------
        // CHECK EMPTY
        // --------------------------------
        if (empty == 1'b1)
            $display("FIFO EMPTY TEST = PASS");
        else
            $display("FIFO EMPTY TEST = FAIL");

        $display("================================");
        $display("FIFO TEST COMPLETE");
        $display("================================");

        #100;

        $finish;

    end

endmodule
