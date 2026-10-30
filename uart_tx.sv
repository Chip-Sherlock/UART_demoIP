module uart_tx(clk,rst,start,tx_data_in,tx,tx_active,done_tx);
import mut_def::*;
parameter clk_freq = 50000000; // 50 MHz
parameter baud_rate = 19200; //bits per second
input clk,rst;
input start;
input [7:0] tx_data_in;
output tx;
output tx_active;
output logic done_tx;


localparam clock_divide = (clk_freq/baud_rate); //Determines how many clocks is needed for transmit 1 bit

enum bit [2:0]{ tx_IDLE = 3'b000,
                tx_START = 3'b001,
				tx_DATA = 3'b010,
	        	tx_STOP = 3'b011,
				tx_DONE = 3'b100 
			} tx_STATE,				tx_NEXT;   //tx_STATE for the current state, tx_NEXT for the next one
					 
logic [11:0]        clk_div_reg,			clk_div_next; //store how many clk cycles for the current bit, and next
logic [7:0]         tx_data_reg,			tx_data_next; // tx_data_reg saves data_in, to send correct data even data_in is changed
logic               tx_out_reg,			    tx_out_next; //saves the value of the current bit at tx
logic [2:0]         index_bit_reg,			index_bit_next; //determines which bit is currently transmitted and the next one

assign tx_active = (tx_STATE == tx_DATA); // if current state is tx_DATA, tx_active bit will be = one
assign tx = tx_out_reg;


