`timescale 1ns/10ps
module GSIM ( clk, reset, in_en, b_in, out_valid, x_out);
input   clk ;
input   reset ;
input   in_en;
output  out_valid;
input   [15:0]  b_in;
output  [31:0]  x_out;
//==================================================================//IO
reg signed [15:0] b_in_reg[0:15];
reg [15:0]counter;
wire signed[31:0] so[0:5];
reg signed [32:0] time6_in1,time6_in2,time13_in1,time13_in2,plus1,plus2;
wire signed [32:0]plus3;
reg [3:0] count ;

always @* begin
    time13_in1=so[0];
    time13_in2=so[3];
    time6_in1= so[1];
    time6_in2= so[4];
    plus1= so[2];
    plus2= so[5];
    case(count)
    4'b0000: begin time13_in2 = 0; time6_in2 = 0;plus2=0; end
    4'b0001: begin time6_in2 =0; plus2=0;end
    4'b0010: begin  plus2 =0; end
    4'b1101: begin plus1 =0;end
    4'b1110: begin time6_in1 = 0;plus1 =0;end
    4'b1111: begin time13_in1 = 0;time6_in1 = 0; plus1 =0;end
    endcase
end

assign     plus3 = $signed({b_in_reg[count],16'b0});


// 最後統一接給一個運算單元 (需包含 func_13, func_6 邏輯)
wire signed[35:0]  time6_out1 = time6_in1+time6_in2;
// wire signed [35:0] time6_out = (time6_out1<<2) + (time6_out1<<1);
wire signed [35:0] time6_out = time6_out1*6;
wire signed[37:0] time13_out1 = time13_in1+time13_in2;
// wire signed[37:0] time13_out = (time13_out1<<3)+ (time13_out1<<2) + (time13_out1);
wire signed[37:0] time13_out = time13_out1*13;
wire signed [37:0] plus = plus1+plus2+plus3;
wire signed [37:0] final_in = time13_out - time6_out + plus;
wire signed [31:0] current_x_now_val;
// div20 single_div20_unit (.in(final_in), .out(current_x_now_val));
wire  [65:0] b_ex = $signed(final_in);
assign current_x_now_val =(b_ex * 28'd214748365)>>32;//除20
ShiftRegister sr (.CLK(clk),.RESET(reset),.shift_in(current_x_now_val),.enable(counter!=0),.so1(so[0]),.so2(so[1]),.so3(so[2]),.so4(so[3]),.so5(so[4]),.so6(so[5]));                     
                               



reg out_valid_reg;
assign out_valid = out_valid_reg;
reg [31:0] out_reg;
assign x_out = out_reg;

parameter iterations = 73;
integer i;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0;
        out_valid_reg <= 0;
        out_reg<=0;
        count<=0;
    end else begin
        counter <= counter + 1;
        if(counter!=0) count<=count+1;
        if (in_en) begin
            b_in_reg[counter] <= {(b_in)}; // Example operation, replace with actual logic
        end

        if(counter > 16*iterations) begin 
            out_valid_reg <= 1'b1; 
            out_reg<= current_x_now_val;
        end
    end
end


endmodule



module ShiftRegister(
    input CLK,RESET, enable,
    input [31:0] shift_in,
    output [31:0] so1,
    output [31:0] so2,
    output [31:0] so3,
    output [31:0] so4,
    output [31:0] so5,
    output [31:0] so6
);
    reg [31:0] Q1 [0:31];
    integer i;
    assign so1=Q1[17];
    assign so2=Q1[18];
    assign so3=Q1[19];
    assign so4=Q1[31];
    assign so5=Q1[30];
    assign so6=Q1[29];
    always @(posedge CLK or posedge RESET) begin
        if (RESET)begin
           for (i=0;i<32;i=i+1) begin
               Q1[i]<=0;
           end
           
        end
        else 
        begin
            if (enable) begin
                for (i=0;i<31;i=i+1) begin
                    Q1[i]<= Q1[i+1];
                end
                Q1[31]<= shift_in;
            end
        end
    end      
endmodule