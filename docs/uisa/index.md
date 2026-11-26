# uisa

uisa is the micro-op ISA the core executes: a clean 32-bit RISC base (fixed
32-bit instructions, load/store, three-operand ALU ops, compare-and-branch)
plus the 68k's semantics as first-class operations (sized operands, the five
flags with X split out, BCD, rotate through X, address spaces with function
codes), so neither the PLA nor the compiler has to emulate them with long
sequences. Nothing implicit is left for renaming to undo: partial register
writes, partial flag writes and data-dependent register numbers are all
visible at the instruction level.

Everything is machine-readable. `spec/uisa.yaml` is the only definition of
the ISA; the decoders, the ISS, the assembler and the reference chapters of
the manual are generated from it.

## Documents

[Reference manual (PDF)](uisa.pdf){ .md-button .md-button--primary }
[Reference (web)](reference.md){ .md-button }

- **[Design rationale](rationale.md):** register namespace, flags, sized
  operations, memory and address spaces, millicode rules, entry and exit,
  floating point, open questions.
- **[Reference](reference.md):** generated from `spec/uisa.yaml`: formats,
  the opcode map, every operation, conditions, CSRs and millicode entry
  points. The PDF has the rationale and the reference laid out one page per
  instruction, plus a chapter listing every 68k instruction form's PLA flow.
- **[PLA flow coverage](flows.md):** how much of a NeXTSTEP 2.2 boot to the
  desktop the PLA path covers, and the uops per 68k instruction.
- **[The ucc compiler](ucc.md):** the C-subset compiler for millicode, which
  allocates registers in SSA so "fits without spilling" is a static check.
- **[SoftFloat in millicode](softfloat.md):** the SoftFloat port in the
  millicode C subset.

Source: [github.com/dsheffie/uisa](https://github.com/dsheffie/uisa).
