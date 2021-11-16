`timescale 1ns / 1ns

// top level module
module restoringDivisor(Clock, Resetn, Go, Divisor, Dividend, Quotient, Remainder);
    input Clock;
    input Resetn;
    input Go;
    input [3:0] Dividend;
    input [3:0] Divisor;
    output [3:0] Quotient;
    output [3:0] Remainder;
    
    wire MSB_A;
    wire MSB_X;
    
    wire ld_x, ld_y, ld_a, ld_q, ld_r;
    wire ld_alu_out;
    wire [1:0] alu_select_a, alu_select_b;
    wire [1:0] alu_op;
    
    control C0(
        .clk(Clock),
        .resetn(Resetn),

        .go(Go),
        .msb_a(MSB_A),
        .msb_x(MSB_X),
        
        .ld_alu_out(ld_alu_out),
        .ld_x(ld_x),
        .ld_y(ld_y),
        .ld_a(ld_a),
        .ld_q(ld_q),
        .ld_r(ld_r),
        
        .alu_select_a(alu_select_a),
        .alu_select_b(alu_select_b),
        .alu_op(alu_op)
    );

    datapath D0(
        .clk(Clock),
        .resetn(Resetn),

        .msb_a(MSB_A),
        .msb_x(MSB_X),

        .ld_alu_out(ld_alu_out),
        .ld_x(ld_x),
        .ld_y(ld_y),
        .ld_a(ld_a),
        .ld_q(ld_q),
        .ld_r(ld_r),

        .alu_select_a(alu_select_a),
        .alu_select_b(alu_select_b),
        .alu_op(alu_op),

        .divisor(Divisor),
        .dividend(Dividend),
        .quotient(Quotient),
        .remainder(Remainder)
    );
endmodule  // end restoringDivisor


// control path =============================================================
module control(
    input clk,
    input resetn,
    input go,

    input msb_a,
    input msb_x,

    output reg ld_x, ld_y, ld_a, ld_q, ld_r,
    output reg ld_alu_out,
    output reg [1:0] alu_select_a, alu_select_b,
    output reg [1:0] alu_op
    );
    
    reg [5:0] current_state, next_state;
    reg [1:0] counter;
    
    localparam  S_WAIT          = 5'd0,
                S_LOAD          = 5'd1,
                S_SHIFT_X       = 5'd2,
                S_SHIFT_A       = 5'd3,
                S_SET_LSB_A     = 5'd4,
                S_SUB_DIVISOR   = 5'd5,
                S_ADD_DIVISOR   = 5'd6,
                S_SET_LSB_X     = 5'd7,
                S_COUNT         = 5'd8,
                S_DISPLAY       = 5'd9,
                S_BUFFER        = 5'd10;
    
    // state table: next state logic
    always @(*)
    begin: state_table
        case (current_state)
            S_WAIT:         next_state = go ? S_LOAD : S_WAIT;
            S_LOAD:         next_state = S_SHIFT_X;
            S_SHIFT_X:      next_state = S_SHIFT_A;
            S_SHIFT_A:      next_state = msb_x ? S_SET_LSB_A : S_SUB_DIVISOR;
            S_SET_LSB_A:    next_state = S_SUB_DIVISOR;
            S_SUB_DIVISOR:  next_state = S_BUFFER;
            S_BUFFER:       next_state = msb_a ? S_ADD_DIVISOR : S_SET_LSB_X;
            S_ADD_DIVISOR:  next_state = S_COUNT;
            S_SET_LSB_X:    next_state = S_COUNT;
            S_COUNT:        next_state = (counter == 3) ? S_DISPLAY : S_SHIFT_X;
            S_DISPLAY:      next_state = S_WAIT;
            default: next_state = S_WAIT;
        endcase
    end  // state_table

    // output datapath control signals
    always @(*)
    begin: enable_signals
        // Default signals to 0
        ld_x = 1'b0;
        ld_y = 1'b0;
        ld_a = 1'b0;
        ld_q = 1'b0;
        ld_r = 1'b0;
        ld_alu_out = 1'b0;
        alu_select_a = 2'b00;
        alu_select_b = 2'b00;
        alu_op       = 2'b00;
        
        case (current_state)
            S_LOAD: begin
                ld_x = 1'b1;
                ld_y = 1'b1;
                ld_a = 1'b1;
                end
            S_SHIFT_X: begin
                ld_alu_out = 1'b1;
                ld_x = 1'b1;

                alu_select_a = 2'b00;
                alu_op = 2'b00;
                end
            S_SHIFT_A: begin
                ld_alu_out = 1'b1;
                ld_a = 1'b1;

                alu_select_a = 2'b10;
                alu_op = 2'b00;
                end
            S_SET_LSB_A: begin
                ld_alu_out = 1'b1;
                ld_a = 1'b1;
                
                alu_select_a = 2'b10;
                alu_op = 2'b11;
                end
            S_SUB_DIVISOR: begin
                ld_alu_out = 1'b1;
                ld_a = 1'b1;
                
                alu_select_a = 2'b10;
                alu_select_b = 2'b01;
                
                alu_op = 2'b10;
                end
            S_ADD_DIVISOR: begin
                ld_alu_out = 1'b1;
                ld_a = 1'b1;
                
                alu_select_a = 2'b10;
                alu_select_b = 2'b01;
                
                alu_op = 2'b01;
                end
            S_SET_LSB_X: begin
                ld_alu_out = 1'b1;
                ld_x = 1'b1;
                
                alu_select_a = 2'b00;
                alu_op = 2'b11;
                end
            S_DISPLAY: begin
                ld_q = 1'b1;
                ld_r = 1'b1;
                end
            // default: not needed
            endcase
    end  // enable_signals
    
    // current_state registers
    always @(posedge clk)
    begin: state_FFs
        if (!resetn) begin
            current_state <= S_WAIT;
            counter <= 2'd0;
            end
        else
            current_state <= next_state;
        
        if (current_state == S_COUNT)
            counter <= counter + 1;

    end  // state_FFs
endmodule  // end control


// data path ============================================================
module datapath(
    input clk,
    input resetn,
    input [3:0] divisor,
    input [3:0] dividend,
    
    input ld_x, ld_y, ld_a, ld_q, ld_r,
    input ld_alu_out,
    input [1:0] alu_select_a, alu_select_b,
    input [1:0] alu_op,
    
    output reg msb_a,
    output reg msb_x,
    output reg [3:0] remainder,
    output reg [3:0] quotient
    );
    
    // input registers
    reg [3:0] x;
    reg [3:0] y;
    reg [4:0] a;
    always @(*) begin
        msb_a = a[4];
    end

    // ALU registers
    reg [4:0] alu_out;  // output of the alu
    reg [4:0] alu_a, alu_b;  // alu input muxes
    
    // logic for data registers
    always @(posedge clk) begin
        if (!resetn) begin
            x <= 4'b0;
            y <= 4'b0;
            a <= 5'b0;
        end
        else begin
            if (ld_x)
                x <= ld_alu_out ? alu_out : dividend;
            if (ld_y)
                y <= divisor;
            if (ld_a)
                a <= ld_alu_out ? alu_out : 5'b0;
        end
        msb_x <= x[3];
    end
    
    // logic for result registers
    always @(posedge clk) begin
        if (!resetn) begin
            remainder <= 4'b0;
            quotient <= 4'b0;
        end
        else begin
            if (ld_r)
                remainder <= a;
            if (ld_q)
                quotient <= x;
        end
    end
    
    // ALU input multiplexers
    always @(*)
    begin
        case (alu_select_a)
            2'd0:
                alu_a = x;
            2'd1:
                alu_a = y;
            2'd2:
                alu_a = a;
            default: alu_a = 5'b0;
        endcase
        case (alu_select_b)
            2'd0:
                alu_b = x;
            2'd1:
                alu_b = y;
            2'd2:
                alu_b = a;
            default: alu_b = 5'b0;
        endcase
    end
    
    // the arithmetic logic unit
    always @(*)
    begin: ALU
        case (alu_op)
            2'd0:
                alu_out = alu_a << 1;
            2'd1:
                alu_out = alu_a + alu_b;
            2'd2:
                alu_out = alu_a - alu_b;
            2'd3:
                alu_out = {alu_a[4:1], 1'b1};
            default: alu_out = 5'b0;
        endcase
    end
endmodule  // end datapath
