// tb.v
// Starter testbench template -- completed.

module tb;

// Inputs/outputs sized to match lut's default parameters (WIDTH=8, DEPTH=4)
// sel is $clog2(DEPTH) = $clog2(4) = 2 bits wide.
reg  [1:0] t_sel;
wire [7:0] t_dout;

// Instantiate DUT -- instance must be named DUT to match $dumpvars below.
lut DUT (
  .sel  (t_sel),
  .dout (t_dout)
);

// Waveform dump configuration (DO NOT CHANGE)
string vcd_file;
initial begin
  if ($value$plusargs("vcd=%s", vcd_file)) begin
    $dumpfile(vcd_file);
    $dumpvars(0, DUT);
  end
end

initial begin
  // Apply every valid sel value (0 to DEPTH-1), 5 time units apart
  t_sel = 2'd0; #5;
  t_sel = 2'd1; #5;
  t_sel = 2'd2; #5;
  t_sel = 2'd3; #5;
  $finish;
end

initial
    $monitor($time, " sel=%b | dout=%d", t_sel, t_dout);

endmodule