module clock_generator_and_edge_counter;

    reg clk;                    // Clock signal
    reg [31:0] edge_count;      // Counter for the rising edges
    reg [31:0] time_elapsed;    // Counter for the time elapsed in ns
    reg reset;                  // Reset signal
    integer i;

    // Clock generation with 10 MHz frequency and 30% duty cycle
    initial begin
        clk = 0;
        reset = 1;
        #100 reset = 0;         // Release reset after 100 ns
    end

    always begin
        #30 clk = 1;            // High time of 30 ns
        #70 clk = 0;            // Low time of 70 ns
    end

    // Edge counting logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            edge_count <= 0;
            time_elapsed <= 0;
        end else begin
            edge_count <= edge_count + 1;
            time_elapsed <= time_elapsed + 100;  // Increment time by clock period (100 ns)
        end
    end

    
    initial begin
        #5000 $display("Number of rising edges after 5 seconds: %d, Number of falling edge after 5 seconds : %d", edge_count,time_elapsed);
        $stop;
        #50000;
        $finish;
    end
     
endmodule
