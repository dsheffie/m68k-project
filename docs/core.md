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

## Block diagram

<figure class="core-fig" markdown="0">
<svg viewBox="0 0 1000 790" role="img" aria-labelledby="core-fig-title core-fig-desc" xmlns="http://www.w3.org/2000/svg">
<title id="core-fig-title">Block diagram of the out-of-order core in 68k mode</title>
<desc id="core-fig-desc">A front end, mostly a C++ model with the dec68k PLA decoder in RTL, feeds a decode queue, two-wide rename and a 16-entry ROB. Allocation fills integer, memory and FP queues, which feed ALU0, multiply and divide; the LSU and L1D; and the FPU. The L1D and the front end's L1I fill from an inclusive 512 KB L2 in front of DRAM.</desc>
<defs><marker id="core-arr" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse"><path class="head" d="M0,0 L10,5 L0,10 z"/></marker></defs>
<rect class="fe" x="40" y="24" width="940" height="196" rx="10"/>
<text class="t" x="58" y="47">Front end: work in progress</text>
<text class="s" x="58" y="66">fe68k.cc, a C++ model called once a cycle through DPI; being moved to RTL piece by piece</text>
<rect class="cxx" x="56" y="82" width="280" height="122" rx="6"/>
<text class="t" x="70" y="104">Fetch and prediction (C++)</text>
<text x="70" y="124">L1I: 4 KB, 4-way, 16 B lines, predecode</text>
<text x="70" y="142">ITLB: 16 entries, fully associative</text>
<text x="70" y="160">BTB 256 × 4 ways, RAS 8</text>
<text x="70" y="178">gshare: 4K 2-bit counters, 12-bit GHR</text>
<rect class="cxx" x="356" y="82" width="240" height="122" rx="6"/>
<text class="t" x="370" y="104">68k decode (C++)</text>
<text x="370" y="124">2 instructions / cycle</text>
<text x="370" y="142">long flows (MOVEM, chunked)</text>
<text x="370" y="160">millicode sequencer,</text>
<text x="370" y="178">7,934-word millicode ROM</text>
<rect class="box rtl" x="616" y="82" width="348" height="122" rx="6"/>
<text class="t" x="630" y="104">dec68k (RTL)</text>
<text x="630" y="124">4-entry instruction queue, 2 decoders</text>
<text x="630" y="142">PLA ROM: 1,466 templates, 4,018 rows</text>
<text x="630" y="160">rows of 1–4 uops; 61,970 of 65,536 opwords</text>
<text x="630" y="178">up to 4 uops / cycle to the decode queue</text>
<line class="wire" x1="336" y1="143" x2="354" y2="143"/>
<line class="wire" x1="596" y1="143" x2="614" y2="143"/>
<rect class="box" x="816" y="262" width="148" height="96" rx="6"/>
<text class="t" x="830" y="286">Decode queue</text>
<text x="830" y="306">8 uops</text>
<text x="830" y="324">≤ 4 in / cycle</text>
<rect class="box" x="436" y="262" width="360" height="96" rx="6"/>
<text class="t" x="450" y="286">Rename and allocate, 2 / cycle</text>
<text x="450" y="306">int PRF 256 (ALU and load banks), 5 read, 2 write</text>
<text x="450" y="324">FP PRF 64 · flags: NZVC 16, X 16</text>
<text x="450" y="342">4 free-list pools · no checkpoints</text>
<rect class="box" x="56" y="262" width="360" height="96" rx="6"/>
<text class="t" x="70" y="286">ROB: 16 entries, retire 2 / cycle</text>
<text x="70" y="306">every flush at retire: RAT ← retire RAT</text>
<text x="70" y="324">checked in lockstep against q800sim</text>
<text x="70" y="342">at every 68k instruction boundary</text>
<line class="wire" x1="890" y1="204" x2="890" y2="260"/>
<line class="wire" x1="816" y1="310" x2="798" y2="310"/>
<line class="wire" x1="436" y1="310" x2="418" y2="310"/>
<line class="wire dash" x1="200" y1="262" x2="200" y2="206"/>
<text class="s" x="210" y="240">redirect</text>
<path class="wire" d="M616,358 V384"/>
<path class="bus" d="M206,384 H830"/>
<line class="wire" x1="206" y1="384" x2="206" y2="408"/>
<line class="wire" x1="526" y1="384" x2="526" y2="408"/>
<line class="wire" x1="830" y1="384" x2="830" y2="408"/>
<rect class="box" x="56" y="410" width="300" height="44" rx="6"/>
<text class="t" x="70" y="437">Integer uop queue · 8</text>
<rect class="box" x="56" y="470" width="300" height="44" rx="6"/>
<text class="t" x="70" y="490">ALU scheduler · 4</text>
<text class="s" x="70" y="506">age matrix, issues 1 / cycle</text>
<rect class="box" x="56" y="530" width="110" height="74" rx="6"/>
<text class="t" x="66" y="551">ALU0</text>
<text class="s" x="66" y="569">guest ops,</text>
<text class="s" x="66" y="585">branches · 1 cyc</text>
<rect class="box" x="174" y="530" width="76" height="74" rx="6"/>
<text class="t" x="184" y="551">MUL</text>
<text class="s" x="184" y="569">pipelined</text>
<text class="s" x="184" y="585">3 cyc</text>
<rect class="box" x="258" y="530" width="98" height="74" rx="6"/>
<text class="t" x="268" y="551">DIV</text>
<text class="s" x="268" y="569">≤ 34 cyc, also</text>
<text class="s" x="268" y="585">FP div / sqrt</text>
<line class="wire" x1="206" y1="454" x2="206" y2="468"/>
<line class="wire" x1="111" y1="514" x2="111" y2="528"/>
<line class="wire" x1="212" y1="514" x2="212" y2="528"/>
<line class="wire" x1="307" y1="514" x2="307" y2="528"/>
<rect class="box" x="386" y="410" width="280" height="44" rx="6"/>
<text class="t" x="400" y="437">Memory uop queue · 4</text>
<rect class="box" x="386" y="470" width="280" height="44" rx="6"/>
<text class="t" x="400" y="490">LSU · 6 entries, 1 / cycle</text>
<text class="s" x="400" y="506">store buffer · CAS and MOVE16 uops</text>
<rect class="box" x="386" y="530" width="170" height="74" rx="6"/>
<text class="t" x="398" y="551">L1D · 64 KB</text>
<text class="s" x="398" y="569">direct-mapped, 16 B lines</text>
<text class="s" x="398" y="585">non-blocking, 3 miss engines</text>
<rect class="box" x="564" y="530" width="102" height="74" rx="6"/>
<text class="t" x="574" y="551">D-ATC · 16</text>
<text class="s" x="574" y="569">68040 table</text>
<text class="s" x="574" y="585">walker (shared)</text>
<line class="wire" x1="526" y1="454" x2="526" y2="468"/>
<line class="wire" x1="471" y1="514" x2="471" y2="528"/>
<line class="wire" x1="615" y1="514" x2="615" y2="528"/>
<rect class="box" x="696" y="410" width="268" height="44" rx="6"/>
<text class="t" x="710" y="430">FP uop queue · 8</text>
<text class="s" x="710" y="446">issued in order, 1 / cycle</text>
<rect class="box" x="696" y="470" width="268" height="134" rx="6"/>
<text class="t" x="710" y="492">FPU · double precision</text>
<text x="710" y="512">add, sub, mul, compare: 4 cyc</text>
<text x="710" y="530">convert f2i, i2f, f2f: 1 cyc</text>
<text x="710" y="548">div, sqrt on the shared divider</text>
<text x="710" y="566">68k extended computed as double</text>
<text x="710" y="584">transcendentals in millicode</text>
<line class="wire" x1="830" y1="454" x2="830" y2="468"/>
<rect class="box" x="56" y="652" width="700" height="78" rx="6"/>
<text class="t" x="70" y="676">L2 · 512 KB, direct-mapped, 16 B lines</text>
<text x="70" y="696">inclusive of the L1D and the L1I, kept so with back-invalidate probes</text>
<text x="70" y="714">fills the L1D and, since FETCH-L2, the front end's L1I</text>
<rect class="box" x="786" y="652" width="178" height="78" rx="6"/>
<text class="t" x="800" y="676">DRAM</text>
<text x="800" y="696">one request port</text>
<text x="800" y="714">36-bit physical address</text>
<line class="wire" x1="471" y1="604" x2="471" y2="650"/>
<line class="wire" x1="756" y1="691" x2="784" y2="691"/>
<path class="wire" d="M56,180 H26 V691 H54"/>
<text class="s" x="0" y="0" transform="translate(20,470) rotate(-90)" text-anchor="middle">L1I fills from the L2</text>
<rect class="cxx" x="300" y="752" width="26" height="16" rx="3"/>
<text class="s" x="334" y="765">C++ model (front end, WIP)</text>
<rect class="box rtl" x="560" y="752" width="26" height="16" rx="3"/>
<text class="s" x="594" y="765">RTL in the front end</text>
<rect class="box" x="760" y="752" width="26" height="16" rx="3"/>
<text class="s" x="794" y="765">RTL</text>
</svg>
<figcaption>The core in 68k mode, at its default configuration. The back end is
RTL and complete; most of the front end is still a C++ model. Only ALU0 is
enabled (ALU1 exists but is off).</figcaption>
</figure>

## The front end is work in progress

The back end is RTL: rename, the ROB, the three queues, the execution
units, the LSU, the L1D, the 68040 ATC and table walker, and the L2. Most of
the 68k front end is still a C++ model, `fe68k.cc`, which the simulation
calls once a cycle through DPI and whose outputs are registered. That model
holds the L1I, the ITLB, branch prediction, 68k decode, long flows and the
millicode sequencer.

Its move to RTL is being done piece by piece. `dec68k.sv`, the PLA decoder
that turns the common 68k instructions into at most four uops each, runs in
RTL in simulation. The millicode ROM, the long-flow ROM, 68k decode, the
aligner, the L1I, the ITLB and the predictor are still C++.

!!! note
    The core's source is not public yet.
