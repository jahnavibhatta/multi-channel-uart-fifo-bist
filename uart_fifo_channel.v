`timescale 1ns/1ps

module uart_fifo_channel (

    input  wire       clk,
    input  wire       rst,
    input  wire       baud_tick,

    input  wire [7:0] tx_data,
    input  wire       tx_start,

    output wire       tx_busy,

    input  wire       rx,
    output wire [7:0] rx_data,
    output wire       rx_valid,

    output wire       tx
);

    // --------------------------------
    // FIFO signals
    // --------------------------------

    wire [7:0] fifo_dout;
    wire       fifo_full;
    wire       fifo_empty;

    reg        fifo_rd_en;

    // --------------------------------
    // State machine
    // --------------------------------

    reg [1:0] state;

    localparam IDLE     = 2'd0;
    localparam READ_FIFO = 2'd1;
    localparam START_TX  = 2'd2;

    // --------------------------------
    // UART start signal
    // --------------------------------

    reg uart_tx_start;

    // --------------------------------
    // FIFO
    // --------------------------------

    async_fifo #(
        .DATA_WIDTH(8),
        .DEPTH(16)
    ) tx_fifo (

        .wr_clk(clk),
        .rd_clk(clk),
        .rst(rst),

        .din(tx_data),

        .wr_en(tx_start && !fifo_full),

        .rd_en(fifo_rd_en),

        .dout(fifo_dout),

        .full(fifo_full),
        .empty(fifo_empty)
    );

    // --------------------------------
    // FIFO → UART CONTROL
    // --------------------------------

    always @(posedge clk) begin

        if (rst) begin

            state        <= IDLE;
            fifo_rd_en   <= 1'b0;
            uart_tx_start <= 1'b0;

        end

        else begin

            // Default values
            fifo_rd_en    <= 1'b0;
            uart_tx_start <= 1'b0;

            case (state)

                // -------------------------
                // WAIT FOR FIFO DATA
                // -------------------------
                IDLE: begin

                    if (!fifo_empty && !tx_busy) begin

                        fifo_rd_en <= 1'b1;

                        state <= READ_FIFO;

                    end

                end


                // -------------------------
                // FIFO DATA NOW AVAILABLE
                // -------------------------
                READ_FIFO: begin

                    state <= START_TX;

                end


                // -------------------------
                // START UART
                // -------------------------
                START_TX: begin

                    if (!tx_busy) begin

                        uart_tx_start <= 1'b1;

                        state <= IDLE;

                    end

                end

                default: begin

                    state <= IDLE;

                end

            endcase

        end

    end

    // --------------------------------
    // UART TRANSMITTER
    // --------------------------------

    uart_tx transmitter (

        .clk       (clk),
        .rst       (rst),
        .baud_tick (baud_tick),

        .tx_data   (fifo_dout),
        .tx_start  (uart_tx_start),
        .tx_busy   (tx_busy),

        .tx        (tx)
    );

    // --------------------------------
    // UART RECEIVER
    // --------------------------------

    uart_rx receiver (

        .clk       (clk),
        .rst       (rst),
        .baud_tick (baud_tick),

        .rx        (rx),
        .rx_data   (rx_data),
        .rx_valid  (rx_valid)
    );

endmodule