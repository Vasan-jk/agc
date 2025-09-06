module morse_generator(
    input wire clk,
    input wire rst,
    input wire [4:0] letter, // 0=A, 25=Z
    output reg out
);

    reg [7:0] morse_code;
    reg [2:0] bit_index;
    reg [15:0] counter; // timing counter
    reg [15:0] dot_time; 

    // Dot time unit (adjust for clock frequency)
    initial dot_time = 50000;

    // Lookup table for letters A-Z
    always @(*) begin
        case(letter)
            5'd0: morse_code = 8'b01000000; // A ·–
            5'd1: morse_code = 8'b10000000; // B –···
            5'd2: morse_code = 8'b10100000; // C –·–·
            5'd3: morse_code = 8'b10000000; // D –··
            5'd4: morse_code = 8'b00000001; // E ·
            5'd5: morse_code = 8'b00101000; // F ··–·
            5'd6: morse_code = 8'b11000000; // G ––·
            5'd7: morse_code = 8'b01010100; // H ····
            5'd8: morse_code = 8'b01000000; // I ··
            5'd9: morse_code = 8'b01111100; // J ·–––
            5'd10: morse_code = 8'b10100000; // K –·–
            5'd11: morse_code = 8'b01000000; // L ·–··
            5'd12: morse_code = 8'b11000000; // M ––
            5'd13: morse_code = 8'b10000000; // N –·
            5'd14: morse_code = 8'b11100000; // O –––
            5'd15: morse_code = 8'b01101000; // P ·––·
            5'd16: morse_code = 8'b11010000; // Q ––·–
            5'd17: morse_code = 8'b01000000; // R ·–·
            5'd18: morse_code = 8'b01000000; // S ···
            5'd19: morse_code = 8'b10000000; // T –
            5'd20: morse_code = 8'b00100000; // U ··–
            5'd21: morse_code = 8'b00101000; // V ···–
            5'd22: morse_code = 8'b01100000; // W ·––
            5'd23: morse_code = 8'b10010100; // X –··–
            5'd24: morse_code = 8'b10110100; // Y –·––
            5'd25: morse_code = 8'b11001000; // Z ––··
            default: morse_code = 8'b00000000;
        endcase
    end

    // FSM / Timer for Morse output
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_index <= 0;
            counter <= 0;
            out <= 0;
        end else begin
            counter <= counter + 1;

            if(counter >= dot_time) begin
                counter <= 0;
                out <= morse_code[bit_index];
                bit_index <= bit_index + 1;

                if(bit_index == 7) // reset after last symbol
                    bit_index <= 0;
            end
        end
    end

endmodule
