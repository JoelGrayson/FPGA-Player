`define WHITE 24'hFFFFFF
`define BLACK 24'h000000

`define INIT_X 11'd88
`define INIT_Y 10'd32
`define WIDTH 11'd800 // X from 88 to 888
`define HEIGHT 10'd480 // Y from 32 to 32+480=512

module wave_display (
    input clk,
    input reset,
    input [10:0] x,  // [0..1279]
    input [9:0]  y,  // [0..1023]
    input valid,
    input [7:0] read_value,
    input read_index,
    output wire [8:0] read_address,
    output wire valid_pixel,
    output wire [7:0] r,
    output wire [7:0] g,
    output wire [7:0] b
);
    // BEGIN (1)
    // x is msb (thrown away), region (2 bits), middle (7 bits), and lsb (thrown away)
    // middle and real_index are used to construct real_addr
    // wire _x_lsb; //thrown away. LSB thrown away so that two x-pixels maps to one changed x-value, making the graph thicker 
    // wire [2:0] x_region;
    // wire [6:0] x_middle;
    // assign { x_region, x_middle, _x_lsb } = x; //3+7+1=11
    
    // wire is_x_in_region = (x_region == 3'b001) | (x_region == 3'b010); //used to see if valid
    wire is_x_in_region = x >= `INIT_X && x <= `INIT_X + `WIDTH;
    wire is_y_in_region = y >= `INIT_Y && y <= `INIT_Y + `HEIGHT;
    // there are 256 data addresses and WIDTH variables, which means WIDTH/256 = 3.125 or 3 x-pixels per y-value. 
    assign read_address = ({ read_index, x } - `INIT_Y) / `HEIGHT * 9'd256; //x_scaled
         //>> 2'd2; //scaled x value (divide by 4)
    
    
    // Scaled y value
    wire [7:0] y_scaled = (y - `INIT_X) / `WIDTH * 9'd256; //divided by 4 as well so it is full height
    // read_address (x_scaled) used to fetch the value based on curr x positino
    // Curr y position leads to y_scaled which is compared to the data coming out which is also a byte

//     // Assign read_addr based on x variables and read_index
//     assign read_address = { read_index, x_region == 3'b010, x_middle }; //1+1+7=9
     // Commented out because you cannot use a wire with a case statement, only a wire (learned this from AI)
 //    always @(*) begin
 //        case (x_region)
 //            2'b01: read_address = { read_index, 1'b0, x_middle }; //1 + 1 + 7 = 9 bits
 //            2'b10: read_address = { read_index, 1'b1, x_middle };
 //            default: read_address = 9'b0; //don't care
 //        endcase
 //    end
     // END (1)
    
     // BEGIN (2)
     // Calculate curr_y from read_value
     wire [7:0] curr_y;
     assign curr_y = read_value; //old scaling: (read_value >> 1'b1) + 6'd32; // /2+32
     // END (2)
    
     wire [8:0] p_read_address;
     dffr #(9) p_read_address_dff(
         .d(read_address),
         .q(p_read_address),
         .clk(clk),
         .r(reset)
     );
     
     
     // BEGIN (3)
     // Remember previous y_value (curr_y) in p_y (p_ standing for previous_)
     wire [7:0] p_y;
     dffre #(8) p_y_dff(
         .d(curr_y),
         .q(p_y),
         .clk(clk),
         .r(reset),
         .en(read_address != p_read_address)
     );
    
//     wire [7:0] y_trunc = y[8:1]; //drop MSB (only top half used) and LSB (fattening) so 10 bits -> 8 bits
    
    
     // END (3)
    
     // BEGIN (4)
//     wire is_y_in_region = y[9] == 0; //in top half of screen
     wire is_y_in_wave =
         // p_y < y < curr_y - wave going up
         (p_y <= y_scaled && y_scaled <= curr_y)
         ||
         // curr_y < y < p_y - wave going down
         (curr_y <= y_scaled && y_scaled <= p_y)
         ;
     wire is_x_beyond_artifact = is_x_in_region & read_address < 2'd2; //valid & first two x. used to chop off the beginning
     assign valid_pixel = is_y_in_region //in top half of screen
                         & is_x_in_region //in quadrant 1 or 2 x-wise
                         & is_y_in_wave
                         & valid
                         & is_x_beyond_artifact;
    assign { r, g, b } = `WHITE; //rgb will be blacked out if valid_pixel is false by the wave_display_top module
//     // END (4)
endmodule
