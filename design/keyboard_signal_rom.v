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

// From scan set 2: https://webdocs.cs.ualberta.ca/~amaral/courses/329/labs/scancodes.html
`define PS2_A 8'h1C
`define PS2_S 8'h1B
`define PS2_D 8'h23
`define PS2_F 8'h2B
`define PS2_G 8'h34
`define PS2_H 8'h33
`define PS2_J 8'h3B
`define PS2_K 8'h42
`define PS2_L 8'h4B
// 01000110110
// 10001101

module keyboard_signal_rom(
    input wire [10:0] key_code, //11 bit signal. FKA keyboard_signal
    output reg [5:0] keyboard_note, //note to be played, doesn't include the duration
    output wire [7:0] reversed_byte //useful for debugging through ILA in the parent
);
    // From reality: 11**00011011**0. We only care about the bits in between. They are in reverse order from our scan set.
    wire [7:0] byte = key_code[9:2];
    assign reversed_byte = { byte[0], byte[1], byte[2], byte[3], byte[4], byte[5], byte[6], byte[7] }; //reverse order for it to match PS2_{letter}
    
    // Only use make codes to start playing a note
    always @(*) begin
        casex (reversed_byte) //don't care what first bit (start bit) and last bit (stop bit) are. Only care about the middle 8 bits. Parity is not checked here.
            `PS2_A: keyboard_note = `A_NOTE;
            `PS2_S: keyboard_note = `S_NOTE;
            `PS2_D: keyboard_note = `D_NOTE;
            `PS2_F: keyboard_note = `F_NOTE;
            `PS2_G: keyboard_note = `G_NOTE;
            `PS2_H: keyboard_note = `H_NOTE; // H_NOTE (assign the key code as appropriate if you wish to define `H_NOTE`)
            `PS2_J: keyboard_note = `J_NOTE; // J_NOTE
            `PS2_K: keyboard_note = `K_NOTE; // K_NOTE
            `PS2_L: keyboard_note = `L_NOTE; // L_NOTE
            
            default: keyboard_note = `REST_NOTE;
        endcase
    end

    // // Only use make codes to start playing a note
    // always @(*) begin
    //     casex (key_code) //don't care what first bit (start bit) and last bit (stop bit) are. Only care about the middle 8 bits. Parity is not checked here.
    //         11'bx00000000xx: // Just in case
    //             keyboard_note = `REST_NOTE;
    //         11'bx00111000xx: //A
    //             keyboard_note = `A_NOTE;
    //         11'bxx00011011x: //S. From testbench: 01101100011. From reality: 11000110110
    //             keyboard_note = `S_NOTE;
    //         11'bx11000100xx: //D
    //             keyboard_note = `D_NOTE;
    //         11'bx11010100xx: //F
    //             keyboard_note = `F_NOTE;
    //         11'bx00101100xx: //G
    //             keyboard_note = `G_NOTE;
    //         11'bx11001100xx: //H
    //             keyboard_note = `H_NOTE; // H_NOTE (assign the key code as appropriate if you wish to define `H_NOTE`)
    //         11'bx11011100xx: //J
    //             keyboard_note = `J_NOTE; // J_NOTE
    //         11'bx01000010xx: //K
    //             keyboard_note = `K_NOTE; // K_NOTE
    //         11'bx11010010xx: //L
    //             keyboard_note = `L_NOTE; // L_NOTE
            
    //         default: keyboard_note = `REST_NOTE;
    //     endcase
    // end
endmodule

