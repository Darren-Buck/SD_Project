`timescale 1ns / 1ps

module square_wave_generator(
    input clk,          // Clock input
    output reg out = 0  // Output signal initialized to 0
);

// Parameter to hold the value for half the count to toggle the square wave
// Adjusted to generate a 40 kHz square wave from a 27 MHz input clock
parameter COUNT_TO_TOGGLE = 336; // 337 cycles - 1, since we start counting from 0

reg[9:0] counter = 0; // 10-bit counter to count up to 337

always @(posedge clk) begin
    if (counter == COUNT_TO_TOGGLE) begin
        out <= ~out;     // Toggle the output signal
        counter <= 0;    // Reset the counter
    end else begin
        counter <= counter + 1; // Increment the counter
    end
end

endmodule
