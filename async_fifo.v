module async_fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wire                  wr_clk,
    input  wire                  rd_clk,
    input  wire                  rst,

    input  wire [DATA_WIDTH-1:0] din,
    input  wire                  wr_en,
    input  wire                  rd_en,

    output reg  [DATA_WIDTH-1:0] dout,
    output wire                  full,
    output wire                  empty
);

    localparam ADDR_WIDTH = 4;

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    reg [ADDR_WIDTH:0] wr_ptr;
    reg [ADDR_WIDTH:0] rd_ptr;

    assign empty = (wr_ptr == rd_ptr);

    assign full =
        (wr_ptr[ADDR_WIDTH] != rd_ptr[ADDR_WIDTH]) &&
        (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]);

    // WRITE SIDE
    always @(posedge wr_clk) begin

        if (rst) begin
            wr_ptr <= 0;
        end

        else if (wr_en && !full) begin

            mem[wr_ptr[ADDR_WIDTH-1:0]] <= din;

            wr_ptr <= wr_ptr + 1'b1;

        end
    end

    // READ SIDE
    always @(posedge rd_clk) begin

        if (rst) begin
            rd_ptr <= 0;
            dout   <= 0;
        end

        else if (rd_en && !empty) begin

            dout <= mem[rd_ptr[ADDR_WIDTH-1:0]];

            rd_ptr <= rd_ptr + 1'b1;

        end
    end

endmodule