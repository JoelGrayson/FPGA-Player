// Use this to run the code: https://www.tutorialspoint.com/compilers/online-verilog-compiler.htm

module main;
    reg [10:0] key_code = 11'b00000110110;
    reg [3:0] read_bit_index = 4'd9;
    reg ps2_data = 1'b1;
    wire [10:0] new_key_code = key_code | ({10'b0, ps2_data} << read_bit_index);
    initial begin
        #10;
        $display("key_code: %b", key_code);
        $display("new_key_code: %b", new_key_code);
    end
endmodule