generate
    case ({m1, m2, m3, m4})

        // =====================================================
        // m1 m2 m3 m4 = 0000
        // Normal implementation
        // =====================================================
        4'b0000: begin : gen_0000
            always_ff @(posedge clk) begin
                if (rst) begin
                    tx_STATE      <= tx_IDLE;
                    clk_div_reg   <= 0;
                    tx_out_reg    <= 0;
                    tx_data_reg   <= 0;
                    index_bit_reg <= 0;
                end
                else begin
                    tx_STATE      <= tx_NEXT;
                    clk_div_reg   <= clk_div_next;
                    tx_out_reg    <= tx_out_next;
                    tx_data_reg   <= tx_data_next;
                    index_bit_reg <= index_bit_next;
                end
            end
        end

        // =====================================================
        // 0001: Mutation 4 - do not reset index_bit_reg
        // =====================================================
        4'b0001: begin : gen_0001
            always_ff @(posedge clk) begin
                if (rst) begin
                    tx_STATE    <= tx_IDLE;
                    clk_div_reg <= 0;
                    tx_out_reg  <= 0;
                    tx_data_reg <= 0;
                    // index_bit_reg <= 0;
                end
                else begin
                    tx_STATE      <= tx_NEXT;
                    clk_div_reg   <= clk_div_next;
                    tx_out_reg    <= tx_out_next;
                    tx_data_reg   <= tx_data_next;
                    index_bit_reg <= index_bit_next;
                end
            end
        end

        // =====================================================
        // 0010: Mutation 3 - do not reset tx_out_reg
        // =====================================================
        4'b0010: begin : gen_0010
            always_ff @(posedge clk) begin
                if (rst) begin
                    tx_STATE      <= tx_IDLE;
                    clk_div_reg   <= 0;
                    // tx_out_reg <= 0;
                    tx_data_reg   <= 0;
                    index_bit_reg <= 0;
                end
                else begin
                    tx_STATE      <= tx_NEXT;
                    clk_div_reg   <= clk_div_next;
                    tx_out_reg    <= tx_out_next;
                    tx_data_reg   <= tx_data_next;
                    index_bit_reg <= index_bit_next;
                end
            end
        end

        // =====================================================
        // 0011: Mutations 3 + 4
        // =====================================================
        4'b0011: begin : gen_0011
            always_ff @(posedge clk) begin
                if (rst) begin
                    tx_STATE    <= tx_IDLE;
                    clk_div_reg <= 0;
                    // tx_out_reg <= 0;
                    tx_data_reg <= 0;
                    // index_bit_reg <= 0;
                end
                else begin
                    tx_STATE      <= tx_NEXT;
                    clk_div_reg   <= clk_div_next;
                    tx_out_reg    <= tx_out_next;
                    tx_data_reg   <= tx_data_next;
                    index_bit_reg <= index_bit_next;
                end
            end
        end

        // =====================================================
        // 0100: Mutation 2 - do not reset clk_div_reg
        // =====================================================
        4'b0100: begin : gen_0100
            always_ff @(posedge clk) begin
                if (rst) begin
                    tx_STATE      <= tx_IDLE;
                    // clk_div_reg <= 0;
                    tx_out_reg    <= 0;
                    tx_data_reg   <= 0;
                    index_bit_reg <= 0;
                end
                else begin
                    tx_STATE      <= tx_NEXT;
                    clk_div_reg   <= clk_div_next;
                    tx_out_reg    <= tx_out_next;
                    tx_data_reg   <= tx_data_next;
                    index_bit_reg <= index_bit_next;
                end
            end
        end

        // =====================================================
        // 0101: Mutations 2 + 4
        // =====================================================
        4'b0101: begin : gen_0101
            always_ff @(posedge clk) begin
                if (rst) begin
                    tx_STATE    <= tx_IDLE;
                    // clk_div_reg <= 0;
                    tx_out_reg  <= 0;
                    tx_data_reg <= 0;
                    // index_bit_reg <= 0;
                end
                else begin
                    tx_STATE      <= tx_NEXT;
                    clk_div_reg   <= clk_div_next;
                    tx_out_reg    <= tx_out_next;
                    tx_data_reg   <= tx_data_next;
                    index_bit_reg <= index_bit_next;
                end
            end
        end

        // =====================================================
        // 0110: Mutations 2 + 3
        // =====================================================
        4'b0110: begin : gen_0110
            always_ff @(posedge clk) begin
                if (rst) begin
                    tx_STATE    <= tx_IDLE;
                    // clk_div_reg <= 0;
                    // tx_out_reg <= 0;
                    tx_data_reg <= 0;
                    index_bit_reg <= 0;
                end
                else begin
                    tx_STATE      <= tx_NEXT;
                    clk_div_reg   <= clk_div_next;
                    tx_out_reg    <= tx_out_next;
                    tx_data_reg   <= tx_data_next;
                    index_bit_reg <= index_bit_next;
                end
            end
        end

        // =====================================================
        // 0111: Mutations 2 + 3 + 4
        // =====================================================
        4'b0111: begin : gen_0111
            always_ff @(posedge clk) begin
                if (rst) begin
                    tx_STATE <= tx_IDLE;
                    // clk_div_reg <= 0;
                    // tx_out_reg <= 0;
                    tx_data_reg <= 0;
                    // index_bit_reg <= 0;
                end
                else begin
                    tx_STATE      <= tx_NEXT;
                    clk_div_reg   <= clk_div_next;
                    tx_out_reg    <= tx_out_next;
                    tx_data_reg   <= tx_data_next;
                    index_bit_reg <= index_bit_next;
                end
            end
        end

        // =====================================================
        // 1000: Mutation 1 - asynchronous active-low reset
        // =====================================================
        4'b1000: begin : gen_1000
            always_ff @(posedge clk or negedge rst) begin
                if (rst) begin
                    tx_STATE      <= tx_IDLE;
                    clk_div_reg   <= 0;
                    tx_out_reg    <= 0;
                    tx_data_reg   <= 0;
                    index_bit_reg <= 0;
                end
                else begin
                    tx_STATE      <= tx_NEXT;
                    clk_div_reg   <= clk_div_next;
                    tx_out_reg    <= tx_out_next;
                    tx_data_reg   <= tx_data_next;
                    index_bit_reg <= index_bit_next;
                end
            end
        end

        // =====================================================
        // 1001: Mutations 1 + 4
        // =====================================================
        4'b1001: begin : gen_1001
            always_ff @(posedge clk or negedge rst) begin
                if (rst) begin
                    tx_STATE    <= tx_IDLE;
                    clk_div_reg <= 0;
                    tx_out_reg  <= 0;
                    tx_data_reg <= 0;
                    // index_bit_reg <= 0;
                end
                else begin
                    tx_STATE      <= tx_NEXT;
                    clk_div_reg   <= clk_div_next;
                    tx_out_reg    <= tx_out_next;
                    tx_data_reg   <= tx_data_next;
                    index_bit_reg <= index_bit_next;
                end
            end
        end

        // =====================================================
        // 1010: Mutations 1 + 3
        // =====================================================
        4'b1010: begin : gen_1010
            always_ff @(posedge clk or negedge rst) begin
                if (rst) begin
                    tx_STATE      <= tx_IDLE;
                    clk_div_reg   <= 0;
                    // tx_out_reg <= 0;
                    tx_data_reg   <= 0;
                    index_bit_reg <= 0;
                end
                else begin
                    tx_STATE      <= tx_NEXT;
                    clk_div_reg   <= clk_div_next;
                    tx_out_reg    <= tx_out_next;
                    tx_data_reg   <= tx_data_next;
                    index_bit_reg <= index_bit_next;
                end
            end
        end

        // =====================================================
        // 1011: Mutations 1 + 3 + 4
        // =====================================================
        4'b1011: begin : gen_1011
            always_ff @(posedge clk or negedge rst) begin
                if (rst) begin
                    tx_STATE    <= tx_IDLE;
                    clk_div_reg <= 0;
                    // tx_out_reg <= 0;
                    tx_data_reg <= 0;
                    // index_bit_reg <= 0;
                end
                else begin
                    tx_STATE      <= tx_NEXT;
                    clk_div_reg   <= clk_div_next;
                    tx_out_reg    <= tx_out_next;
                    tx_data_reg   <= tx_data_next;
                    index_bit_reg <= index_bit_next;
                end
            end
        end

        // =====================================================
        // 1100: Mutations 1 + 2
        // =====================================================
        4'b1100: begin : gen_1100
            always_ff @(posedge clk or negedge rst) begin
                if (rst) begin
                    tx_STATE <= tx_IDLE;
                    // clk_div_reg <= 0;
                    tx_out_reg    <= 0;
                    tx_data_reg   <= 0;
                    index_bit_reg <= 0;
                end
                else begin
                    tx_STATE      <= tx_NEXT;
                    clk_div_reg   <= clk_div_next;
                    tx_out_reg    <= tx_out_next;
                    tx_data_reg   <= tx_data_next;
                    index_bit_reg <= index_bit_next;
                end
            end
        end

        // =====================================================
        // 1101: Mutations 1 + 2 + 4
        // =====================================================
        4'b1101: begin : gen_1101
            always_ff @(posedge clk or negedge rst) begin
                if (rst) begin
                    tx_STATE <= tx_IDLE;
                    // clk_div_reg <= 0;
                    tx_out_reg  <= 0;
                    tx_data_reg <= 0;
                    // index_bit_reg <= 0;
                end
                else begin
                    tx_STATE      <= tx_NEXT;
                    clk_div_reg   <= clk_div_next;
                    tx_out_reg    <= tx_out_next;
                    tx_data_reg   <= tx_data_next;
                    index_bit_reg <= index_bit_next;
                end
            end
        end

        // =====================================================
        // 1110: Mutations 1 + 2 + 3
        // =====================================================
        4'b1110: begin : gen_1110
            always_ff @(posedge clk or negedge rst) begin
                if (rst) begin
                    tx_STATE <= tx_IDLE;
                    // clk_div_reg <= 0;
                    // tx_out_reg <= 0;
                    tx_data_reg   <= 0;
                    index_bit_reg <= 0;
                end
                else begin
                    tx_STATE      <= tx_NEXT;
                    clk_div_reg   <= clk_div_next;
                    tx_out_reg    <= tx_out_next;
                    tx_data_reg   <= tx_data_next;
                    index_bit_reg <= index_bit_next;
                end
            end
        end

        // =====================================================
        // 1111: Mutations 1 + 2 + 3 + 4
        // =====================================================
        4'b1111: begin : gen_1111
            always_ff @(posedge clk or negedge rst) begin
                if (rst) begin
                    tx_STATE <= tx_IDLE;
                    // clk_div_reg <= 0;
                    // tx_out_reg <= 0;
                    tx_data_reg <= 0;
                    // index_bit_reg <= 0;
                end
                else begin
                    tx_STATE      <= tx_NEXT;
                    clk_div_reg   <= clk_div_next;
                    tx_out_reg    <= tx_out_next;
                    tx_data_reg   <= tx_data_next;
                    index_bit_reg <= index_bit_next;
                end
            end
        end

    endcase
