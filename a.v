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
wire signed [31:0] x_now[0:15];

div20 div20_1 (.in(func_13(x[1]            )  - func_6( x[2]              )  +x[3]                + b_in_reg[0]),.out(x_now[0]));
div20 div20_2 (.in(func_13(x[2]  + x_now[0])  - func_6( x[3]              )  +x[4]                + b_in_reg[1]),.out(x_now[1])); 
div20 div20_3 (.in(func_13(x[3]  + x_now[1])  - func_6( x[4]   +  x_now[0])  +x[5]                + b_in_reg[2]),.out(x_now[2]));
div20 div20_4 (.in(func_13(x[4]  + x_now[2])  - func_6( x[5]   +  x_now[1])  +x[6]   +   x_now[0] + b_in_reg[3]),.out(x_now[3]));
div20 div20_5 (.in(func_13(x[5]  + x_now[3])  - func_6( x[6]   +  x_now[2])  +x[7]   +   x_now[1] + b_in_reg[4]),.out(x_now[4]));
div20 div20_6 (.in(func_13(x[6]  + x_now[4])  - func_6( x[7]   +  x_now[3])  +x[8]   +   x_now[2] + b_in_reg[5]),.out(x_now[5]));
div20 div20_7 (.in(func_13(x[7]  + x_now[5])  - func_6( x[8]   +  x_now[4])  +x[9]   +   x_now[3] + b_in_reg[6]),.out(x_now[6]));
div20 div20_8 (.in(func_13(x[8]  + x_now[6])  - func_6( x[9]   +  x_now[5])  +x[10]  +   x_now[4] + b_in_reg[7]),.out(x_now[7]));
div20 div20_9 (.in(func_13(x[9]  + x_now[7])  - func_6( x[10]  +  x_now[6])  +x[11]  +   x_now[5] + b_in_reg[8]),.out(x_now[8]));
div20 div20_10(.in(func_13(x[10] + x_now[8])  - func_6( x[11]  +  x_now[7])  +x[12]  +   x_now[6] + b_in_reg[9]),.out(x_now[9]));
div20 div20_11(.in(func_13(x[11] + x_now[9])  - func_6( x[12]  +  x_now[8])  +x[13]  +   x_now[7] + b_in_reg[10]),.out(x_now[10]));
div20 div20_12(.in(func_13(x[12] + x_now[10]) - func_6( x[13]  +  x_now[9])  +x[14]  +   x_now[8] + b_in_reg[11]),.out(x_now[11]));
div20 div20_13(.in(func_13(x[13] + x_now[11]) - func_6( x[14]  +  x_now[10]) +x[15]  +   x_now[9] + b_in_reg[12]),.out(x_now[12]));
div20 div20_14(.in(func_13(x[14] + x_now[12]) - func_6( x[15]  +  x_now[11])         +  x_now[10] + b_in_reg[13]),.out(x_now[13]));
div20 div20_15(.in(func_13(x[15] + x_now[13]) - func_6(           x_now[12])         +  x_now[11] + b_in_reg[14]),.out(x_now[14]));
div20 div20_16(.in(func_13(        x_now[14]) - func_6(           x_now[13])         +  x_now[12] + b_in_reg[15]),.out(x_now[15]));

reg out_valid_reg;
assign out_valid = out_valid_reg;
reg [31:0] out_reg;
assign x_out = out_reg;
parameter iterations = 84;
integer i;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0;
        out_valid_reg <= 0;
        out_reg<=0;
        for(i=0;i<16;i=i+1) x[i]<=0;
    end else begin
        if (in_en) begin
            b_in_reg[counter] <= {(b_in),16'b0}; // Example operation, replace with actual logic
             counter <= counter + 1;
        end else if(counter > 15)begin
             counter <= counter + 1;
            for(i=0;i<16;i=i+1) x[i]<=x_now[i];
            if (counter >= iterations) begin
            out_valid_reg <= 1'b1; 

            out_reg <= x_now[counter-iterations]; // Example output, replace with actual logic
            end
        end
    end
end


function signed [37:0] func_13;
    input signed [32:0] i_b;
    
    // 宣告內部變數 (在 function 中需宣告為 reg)
    reg signed [37:0] b_ext;
    
    begin
        // 1. 先擴展示符號位，防止在加法運算時溢位
        b_ext = $signed(i_b);

        func_13 = (b_ext << 3) + (b_ext << 2) + b_ext ;

    end
endfunction



function signed [37:0] func_6;
    input signed [32:0] i_b;
    
    // 宣告內部變數 (在 function 中需宣告為 reg)
    reg signed [37:0] b_ext;
    
    begin
        // 1. 先擴展示符號位，防止在加法運算時溢位
        b_ext = $signed(i_b);

        // 2. 實作 b * 51 (51 = 32 + 16 + 2 + 1)
        func_6 = (b_ext << 2) + (b_ext << 1);


    end
endfunction






endmodule
// module time6(
//     input signed [32:0] in;
//     output  signed [37:0] out;
// );
//     wire signed [37:0] b_ext = $signed(in);
//     assign out = (b_ext << 2) + (b_ext << 1);
// endmodule

module div20 (
    input signed [37:0] in,
    output signed [31:0] out
);
    wire signed [69:0] b_ext;    // 擴展到 64-bit 確保運算不溢位
    wire signed [69:0] x_c;      // 0xC (1100)
    wire signed [69:0] x_cc;     // 0xCC (11001100)
    wire signed [69:0] x_cccc;   // 0xCCCC
    wire signed [69:0] x_high;   // 最終高精度常數結果
    assign b_ext = $signed(in);
    assign  x_c    = (b_ext <<< 2) + (b_ext <<< 3);
    assign  x_cc   = x_c + (x_c <<< 4);
    assign  x_cccc = x_cc + (x_cc <<< 8);
    assign  x_high = x_cccc + (x_cccc <<< 16);
    assign out = (x_high + (64'sh1 <<< 35)) >>> 36;
    
endmodule

module div20_in (
    input signed [15:0] in,
    output signed [31:0] out
);
    wire signed [31:0] b_ext;    

    assign    b_ext = { {16{in[15]}}, in };
        // 2. 實作 b * 51 (51 = 32 + 16 + 2 + 1)
    assign out = ((b_ext <<< 7) + (b_ext <<< 6) + (b_ext <<< 3)+ (b_ext <<< 2) + b_ext )<<<4; // 除以 256，相當於除以 20 的近似值

    
endmodule