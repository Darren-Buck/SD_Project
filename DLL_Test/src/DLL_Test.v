`timescale 1ns / 1ps

module square_wave_generator_with_dll_delay(
    input clk,                     // Clock input
    input reset,                   // Reset input (assuming active high for simplicity)
    output wire GCLK,
    output reg out_no_delay = 0,   // Output signal without delay, initialized to 0
    output reg out_with_delay = 0  // Output signal with delay, initialized to 0
);

    assign GCLK = clk; // Directly route the clock signal to the output

    // Instantiate the DLL with parameters based on the provided tables
    wire dll_output_clock;
    wire lock_signal;
    DLL dll_instance (
        .CLKIN(GCLK),             // Input clock to the DLL
        .STOP(1'b0),              // Assuming STOP is not used
        .RESET(reset),            // Use the reset input to reset the DLL
        .UPDNCNTL(1'b0),          // Assuming no dynamic update control is required
        .STEP(dll_output_clock),  // Assuming STEP is the delayed clock output
        .LOCK(lock_signal)        // Lock status output
    );
    
    // DLL configuration parameters
    defparam dll_instance.DLL_FORCE = 0;
    //defparam dll_instance.CLKINSEL = "00001";
    defparam dll_instance.CODESCAL = "000";
    defparam dll_instance.SCAL_EN = "true";
    defparam dll_instance.DIV_SEL = 1'b0;

    // Parameter to hold the value for half the count to toggle the square wave
    parameter COUNT_TO_TOGGLE = 336; // For 40 kHz output from a 27 MHz input clock

    // Counters for both outputs
    reg[9:0] counter_no_delay = 0;    // 10-bit counter for no delay output

    always @(posedge GCLK) begin
        // No delay output toggling
        if (counter_no_delay == COUNT_TO_TOGGLE) begin
            out_no_delay <= ~out_no_delay;   // Toggle the output signal without delay
            counter_no_delay <= 0;           // Reset the counter
        end else begin
            counter_no_delay <= counter_no_delay + 1; // Increment the counter
        end
    end

    reg[9:0] counter_with_delay = 0; // Counter for delayed output
    always @(posedge dll_output_clock) begin
        // With delay output toggling using the DLL output clock
        if (counter_with_delay == COUNT_TO_TOGGLE) begin
            out_with_delay <= ~out_with_delay; // Toggle the output signal with delay
            counter_with_delay <= 0;           // Reset the counter
        end else begin
            counter_with_delay <= counter_with_delay + 1; // Increment the counter
        end
    end

endmodule
