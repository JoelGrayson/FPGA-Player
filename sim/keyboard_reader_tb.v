// Passed
/* Testbench output:
Inputted signal s which is 01101100011
We expect the ps2_frame to be 11000110110, which is what was measured from the oscilloscope
What was gotten: 11000110110
*/

module keyboard_reader_tb;
    reg clk, reset;

    reg enabled;
    reg note_done_pulse;

    reg ps2_clk, ps2_data, ps2_reset;
    
    wire keyboard_new_note, keyboard_play;
    wire [5:0] keyboard_duration, keyboard_note;

    // Reset and clk
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        repeat (4) #5 clk = ~clk;
        reset = 1'b0;
        forever #5 clk = ~clk;
    end

    keyboard_reader keyboard_reader_device(
        // Inputs
        .clk(clk),
        .reset(reset),// | reset_player),
        .enabled(enabled),
        .note_done_pulse(note_done_pulse),

        // PS2
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .ps2_reset(ps2_reset),

        // Outputs
        .new_note_pulse(keyboard_new_note), //a one-pulse indicating new note should be played
        .keyboard_play(keyboard_play), //should be true when it should be playing (for the whole duration of the note)
        .duration(keyboard_duration),
        .note(keyboard_note) //which note it is
    );


    initial begin
        // Initial values
        note_done_pulse = 1'b0;
        enabled = 1'b1;
        
        // Line starts idle
        ps2_clk = 1'b1;
        ps2_data = 1'b1;
        ps2_reset = 1'b0;

        // Reset
        reset = 1'b0;
        #10;
        reset = 1'b1;
        #10;
        reset = 1'b0;
        
        
        #9_800;

        // Inspired by the key S press
        // It takes 4000 clock cycles for PS2_clk to toggle

        // Pull down the data before pulling down clk (because of the setup time delay of the data)
        ps2_data = 1'b0;
        #1000;
        ps2_clk = 1'b0; //A

        #4000;
        ps2_clk = 1'b1; //ck1
        #1000;
        ps2_data = 1'b1; //B
        #3000;
        ps2_clk = 1'b0;
        #4000;
        ps2_clk = 1'b1; //C. ck2
        #4000;
        ps2_clk = 1'b0;
        #4000;
        ps2_clk = 1'b1; //ck3

        #1000;
        ps2_data = 1'b0;
        #3000;
        ps2_clk = 1'b0;
        #4000;
        ps2_clk = 1'b1; //ck4
        #1000 ps2_data = 1'b1;
        #3000 ps2_clk = 1'b0;
        #4000 ps2_clk = 1'b1; //ck5
        #4000 ps2_clk = 1'b0;
        #4000 ps2_clk = 1'b1; //ck6
        #1000 ps2_data = 1'b0;
        #3000 ps2_clk = 1'b0;
        #4000 ps2_clk = 1'b1; //ck7

        #4000 ps2_clk = 1'b0;
        #4000 ps2_clk = 1'b1; //ck8
        #4000 ps2_clk = 1'b0;
        #4000 ps2_clk = 1'b1; //ck9

        #1000 ps2_data = 1'b1;
        #3000 ps2_clk = 1'b0;

        #4000 ps2_clk = 1'b1; //ck10
        #4000 ps2_clk = 1'b0;
        #4000 ps2_clk = 1'b1; //ck11

        // That's it. Now they stay idle
        
        #1000;
        $display("We should expect to see new_note_pulse occur and a duration and note to be outputted. Then, keyboard_play to be held high until note_done_pulse occurs");
        $display("keyboard_play is %b. Expected 1.", keyboard_play);
        #10_000;
        note_done_pulse = 1'b1;
        #10;
        note_done_pulse = 1'b0;
        #10;
        $display("keyboard_play is %b. Expected 0.", keyboard_play);
        
        
        #10_000;


        $stop;
    end
endmodule

