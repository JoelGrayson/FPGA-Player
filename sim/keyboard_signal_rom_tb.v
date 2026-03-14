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

module keyboard_signal_rom_tb;
    reg [10:0] key_code;
    wire [5:0] keyboard_note;

    keyboard_signal_rom dut(
        .key_code(key_code),
        .keyboard_note(keyboard_note)
    );

    initial begin
        key_code = 11'b01101100011; // s pressed
        #10; //delay not necessary but I'll do it anyway.
        if (keyboard_note != `S_NOTE) begin
            $display("Nope: %b should be %b", keyboard_note, `S_NOTE);
        end

        key_code = 11'b01100110011; //h
        #10;
        if (keyboard_note != `H_NOTE) begin
            $display("Na bro: %b should be %b", keyboard_note, `H_NOTE);
        end

        $display("If nothing printed the tests passed");
    end
endmodule

