# 8-bit ALU in Verilog

A combinational 8-bit Arithmetic Logic Unit (ALU) written in Verilog HDL, with a 16-operation instruction set, five status flags (carry, borrow, zero, overflow, negative), and a directed testbench covering arithmetic corner cases.

> **Author:** Your Name · [LinkedIn](https://linkedin.com/in/your-profile) · your.email@example.com

---

## Highlights

- **16 operations** selected by a 4-bit opcode: arithmetic, bitwise logic, shifts, and modulo
- **5 status flags:** Carry, Borrow, Zero, Overflow (signed), Negative
- **Fully combinational** design (`always @(*)`) with defaults assigned at the top of the block, so no unintended latches
- **Signed overflow detection** for ADD, SUB, INC and DEC
- **Directed testbench** targeting carry, borrow, overflow, zero and negative flag corner cases
- Synthesizable, tool-independent Verilog-2001

---

## Block Diagram

```
          ┌───────────────────┐
 A[7:0] ──►                   ├──► result[7:0]
 B[7:0] ──►      ALU_8bit     ├──► carry
opcode[3:0]►                   ├──► borrow
          │                   ├──► zero
          │                   ├──► overflow
          └───────────────────┘──► negative
```

---

## Repository Structure

```
.
├── ALU_8bit.v        # ALU design (RTL)
├── ALU_8bit_tb.v     # Testbench
└── README.md
```

---

## Interface

| Port       | Direction | Width | Description                  |
|------------|-----------|-------|------------------------------|
| `A`        | Input     | 8     | Operand A                    |
| `B`        | Input     | 8     | Operand B                    |
| `opcode`   | Input     | 4     | Operation select             |
| `result`   | Output    | 8     | Operation result             |
| `carry`    | Output    | 1     | Carry-out / shifted-out bit  |
| `borrow`   | Output    | 1     | Borrow (SUB, DEC)            |
| `zero`     | Output    | 1     | High when `result == 0`      |
| `overflow` | Output    | 1     | Signed (two's complement) overflow |
| `negative` | Output    | 1     | Copy of `result[7]` (sign bit) |

---

## Instruction Set

| Opcode | Mnemonic | Operation                    | Flags affected                         |
|--------|----------|------------------------------|----------------------------------------|
| `0000` | ADD      | `A + B`                      | carry, overflow, zero, negative        |
| `0001` | SUB      | `A - B`                      | borrow, overflow, zero, negative       |
| `0010` | INC      | `A + 1`                      | carry, overflow, zero, negative        |
| `0011` | DEC      | `A - 1`                      | borrow, overflow, zero, negative       |
| `0100` | AND      | `A & B`                      | zero, negative                         |
| `0101` | OR       | `A \| B`                     | zero, negative                         |
| `0110` | XOR      | `A ^ B`                      | zero, negative                         |
| `0111` | NOT      | `~A`                         | zero, negative                         |
| `1000` | NAND     | `~(A & B)`                   | zero, negative                         |
| `1001` | NOR      | `~(A \| B)`                  | zero, negative                         |
| `1010` | XNOR     | `~(A ^ B)`                   | zero, negative                         |
| `1011` | SHL      | Logical shift left by 1      | carry (= `A[7]`), zero, negative       |
| `1100` | SHR      | Logical shift right by 1     | carry (= `A[0]`), zero, negative       |
| `1101` | SAR      | Arithmetic shift right by 1  | carry (= `A[0]`), zero, negative       |
| `1110` | MOD      | `A % B` (returns 0 if `B == 0`) | zero, negative                      |
| `1111` | PASS     | `result = A`                 | zero, negative                         |

Flags not listed for an operation are driven to `0`.

### Flag Logic

- **Carry (ADD/INC):** bit 8 of the 9-bit intermediate sum.
- **Borrow (SUB):** asserted when `A < B` (unsigned). **Borrow (DEC):** asserted when `A == 0`.
- **Overflow (ADD):** operands share a sign and the result's sign differs.
- **Overflow (SUB):** operands differ in sign and the result's sign differs from `A`.
- **Overflow (INC):** `+127 + 1`. **Overflow (DEC):** `-128 - 1`.
- **Zero:** `result == 8'b0`. **Negative:** `result[7]`.

---

## Testbench

`ALU_8bit_tb.v` applies 12 directed test vectors (10 ns apart) to the ALU, each targeting a specific flag condition:

| # | Op  | A    | B    | Expected result | Flags set                  |
|---|-----|------|------|-----------------|----------------------------|
| 1 | ADD | `FF` | `01` | `00`            | carry, zero                |
| 2 | ADD | `7F` | `01` | `80`            | overflow, negative         |
| 3 | ADD | `80` | `FF` | `7F`            | carry, overflow            |
| 4 | SUB | `03` | `05` | `FE`            | borrow, negative           |
| 5 | SUB | `7F` | `FF` | `80`            | borrow, overflow, negative |
| 6 | SUB | `80` | `01` | `7F`            | overflow                   |
| 7 | INC | `FF` | n/a  | `00`            | carry, zero                |
| 8 | INC | `7F` | n/a  | `80`            | overflow, negative         |
| 9 | DEC | `00` | n/a  | `FF`            | borrow, negative           |
| 10 | DEC | `80` | n/a | `7F`            | overflow                   |
| 11 | SUB | `05` | `05` | `00`            | zero                       |
| 12 | SUB | `00` | `01` | `FF`            | borrow, negative           |

Results are inspected in the waveform viewer.

### Simulation Waveform

<!-- Add a screenshot of your waveform here, e.g.: -->
<!-- ![Simulation waveform](docs/waveform.png) -->

---

## How to Run

### Vivado (XSim)

1. Create a new RTL project and add `ALU_8bit.v` as a design source.
2. Add `ALU_8bit_tb.v` as a simulation source and set `ALU_8bit_tb` as the top module.
3. Run **Simulation → Run Behavioral Simulation** and inspect the waveform.

### Icarus Verilog + GTKWave

The testbench does not include a dump command, so add these lines inside the `initial` block, before the first stimulus:

```verilog
$dumpfile("alu.vcd");
$dumpvars(0, ALU_8bit_tb);
```

Then run:

```bash
iverilog -o alu_sim ALU_8bit.v ALU_8bit_tb.v
vvp alu_sim
gtkwave alu.vcd
```

---

## Design Notes

- The ALU is purely combinational: outputs update whenever `A`, `B` or `opcode` change, with no clock.
- Outputs are given default values at the start of the `always` block, which avoids inferred latches.
- `A % B` maps to a hardware divider when synthesized, which costs noticeably more area and delay than the other operations. Dividing by zero is defined to return `0`.

---

## Possible Extensions

- Self-checking testbench with expected-value comparison and pass/fail reporting
- Test coverage for logic, shift and modulo operations
- Registered (clocked) output stage for pipelining
- Rotate-left/right operations and a carry-in input
- FPGA synthesis results (LUT count, max frequency) on a target board

---

## Tools

Verilog HDL · Vivado / Icarus Verilog / GTKWave

## License

Released under the MIT License. Add a `LICENSE` file to the repo if you choose this.
