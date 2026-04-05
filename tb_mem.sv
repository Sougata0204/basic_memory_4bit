module tb_mem;
    reg clk;
    reg [3:0] A;
    reg WRITE;
    reg READ;
    reg [3:0] Din;
    
    wire [3:0] Dout_async;
    wire [3:0] Dout_sram;

    int errors = 0;

    // Async mem
    mem_async u_async (
        .A(A),
        .WRITE(WRITE),
        .READ(READ),
        .Din(Din),
        .Dout(Dout_async)
    );

    // Sync mem
    mem_sram u_sram (
        .clk(clk),
        .A(A),
        .WRITE(WRITE),
        .READ(READ),
        .Din(Din),
        .Dout(Dout_sram)
    );

    // Clock gen
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test flow
    initial begin
        $dumpfile("tb_mem.vcd");
        $dumpvars(0, tb_mem);
        A = 0;
        WRITE = 0;
        READ = 0;
        Din = 0;

        @(negedge clk);
        
        $display("--- Starting Memory Test ---");
        $display("Test 1: Write all addresses");
        for (int i = 0; i < 16; i++) begin
            A = i;
            Din = ~i[3:0]; 
            WRITE = 1;
            @(negedge clk);
        end
        WRITE = 0;
        @(negedge clk);

        $display("Test 2: Read and verify all addresses");
        for (int i = 0; i < 16; i++) begin
            A = i;
            READ = 1;
            @(negedge clk); 
            if (Dout_async !== ~i[3:0]) begin
                $display("ERROR (Async): Addr %0d Expected %h Got %h", i, ~i[3:0], Dout_async);
                errors++;
            end
            if (Dout_sram !== ~i[3:0]) begin
                $display("ERROR (SRAM): Addr %0d Expected %h Got %h", i, ~i[3:0], Dout_sram);
                errors++;
            end
        end
        READ = 0;
        @(negedge clk);
        $display("Test 3: Output behavior when READ=0");
        A = 5;
        READ = 0;
        @(negedge clk); 
        if (Dout_async !== 4'b0) begin
            $display("ERROR (Async): Output not zero when READ=0. Got %h", Dout_async);
            errors++;
        end
        if (Dout_sram !== 4'b0) begin
            $display("ERROR (SRAM): Output not zero when READ=0. Got %h", Dout_sram);
            errors++;
        end
        $display("Test 4: Simultaneous Read-During-Write");
        A = 4'hA;
        Din = 4'h3;
        WRITE = 1;
        READ = 1;
        @(negedge clk);
        
        if (Dout_async !== 4'h3) begin
            $display("ERROR (Async): Read-during-write failed. Expected 3, got %h", Dout_async);
            errors++;
        end
        if (Dout_sram !== 4'h5) begin
            $display("ERROR (SRAM): Read-during-write failed. Expected old data 5, got %h", Dout_sram);
            errors++;
        end

        @(negedge clk);
        if (Dout_sram !== 4'h3) begin
            $display("ERROR (SRAM): Post read-during-write output update failed. Expected 3, got %h", Dout_sram);
            errors++;
        end

        WRITE = 0;
        READ = 0;
        @(negedge clk);
        
        $display("--- Test Summary ---");
        if (errors == 0)
            $display("PASSED: 0 errors");
        else
            $display("FAILED: %0d errors", errors);
        
        $finish;
    end
endmodule
