`timescale 1ns/10ps
module GSIM ( clk, reset, in_en, b_in, out_valid, x_out);
input   clk ;
input   reset ;
input   in_en;
output  out_valid;
input   [15:0]  b_in;
output  [31:0]  x_out;
//==================================================================//IO
reg signed [31:0] b_in_reg[0:15];
reg [15:0]counter;
reg signed [31:0] x[0:15];
reg signed [31:0] x_now[0:15];
wire [31:0] aaaaa = x_now[0];
wire [31:0] ddddd = b_in_reg[0];
reg signed [32:0] time6_in1,time6_in2,time13_in1,time13_in2;
reg signed [32:0] plus1,plus2,plus3;

// 假設 counter 從 0 數到 15 (對應 div20_1 到 div20_16)
wire [3:0] c_2 = counter[3:0]-1;
always @* begin
    // 預設值，防止產生 Latch
    time13_in1 = (&c_2)? 0: x[c_2+1];
    time13_in2 = (|c_2)?x_now[c_2-1]:0;
    time6_in1 = (&c_2[3:1])?0:x[c_2+2];
    time6_in2 = (|c_2[3:1])? x_now[c_2-2]:0;
    plus1 = (c_2[3] & c_2[2] & (c_2[1] | c_2[0]))?0:x[c_2+3];
    plus2 = ((~c_2[3] & ~c_2[2]) & ~(c_2[1] & c_2[0]))?0:x_now[c_2-3];
    plus3 = b_in_reg[c_2];
    //     /*
// div20 div20_1 (.in(func_13(x[1]            )  - func_6( x[2]              )  +x[3]                + b_in_reg[0]),.out(x_now[0]));
// div20 div20_2 (.in(func_13(x[2]  + x_now[0])  - func_6( x[3]              )  +x[4]                + b_in_reg[1]),.out(x_now[1])); 
// div20 div20_3 (.in(func_13(x[3]  + x_now[1])  - func_6( x[4]   +  x_now[0])  +x[5]                + b_in_reg[2]),.out(x_now[2]));
// div20 div20_4 (.in(func_13(x[4]  + x_now[2])  - func_6( x[5]   +  x_now[1])  +x[6]   +   x_now[0] + b_in_reg[3]),.out(x_now[3]));
// div20 div20_5 (.in(func_13(x[5]  + x_now[3])  - func_6( x[6]   +  x_now[2])  +x[7]   +   x_now[1] + b_in_reg[4]),.out(x_now[4]));
// div20 div20_6 (.in(func_13(x[6]  + x_now[4])  - func_6( x[7]   +  x_now[3])  +x[8]   +   x_now[2] + b_in_reg[5]),.out(x_now[5]));
// div20 div20_7 (.in(func_13(x[7]  + x_now[5])  - func_6( x[8]   +  x_now[4])  +x[9]   +   x_now[3] + b_in_reg[6]),.out(x_now[6]));
// div20 div20_8 (.in(func_13(x[8]  + x_now[6])  - func_6( x[9]   +  x_now[5])  +x[10]  +   x_now[4] + b_in_reg[7]),.out(x_now[7]));
// div20 div20_9 (.in(func_13(x[9]  + x_now[7])  - func_6( x[10]  +  x_now[6])  +x[11]  +   x_now[5] + b_in_reg[8]),.out(x_now[8]));
// div20 div20_10(.in(func_13(x[10] + x_now[8])  - func_6( x[11]  +  x_now[7])  +x[12]  +   x_now[6] + b_in_reg[9]),.out(x_now[9]));
// div20 div20_11(.in(func_13(x[11] + x_now[9])  - func_6( x[12]  +  x_now[8])  +x[13]  +   x_now[7] + b_in_reg[10]),.out(x_now[10]));
// div20 div20_12(.in(func_13(x[12] + x_now[10]) - func_6( x[13]  +  x_now[9])  +x[14]  +   x_now[8] + b_in_reg[11]),.out(x_now[11]));
// div20 div20_13(.in(func_13(x[13] + x_now[11]) - func_6( x[14]  +  x_now[10]) +x[15]  +   x_now[9] + b_in_reg[12]),.out(x_now[12]));
// div20 div20_14(.in(func_13(x[14] + x_now[12]) - func_6( x[15]  +  x_now[11])         +  x_now[10] + b_in_reg[13]),.out(x_now[13]));
// div20 div20_15(.in(func_13(x[15] + x_now[13]) - func_6(           x_now[12])         +  x_now[11] + b_in_reg[14]),.out(x_now[14]));
// div20 div20_16(.in(func_13(        x_now[14]) - func_6(           x_now[13])         +  x_now[12] + b_in_reg[15]),.out(x_now[15]));
// */

end

// 最後統一接給一個運算單元 (需包含 func_13, func_6 邏輯)
wire signed[35:0]  time6_out1 = time6_in1+time6_in2;
wire signed [35:0] time6_out = (time6_out1<<2) + (time6_out1<<1);
wire signed[37:0] time13_out1 = time13_in1+time13_in2;
wire signed[37:0] time13_out = (time13_out1<<3)+ (time13_out1<<2) + (time13_out1);
wire signed [37:0] plus = plus1+plus2+plus3;
wire signed [37:0] final_in = time13_out - time6_out + plus;
wire signed [31:0] current_x_now_val;
// div20 single_div20_unit (.in(final_in), .out(current_x_now_val));
wire  [64:0] b_ex = $signed(final_in);
assign current_x_now_val =(b_ex * 28'd214748365)>>32;//除20
                                    



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
        for(i=0;i<16;i=i+1) x[i]<=0;
    end else begin
        counter <= counter + 1;
        if (in_en) begin
            b_in_reg[counter] <= {(b_in),16'b0}; // Example operation, replace with actual logic
        end
        if(counter > 0)begin
             
             x_now[c_2]<= current_x_now_val;
            if(counter[3:0]==0 ) begin for(i=0;i<15;i=i+1) x[i]<=x_now[i]; x[15]<= current_x_now_val; end

        end
        if(counter > 16*iterations) begin 
            out_valid_reg <= 1'b1; 
            out_reg<= current_x_now_val;
        end
    end
end


endmodule
// module time6(
//     input signed [32:0] in;
//     output  signed [37:0] out;
// );
//     wire signed [37:0] b_ext = $signed(in);
//     assign out = (b_ext << 2) + (b_ext << 1);
// endmodule

// module div20 (
//     input signed [37:0] in,
//     output signed [31:0] out
// );
//     wire signed [69:0] b_ext;    // 擴展到 64-bit 確保運算不溢位
//     wire signed [69:0] x_c;      // 0xC (1100)
//     wire signed [69:0] x_cc;     // 0xCC (11001100)
//     wire signed [69:0] x_cccc;   // 0xCCCC
//     wire signed [69:0] x_high;   // 最終高精度常數結果
//     assign b_ext = $signed(in);
//     assign  x_c    = (b_ext <<< 2) + (b_ext <<< 3);
//     assign  x_cc   = x_c + (x_c <<< 4);
//     assign  x_cccc = x_cc + (x_cc <<< 8);
//     assign  x_high = x_cccc + (x_cccc <<< 16);
//     // assign out = (x_high + (64'sh1 <<< 35)) >>> 36;
//     assign out = (b_ext  * 35'd3435973836)>>36;
// endmodule