endgenerate


always @(*) begin
	tx_NEXT = tx_STATE;
	clk_div_next = clk_div_reg;
	tx_out_next = tx_out_reg;
	tx_data_next = tx_data_reg;
	index_bit_next = index_bit_reg;
	done_tx = 0;                          //mutation(4) stop bit, make it = 1 by default

	case(tx_STATE)

		tx_IDLE: begin
			tx_out_next = 1; //1111111111111111111111111111111111111111111111
			clk_div_next = 0;
			index_bit_next = 0;
			if(start == 1) begin
				tx_data_next = tx_data_in;
				tx_NEXT = tx_START;
			end
			else begin
				tx_NEXT = tx_IDLE;
			end
		end

		tx_START: begin
			tx_out_next = 0; //1111111111111111111111111111111111111111111111(0) this zero is the flag for the reciver
			if(clk_div_reg < clock_divide-1) begin clk
				clk_div_next = clk_div_reg + 1'b1;
				tx_NEXT = tx_START;
			end
			else begin
				clk_div_next = 0;
				tx_NEXT = tx_DATA;
			end
		end

		tx_DATA: begin
			tx_out_next = tx_data_reg[index_bit_reg];//7-  

			if(clk_div_reg < clock_divide-1) begin
				clk_div_next = clk_div_reg + 1'b1;
				tx_NEXT = tx_DATA;
			end

			else begin

				clk_div_next = 0;

				if(index_bit_reg < 7) begin
					index_bit_next = index_bit_reg + 1'b1;
					tx_NEXT = tx_DATA;
				end

				else begin
					index_bit_next = 0;  // make it 7 to start from the last bit
					tx_NEXT = tx_STOP; 
				end

			end
		end

		tx_STOP: begin
			tx_out_next = 1;
			if(clk_div_reg < clock_divide-1) begin
				clk_div_next = clk_div_reg + 1'b1;
				tx_NEXT = tx_STOP;
			end
			else begin
				clk_div_next = 0;
				tx_NEXT = tx_DONE;
			end
		end

		tx_DONE: begin
			done_tx = 1;
			tx_NEXT = tx_IDLE;
		end

		default: tx_NEXT = tx_IDLE;
	endcase
end

endmodule 

