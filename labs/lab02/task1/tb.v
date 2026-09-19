// tb.v
// Starter testbench template -- completed.
//
// Goal: apply all 8 combinations of I0, I1, S (5 time units apart) to DUT
// and observe the output.

module tb;

// Inputs to the DUT must be variables, since the testbench drives them
// procedurally (inside an initial block) — they act like the "switches"
// we control by hand.
reg   t_i0, t_i1, t_s;

// Output from the DUT must be a net, since it's driven by whatever
// continuous/procedural logic lives inside the DUT, not by this testbench.
wire  t_y;

// Instantiate DUT, connecting by name
DUT U0 (
  .I0 (t_i0),
  .I1 (t_i1),
  .S  (t_s),
  .Y  (t_y)
);

// Waveform dump configuration
string vcd_file;
initial begin
  if ($value$plusargs("vcd=%s", vcd_file)) begin
    $dumpfile(vcd_file);
   $dumpvars(0, U0);
  end
end

initial begin
  // Apply all 8 combinations of t_i0, t_i1, t_s, 5 time units apart
  {t_i0, t_i1, t_s} = 3'b000; #5;
  {t_i0, t_i1, t_s} = 3'b001; #5;
  {t_i0, t_i1, t_s} = 3'b010; #5;
  {t_i0, t_i1, t_s} = 3'b011; #5;
  {t_i0, t_i1, t_s} = 3'b100; #5;
  {t_i0, t_i1, t_s} = 3'b101; #5;
  {t_i0, t_i1, t_s} = 3'b110; #5;
  {t_i0, t_i1, t_s} = 3'b111; #5;
  $finish;
end

initial
    $monitor($time, " I0=%b I1=%b S=%b | Y=%b", t_i0, t_i1, t_s, t_y);

endmodule