`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Armanda Byberi
// 
// Create Date: 12/25/2025 05:55:01 PM
// Design Name: Serial receiver 
// Module Name: serial_receiver_data
// Project Name: Serial receiver 
// Description: This project designs a finite state machine with a datapath to receive serial data bytes. Each byte starts 
// with a start bit, followed by 8 data bits (LSB first), and ends with a stop bit. The FSM detects the start bit, collects 
// the data bits, and checks the stop bit. When a byte is received correctly, the system signals completion and outputs the
// received byte.
// Revision: 1.8
//
//////////////////////////////////////////////////////////////////////////////////

module serial_receiver_data(
    input wire clk,
    input wire reset,
    input wire in,
    output reg done,
    output wire [7:0] out_bytes
    );
    
    localparam IDLE = 3'b000, START = 3'b001, RECEIVE = 3'b010, WAIT = 3'b100, STOP = 3'b111;
    reg [2:0] state, next_state;
    reg [3:0]  count;
    reg [7:0]  out;
    // State memory 
    always @(posedge clk) begin 
        if (reset)
            state <= IDLE;
        else 
            state <= next_state;
	end
	
   // Next state logic 
   always @(*) begin
       case (state)
            IDLE:    next_state = (in) ? IDLE : START;
            START:   next_state = (in) ? RECEIVE : WAIT; // not sure? maybe next_state = RECEIVE;
            RECEIVE: begin 
                        if (count==8) begin
                            if (in) 
                                next_state = STOP;
                             else
                                next_state = WAIT;
                             end
                        else
                            next_state = RECEIVE;
                       end 
                             
                                
            WAIT:    next_state = (in) ? IDLE : WAIT;
            STOP:    next_state = (in) ? IDLE : START;
       endcase              
   end
   
   // counter logic 
   always @(posedge clk) begin
		if (reset) begin
			done <= 0;
			count <= 0;
		end
		else begin
			case(next_state) 
				RECEIVE : begin
					       done  <= 0;
					       count <= count + 1;
				           end
				STOP : begin
					       done <= 1;
					       count <= 0;
				           end
				default : begin
        					done <= 0;
		          			count <= 0;
				          end
			endcase
		end
	end
    // New: Datapath to latch input bits.
    always @(posedge clk) begin
    	if (reset) out <= 0;
    	else if (next_state == RECEIVE)
    		out[count] <= in;
    end

    assign out_bytes = (done) ? out : 8'b0; 
    
endmodule
