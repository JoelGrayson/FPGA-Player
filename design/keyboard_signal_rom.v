// Inspired by tcg_rom

`define A_NOTE 6'd37
`define S_NOTE 6'd39
`define D_NOTE 6'd40
`define F_NOTE 6'd44
`define G_NOTE 6'd47
`define H_NOTE 6'd48
`define J_NOTE 6'd49
`define K_NOTE 6'd50
`define L_NOTE 6'd51
`define REST_NOTE 6'd0 //nothing played

module keyboard_signal_rom(
    input wire [10:0] key_code, //11 bit signal. FKA keyboard_signal
    output reg [5:0] keyboard_note //note to be played, doesn't include the duration
);
    // Only use make codes to start playing a note
    always @(*) begin
        casex (key_code) //don't care what first bit (start bit) and last bit (stop bit) are. Only care about the middle 8 bits. Parity is not checked here.
            11'bx00000000xx: // Just in case
                keyboard_note = `REST_NOTE;
            11'bx00111000xx: //A
                keyboard_note = `A_NOTE;
            11'bx11011000xx: //S. From testbench: 01101100011
                keyboard_note = `S_NOTE;
            11'bx11000100xx: //D
                keyboard_note = `D_NOTE;
            11'bx11010100xx: //F
                keyboard_note = `F_NOTE;
            11'bx00101100xx: //G
                keyboard_note = `G_NOTE;
            11'bx11001100xx: //H
                keyboard_note = `H_NOTE; // H_NOTE (assign the key code as appropriate if you wish to define `H_NOTE`)
            11'bx11011100xx: //J
                keyboard_note = `J_NOTE; // J_NOTE
            11'bx01000010xx: //K
                keyboard_note = `K_NOTE; // K_NOTE
            11'bx11010010xx: //L
                keyboard_note = `L_NOTE; // L_NOTE
            
            default: keyboard_note = `REST_NOTE;
        endcase
    end
endmodule

