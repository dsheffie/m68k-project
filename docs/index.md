# Project m68k

Run 68040 software (NeXTSTEP, Mac OS, Linux/m68k) on an out-of-order core
derived from superdupersparc. The core executes only a micro-op ISA, **uisa**;
68k instructions reach it two ways:

- **PLA path.** Common 68k instructions are length-decoded in hardware and
  translated by PLAs directly into internal uops.
- **Millicode path.** Everything else (complex addressing modes, MOVEM,
  bitfields, BCD, exceptions, MMU and cache control, floating point) jumps to
  millicode: ordinary uisa code in hidden memory, written in a C subset and
  compiled by our own compiler, `ucc`.

On a NeXTSTEP 2.2 boot to the desktop, about 95% of executed 68k instructions
take the PLA path (see [PLA flow coverage](uisa/flows.md)).

## The pieces

| Component | What it is | Docs |
|---|---|---|
| [uisa](uisa/index.md) | The micro-op ISA, defined in one YAML file; generators for the decoder, ISS, assembler and manual; the 68040 translation (PLA flows); millicode; the ucc compiler | [Manual (PDF)](uisa/uisa.pdf){ .md-button .md-button--primary } [Reference (web)](uisa/reference.md){ .md-button } |
| [The core](core.md) | The out-of-order RTL core that executes uisa | [Overview](core.md) |
| [q800sim](q800sim.md) | A functional Quadra 800 (68040) full-system simulator; the golden reference for uisa and the RTL, and a host for running uisa on real software | [Overview](q800sim.md) |

## Source

- uisa: [github.com/dsheffie/uisa](https://github.com/dsheffie/uisa)
- The core and q800sim are not public yet.
