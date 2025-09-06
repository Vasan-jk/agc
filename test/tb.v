`default_nettype none
`timescale 1ns/1ps

module tb_morse_generator;

    reg clk;
    reg rst;
    reg [4:0] letter;
    wire out;

    // Instantiate the Morse code generator
    morse_generator uut (
        .clk(clk),
        .rst(rst),
        .letter(letter),
        .out(out)
    );

    // Clock generation (50 MHz equivalent)
    initial clk = 0;
    always #10 clk = ~clk; // 20 ns period -> 50 MHz

    // Test stimulus
    initial begin
        rst = 1;
        letter = 0;
        #50;
        rst = 0;

        // Loop through all letters A-Z
        repeat(26) begin
            letter = letter + 1;
            // wait long enough for full Morse output for each letter
            // assuming dot_time=50000 clock cycles in RTL
            #(8*50000*20); // 8 symbols max * dot_time * clock period
        end

        $stop; // End simulation
    end

endmodule

