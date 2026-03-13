module keyboard_signal_receiver_control(
    input wire clk,
    input wire reset,

    // Passed down from the .xdc file (PMOD)
    input wire ps2_clk,
    input wire ps2_data,
    output wire [2:0] state,

    output wire new_key, //one-pulse indicating new key pressed and new note should be played
    output wire [11:0] key_code //like the notes in song_rom. This is the 12-bit note that specifies 
);
    // The data from the PS/2. Comes in 11 bit packet.
    wire [10:0] key_code; //11 bits from the PS/2 data cable on each clock rise. It is the PS/2 seq. The 1:8 are the actual key information that differs.
    reg [10:0] next_key_code;
    dffr #(11) ps2_seq_dff(
        .d(next_key_code),
        .q(key_code),
        .clk(clk),
        .r(reset)
    );

    


    always @(posedge ps2_clk) begin

    end
endmodule



