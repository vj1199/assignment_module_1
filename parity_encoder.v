module parity_encoder (
    input [3:0] data_in,  // 4-bit input vector
    output reg parity     
);

always @(*) begin
    case (data_in)
        4'b0000: parity = 0;
        4'b0001: parity = 1;
        4'b0010: parity = 1;
        4'b0011: parity = 0;
        4'b0100: parity = 1;
        4'b0101: parity = 0;
        4'b0110: parity = 0;
        4'b0111: parity = 1;
        4'b1000: parity = 1;
        4'b1001: parity = 0;
        4'b1010: parity = 0;
        4'b1011: parity = 1;
        4'b1100: parity = 0;
        4'b1101: parity = 1;
        4'b1110: parity = 1;
        4'b1111: parity = 0;
        default: parity = 0;  
    endcase
end

endmodule
// testbench 
module parity_encoder_tb;

    reg [3:0] data_in;  // 4-bit input for the testbench
    wire parity;        // Output wire to capture the parity output from the module

    // Instantiate the parity encoder module
    parity_encoder dut (
        .data_in(data_in),
        .parity(parity)
    );

    // Test process
    initial begin
        // Monitor the inputs and output
        $monitor("Time = %0t | data_in = %b | parity = %b", $time, data_in, parity);

        // Apply test vectors
        data_in = 4'b0000; #10;  // Expected parity: 0
        data_in = 4'b0001; #10;  // Expected parity: 1
        data_in = 4'b0010; #10;  // Expected parity: 1
        data_in = 4'b0011; #10;  // Expected parity: 0
        data_in = 4'b0100; #10;  // Expected parity: 1
        data_in = 4'b0101; #10;  // Expected parity: 0
        data_in = 4'b0110; #10;  // Expected parity: 0
        data_in = 4'b0111; #10;  // Expected parity: 1
        data_in = 4'b1000; #10;  // Expected parity: 1
        data_in = 4'b1001; #10;  // Expected parity: 0
        data_in = 4'b1010; #10;  // Expected parity: 0
        data_in = 4'b1011; #10;  // Expected parity: 1
        data_in = 4'b1100; #10;  // Expected parity: 0
        data_in = 4'b1101; #10;  // Expected parity: 1
        data_in = 4'b1110; #10;  // Expected parity: 1
        data_in = 4'b1111; #10;  // Expected parity: 0

        // Finish the simulation
        $stop;
        #150 $finish;
    end

endmodule
