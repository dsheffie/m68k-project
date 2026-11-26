# Formal spec

A machine-readable formal specification of the 68k's user-mode integer
instructions, for checking the core's translation of them. It is Robert S.
Boyer and Yuan Yu's MC68020 specification in Nqthm (public domain), run
directly in Python and lifted from there to SMT-LIB for z3.

**Background:** [how the 1992 semantics worked, why SMT, and reusing the
semantics under a different modelling approach](background.md).

**Repository:** [github.com/dsheffie/m68k-formal-spec](https://github.com/dsheffie/m68k-formal-spec)

**Original sources:**

- [The Nqthm-1992 examples](https://www.cs.utexas.edu/~boyer/nqthm-1992-examples.html)
  (the spec is `examples/yu/mc20-1.events`, its lemmas `mc20-2.events`)
- R. S. Boyer and Y. Yu, the MC68020 specification,
  [UT Austin TR-92-04](https://www.cs.utexas.edu/ftp/techreports/tr92-04.pdf)
- Y. Yu, PhD thesis,
  [UT Austin TR-93-09](https://www.cs.utexas.edu/ftp/techreports/tr93-09.pdf)

## How it fits the project

The core executes 68k instructions as [uisa](../uisa/index.md) micro-ops, and
the common ones go through PLA templates
([PLA flow coverage](../uisa/flows.md)). The planned use of this spec is a z3
proof, for each 68k instruction, that its PLA template computes exactly what
the spec says: the same registers, condition codes, PC and memory for every
input. That proof is in progress and not done yet; what exists today is the
lifted spec and its validation, described below.

The spec is of the 68020's user-mode integer set, which the 68040 shares. It
does not cover what millicode handles (bitfields, BCD, CAS/CAS2, supervisor
instructions, the FPU), exceptions or the MMU.

!!! note
    The rest of this page is the repository's `README.md` and
    `nqthm/README.md`, pulled when the site is built.
