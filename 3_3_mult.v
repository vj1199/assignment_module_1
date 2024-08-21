module three_bit_adder (
    input [2:0] a,        // 3-bit input A
    input [2:0] b,        // 3-bit input B
    input cin,            // Carry input
    output [2:0] sum,     // 3-bit Sum output
    output cout           // Carry output
);

    // Use a function to calculate the sum and carry
    assign {cout, sum} = add_3bit(a, b, cin);

    // Function to perform 3-bit addition
    function [3:0] add_3bit;
        input [2:0] a;
        input [2:0] b;
        input cin;
        begin
            add_3bit = a + b + cin; // Perform addition with carry-in
        end
    endfunction

endmodule


module three_by_three_multiplier (
    input [2:0] A,        // 3-bit multiplier
    input [2:0] B,        // 3-bit multiplicand
    output [5:0] product  // 6-bit product
);

    wire [2:0] P0, P1, P2;     // Partial products
    wire [3:0] sum1, sum2;     // Intermediate sums
    wire c1, c2;               // Carry bits

    // Partial products
    assign P0 = A & {3{B[0]}}; // Multiply A by B[0]
    assign P1 = A & {3{B[1]}}; // Multiply A by B[1]
    assign P2 = A & {3{B[2]}}; // Multiply A by B[2]}

    // Shift P1 and P2 for addition
    wire [3:0] P1_shifted = {P1, 1'b0};   // P1 shifted left by 1
    wire [4:0] P2_shifted = {P2, 2'b00};  // P2 shifted left by 2

    // First addition: P0 + P1_shifted
    three_bit_adder adder1 (
        .a(P0),
        .b(P1_shifted[2:0]),
        .cin(1'b0),
        .sum(sum1[2:0]),
        .cout(c1)
    );
    assign sum1[3] = P1_shifted[3] | c1;  // Handle the carry out

    // Second addition: sum1 + P2_shifted
    three_bit_adder adder2 (
        .a(sum1[2:0]),
        .b(P2_shifted[2:0]),
        .cin(1'b0),
        .sum(sum2[2:0]),
        .cout(c2)
    );
    assign sum2[3] = sum1[3] | P2_shifted[3] | c2;  // Handle the carry out

    // Assign the final product
    assign product = {sum2[3], sum2[2:0], P0[2:0]};

endmodule

module three_by_three_multiplier_tb;

    reg [2:0] A;           // 3-bit input A (multiplier)
    reg [2:0] B;           // 3-bit input B (multiplicand)
    wire [5:0] product;    // 6-bit output product

    // Instantiate the multiplier module
    three_by_three_multiplier uut (
        .A(A),
        .B(B),
        .product(product)
    );

    // Test process
    initial begin
        // Monitor the inputs and output
        $monitor("Time = %0t | A = %0d | B = %0d | product = %0d", $time, A, B, product);

        // Apply test vectors
        A = 3'b000; B = 3'b000; #10;  // Expected product: 000000 (0)
        A = 3'b001; B = 3'b001; #10;  // Expected product: 000001 (1)
        A = 3'b010; B = 3'b001; #10;  // Expected product: 000010 (2)
        A = 3'b011; B = 3'b001; #10;  // Expected product: 000011 (3)
        A = 3'b100; B = 3'b010; #10;  // Expected product: 000100 (4)
        A = 3'b101; B = 3'b010; #10;  // Expected product: 000110 (6)
        A = 3'b110; B = 3'b011; #10;  // Expected product: 001010 (10)
        A = 3'b111; B = 3'b011; #10;  // Expected product: 001101 (13)
        A = 3'b111; B = 3'b111; #10;  // Expected product: 110001 (49)

        // Finish the simulation
        $stop;
        #150 $finish;
    end

endmodule
