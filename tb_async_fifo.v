```verilog
`timescale 1ns/1ps

module tb_async_fifo;

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
    initial begin

        wr_clk = 1'b0;
        rd_clk = 1'b0;

        rst   = 1'b1;
        din   = 8'h00;
        wr_en = 1'b0;
        rd_en = 1'b0;

        // -----------------------------
        // Reset
        // -----------------------------
        #100;
        rst = 1'b0;

        // -----------------------------
        // WRITE AA
        // -----------------------------
        @(posedge wr_clk);
        din   = 8'hAA;
        wr_en = 1'b1;

        @(posedge wr_clk);
        wr_en = 1'b0;

        // -----------------------------
        // WRITE BB
        // -----------------------------
        @(posedge wr_clk);
        din   = 8'hBB;
        wr_en = 1'b1;

        @(posedge wr_clk);
        wr_en = 1'b0;

        // -----------------------------
        // WRITE CC
        // -----------------------------
        @(posedge wr_clk);
        din   = 8'hCC;
        wr_en = 1'b1;

        @(posedge wr_clk);
        wr_en = 1'b0;

        // -----------------------------
        // WRITE DD
        // -----------------------------
        @(posedge wr_clk);
        din   = 8'hDD;
        wr_en = 1'b1;

        @(posedge wr_clk);
        wr_en = 1'b0;

        // Wait before reading
        #100;

        // -----------------------------
        // READ 1
        // -----------------------------
        @(posedge rd_clk);
        rd_en = 1'b1;

        @(posedge rd_clk);
        rd_en = 1'b0;

        #10;
        $display("READ DATA = %h", dout);

        // -----------------------------
        // READ 2
        // -----------------------------
        @(posedge rd_clk);
        rd_en = 1'b1;

        @(posedge rd_clk);
        rd_en = 1'b0;

        #10;
        $display("READ DATA = %h", dout);

        // -----------------------------
        // READ 3
        // -----------------------------
        @(posedge rd_clk);
        rd_en = 1'b1;

        @(posedge rd_clk);
        rd_en = 1'b0;

        #10;
        $display("READ DATA = %h", dout);

        // -----------------------------
        // READ 4
        // -----------------------------
        @(posedge rd_clk);
        rd_en = 1'b1;

        @(posedge rd_clk);
        rd_en = 1'b0;

        #10;
        $display("READ DATA = %h", dout);

        #100;

        $finish;

    end

endmodule
```
