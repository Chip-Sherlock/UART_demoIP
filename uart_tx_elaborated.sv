package mut_def;
parameter m0=0; //active reset mutation 
parameter m1=0;
parameter m2=1;
parameter m3=1;
parameter m4=0;
parameter m5=0;
parameter m6=0;
parameter m7=0;
parameter m8=0;
parameter m9=0;
parameter m10=0;
parameter m11=0;
parameter m12=0;
parameter m13=0;
parameter m14=0;
parameter m15=0;
parameter m16=0;
parameter m17=0;
parameter m18=1;
parameter m19=1;
parameter m20=0;
endpackage
module uart_tx__3223647841431570343(clk,rst,start,tx_data_in,tx,tx_active,done_tx);
import mut_def::*;
parameter clk_freq=50000000; // 50 MHz
parameter baud_rate=19200; //bits per second
input clk,rst;
input start;
input [7:0] tx_data_in;
output tx;
output tx_active;
output logic done_tx;
//////////////////////////! i could mutate the baud to do some mis match 
// Mutation 6: double the divider count, reducing the baud rate by half.
localparam integer clock_divide=2604;
enum bit [2:0]{ tx_IDLE = 3'b000,
                tx_START = 3'b001,
				tx_DATA = 3'b010,
	        	tx_STOP = 3'b011,
				tx_DONE = 3'b100 
			} tx_STATE,				tx_NEXT;   //tx_STATE for the current state, tx_NEXT for the next one
					 
// Counter width supports the longest combination: doubled divider (m6) and
// three bit-period STOP interval (m11).
localparam integer MAX_CLOCK_DIVIDE=5208;
localparam integer CLK_DIV_WIDTH=14;
logic [CLK_DIV_WIDTH-1:0] clk_div_reg, clk_div_next; // Current and next bit-cycle counters.
logic [7:0]         tx_data_reg,			tx_data_next; // tx_data_reg saves data_in, to send correct data even data_in is changed
logic               tx_out_reg,			    tx_out_next; //saves the value of the current bit at tx
logic [2:0]         index_bit_reg,			index_bit_next; //determines which bit is currently transmitted and the next one
assign tx_active = (tx_STATE == tx_DATA); // if current state is tx_DATA, tx_active bit will be = one
assign tx = tx_out_reg;
generate
;
endgenerate
// UART TX combinational next-state logic selected entirely at elaboration time.
// Selector order: {m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15}.
// Every one of the 2,048 combinations has its own complete always @(*) block.
//
// Mutation 5 : Ignore data capture when start is asserted in IDLE.
// Mutation 6 : Drive TX low in IDLE instead of high.
// Mutation 7 : Drop bit 0 during data capture (assign tx_data_in[7:1] to 8 bits).
// Mutation 8 : Drive the START bit high instead of low.
// Mutation 9: Extend START duration to two bit periods.
// Mutation 10: Transmit data bits in reverse index order.
// Mutation 11: Extend STOP duration to three bit periods.
// Mutation 12: Shorten each DATA bit period by one clock cycle.
// Mutation 13: Drive STOP low instead of the UART idle-high level.
// Mutation 14: Keep done_tx asserted in every state.
// Mutation 15: Accept a new data word while START/DATA is in progress.
generate
if (1) begin : gen_mut_00000000000
            // Enabled mutations: none (normal implementation).
            always @(*) begin
                tx_NEXT        = tx_STATE;
                clk_div_next   = clk_div_reg;
                tx_out_next    = tx_out_reg;
                tx_data_next   = tx_data_reg;
                index_bit_next = index_bit_reg;
                done_tx        = 1'b0; // Default: done is deasserted.
                case (tx_STATE)
                    tx_IDLE: begin
                        tx_out_next = 1'b1; // Normal UART idle level.
                        clk_div_next = '0;
                        index_bit_next = 3'd0;
                        if (start) begin
                            tx_data_next = tx_data_in;
                            tx_NEXT = tx_START;
                        end
                        else begin
                            tx_NEXT = tx_IDLE;
                        end
                    end
                    tx_START: begin
                        tx_out_next = 1'b0; // Normal UART START bit.
                        if (clk_div_reg < clock_divide-1) begin
                            clk_div_next = clk_div_reg + 1'b1;
                            tx_NEXT = tx_START;
                        end
                        else begin
                            clk_div_next = '0;
                            tx_NEXT = tx_DATA;
                        end
                    end
                    tx_DATA: begin
                        tx_out_next = tx_data_reg[index_bit_reg];
                        if (clk_div_reg < clock_divide-1) begin
                            clk_div_next = clk_div_reg + 1'b1;
                            tx_NEXT = tx_DATA;
                        end
                        else begin
                            clk_div_next = '0;
                            if (index_bit_reg < 7) begin
                                index_bit_next = index_bit_reg + 1'b1;
                                tx_NEXT = tx_DATA;
                            end
                            else begin
                                index_bit_next = 3'd0;
                                tx_NEXT = tx_STOP;
                            end
                        end
                    end
                    tx_STOP: begin
                        tx_out_next = 1'b1; // Normal UART STOP bit.
                        if (clk_div_reg < clock_divide-1) begin
                            clk_div_next = clk_div_reg + 1'b1;
                            tx_NEXT = tx_STOP;
                        end
                        else begin
                            clk_div_next = '0;
                            tx_NEXT = tx_DONE;
                        end
                    end
                    tx_DONE: begin
                        done_tx = 1'b1;
                        tx_NEXT = tx_IDLE;
                    end
                    default: tx_NEXT = tx_IDLE;
                endcase
            end
        end
endgenerate
endmodule 
