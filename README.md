# 16x4 Memory Modules

This repository contains the Verilog and SystemVerilog implementations for 16-word by 4-bit (16x4) memory modules. Two distinct architectural variants are provided: an asynchronous memory model and a synchronous Static Random-Access Memory (SRAM) model. A comprehensive SystemVerilog testbench is included for functional verification and behavioral comparison.

## Design Specifications

Both memory modules maintain a uniform 16-word depth and 4-bit data width, adhering to the following port interface:

*   **A [3:0]**: 4-bit address bus corresponding to 16 addressable locations.
*   **Din [3:0]**: 4-bit input data port.
*   **Dout [3:0]**: 4-bit output data port.
*   **WRITE**: Active-high write enable control signal.
*   **READ**: Active-high read enable control signal.
*   **clk** (Synchronous only): System clock input for sequential operations.

## Module Descriptions

### Asynchronous Memory (`mem_async.v`)

The `mem_async` module represents a fully combinatorial memory architecture, operating independently of a system clock.

*   **Write Operation**: Data from `Din` is continuously driven into the memory array at the specified address `A` whenever the `WRITE` signal is asserted high.
*   **Read Operation**: Output data `Dout` combinatorially reflects the contents of the memory at address `A` when `READ` is high. If `READ` is low, the output is driven to zero (`4'b0`).

### Synchronous SRAM (`mem_sram.v`)

The `mem_sram` module implements standard synchronous memory behavior, where operations are strictly evaluated on the positive edge of the clock signal (`clk`).

*   **Write Operation**: Data from `Din` is sampled and latched into the memory array at address `A` strictly on the rising edge of `clk` while the `WRITE` enable is asserted.
*   **Read Operation**: Data from the memory array at address `A` is registered to the `Dout` bus on the rising edge of `clk` while the `READ` enable is asserted. If `READ` is low, `Dout` is registered as zero (`4'b0`) upon the subsequent clock edge.

## Functional Verification

The included SystemVerilog testbench (`tb_mem.sv`) instantiates both the asynchronous and synchronous memory modules within the same environment to perform comparative functional validation. The automated verification sequence evaluates the following test cases:

1.  **Iterative Write Cycle**: Traverses all 16 memory addresses, driving an inverted address pattern (`~i[3:0]`) into each storage location.
2.  **Iterative Read and Compare Cycle**: Traverses the complete address space, asserts the `READ` signal, and compares the output data against the expected inverted pattern for both instantiated modules.
3.  **Output Isolation Verification**: Deasserts the `READ` signal and verifies that the `Dout` buses for both memory designs successfully drive a zero value (`4'b0`).
4.  **Simultaneous Read-During-Write Resolution**: Validates the architectural discrepancy between the two models when both the `WRITE` and `READ` signals are concurrently asserted at a targeted address.
    *   *Asynchronous Module*: Confirms the combinatorial data path, verifying the new data appears on `Dout` in the same evaluation cycle.
    *   *Synchronous Module*: Confirms read-before-write latency mapping; `Dout` accurately captures the pre-existing data upon the immediate clock edge, and registers the newly written data on the subsequent clock edge.

## Simulation Output

The design environment is configured to support standard logic simulators (e.g., Icarus Verilog). The testbench automatically generates a Value Change Dump (VCD) file (`tb_mem.vcd`) to facilitate post-simulation signal analysis and waveform visualization.



Done by isuku02 :) checck my linkedin "https://www.linkedin.com/in/sougata-chandra-875716224/"