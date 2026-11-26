# q800sim

A functional Macintosh Quadra 800 (68040) full-system simulator: a plain,
readable 68040 interpreter meant to be the golden reference for the uisa
micro-engine and its RTL, plus the Quadra 800 machine around it. The address
map and device behavior follow qemu's `q800` machine (reimplemented, not
copied), so runs can be diffed against `qemu-system-m68k -M q800`.

## What it models

- **CPU:** the 68040 integer instruction set, the 68040 MMU (table walk,
  transparent translation, PTEST), exceptions with 68040 frames, interrupts,
  STOP, trace.
- **FPU:** the 68881 instruction set, with the arithmetic in SoftFloat-3
  binary64 and the 68881's NaN and underflow rules. This is the reference for
  uisa's FP extension.
- **Machine:** RAM, ROM, VIA1/VIA2, the SCC console, the 53C96 ESP SCSI
  controller with disk and CD-ROM targets, SONIC Ethernet with a user-mode NAT
  backend, direct Linux boot, checkpoints.

## Two execution engines

`--engine interp` (the default) runs the 68040 interpreter.
`--engine uisa` runs guest instructions as uisa code instead: the PLA
micro-op flows, the MOVEM sequencer and millicode, from a uisa checkout.
uisa's loads go through the simulator's MMU and bus, and its exceptions are
taken in uisa millicode.

`--uisa-check` checks every instruction uisa runs against the interpreter
before committing it (registers, SR, PC, control registers and the bytes
stored), so a full OS boot doubles as a uisa co-simulation.

!!! note
    q800sim's source is not public yet.
