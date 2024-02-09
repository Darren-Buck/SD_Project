`timescale 1ns / 1ps

module square_wave_generator_with_and_without_delay(
    input clk,                     // Clock input
    input button,                  // Button input (assuming active high for simplicity)
    output wire GCLK,
    output reg out_no_delay = 0,   // Output signal without delay, initialized to 0
    output reg out_with_delay = 0  // Output signal with delay, initialized to 0
);

    assign GCLK = clk; // Directly route the clock signal to the output

    // Parameter to hold the value for half the count to toggle the square wave
    parameter COUNT_TO_TOGGLE = 336; // For 40 kHz output from a 27 MHz input clock

    // Calculate initial delay for 1/16 pi phase shift
    // Since the exact calculation might result in a fractional value, choose a close integer that fits the desired phase shift
    parameter PHASE_SHIFT_DELAY = (COUNT_TO_TOGGLE + 1) / 16;

    // Counters for both outputs
    reg[9:0] counter_no_delay = 0;    // 10-bit counter for no delay output
    reg[9:0] counter_with_delay = PHASE_SHIFT_DELAY; // Counter for delayed output initialized with phase shift delay

    always @(posedge clk) begin
        // No delay output toggling
        if (counter_no_delay == COUNT_TO_TOGGLE) begin
            out_no_delay <= ~out_no_delay;   // Toggle the output signal without delay
            counter_no_delay <= 0;           // Reset the counter
        end else begin
            counter_no_delay <= counter_no_delay + 1; // Increment the counter
        end
        
        // With delay output toggling
        if (counter_with_delay == COUNT_TO_TOGGLE) begin
            out_with_delay <= ~out_with_delay; // Toggle the output signal with delay
            counter_with_delay <= PHASE_SHIFT_DELAY; // Reset the counter with phase shift delay
        end else begin
            counter_with_delay <= counter_with_delay + 1; // Increment the counter
        end
    end

endmodule
