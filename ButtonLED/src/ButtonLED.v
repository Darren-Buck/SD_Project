`timescale 1ns / 1ps
module ButtonLEDControl(
    input wire button, // Input from the button
    output wire led    // Output to the LED
);


assign led = button;

endmodule
