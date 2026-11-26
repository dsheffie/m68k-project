# The core

The out-of-order core that runs uisa is derived from superdupersparc, an
out-of-order SPARC V8 core (itself forked from r9999). It is a 32-bit
renamed machine with flags, and it executes only the
[uisa micro-op ISA](uisa/index.md): its decoder (`decode_uisa.sv`), ALU
(`uisa_alu.sv`) and guest-semantic ops (`uisa_gop.sv`) are built from the
tables uisa generates from `spec/uisa.yaml`, and the FPU is the core's
double-precision unit, which uisa's FP extension exposes to millicode.

The PLA translation of common 68k instructions and the millicode for the
rest are documented in the [uisa reference](uisa/reference.md).

!!! note
    The core's source is not public yet.
