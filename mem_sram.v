module mem_sram (
    input clk,
    input [3:0] A,
    input WRITE,
    input READ,
    input [3:0] Din,
    output reg [3:0] Dout
);
    reg [3:0] mem [0:15];

    // Write data
    always @(posedge clk) begin
        if (WRITE) mem[A] <= Din;
    end

    // Read data
    always @(posedge clk) begin
        if (READ) Dout <= mem[A];
        else Dout <= 4'b0;
    end
endmodule
