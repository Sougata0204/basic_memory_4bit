module mem_async (
    input [3:0] A,
    input WRITE,
    input READ,
    input [3:0] Din,
    output [3:0] Dout
);
    reg [3:0] mem [0:15];

    // Write data
    always @(*) begin
        if (WRITE) mem[A] = Din;
    end

    // Read data
    assign Dout = READ ? mem[A] : 4'b0;
endmodule
