// tb.v
// Self-checking testbench for alu.
// Drives a, b, op through combinations designed to expose:
//   1. A sensitivity-list bug (op changes but a,b don't change with it)
//   2. A blocking/non-blocking bug in the subtract path

module tb;

  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;

  integer errors;
  reg [3:0] expected;

  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  task check;
    begin
      if (t_op == 1'b0)
        expected = t_a + t_b;
      else
        expected = t_a - t_b;

      if (t_result !== expected) begin
        $display("FAIL: a=%0d b=%0d op=%b -> expected result=%0d, got %0d",
                  t_a, t_b, t_op, expected, t_result);
        errors = errors + 1;
      end else begin
        $display("PASS: a=%0d b=%0d op=%b -> result=%0d", t_a, t_b, t_op, t_result);
      end
    end
  endtask

  initial begin
    errors = 0;

    // Set a, b once, then flip ONLY op -- exposes the sensitivity-list bug
    // if result doesn't update on an op-only change.
    t_a = 4'd5; t_b = 4'd3; t_op = 1'b0; #5; check;
    t_op = 1'b1;           #5; check;   // a,b unchanged, only op flips
    t_op = 1'b0;           #5; check;   // flip back, still a,b unchanged

    // Now vary a/b together with op, exposing the blocking/non-blocking
    // bug in the subtract path (stale b_inv/b_twos from a previous eval).
    t_a = 4'd9; t_b = 4'd4; t_op = 1'b1; #5; check;
    t_a = 4'd2; t_b = 4'd7; t_op = 1'b1; #5; check;
    t_a = 4'd6; t_b = 4'd6; t_op = 1'b1; #5; check;
    t_a = 4'd0; t_b = 4'd1; t_op = 1'b1; #5; check;

    // A few adds interleaved for good measure
    t_a = 4'd8; t_b = 4'd8; t_op = 1'b0; #5; check;
    t_a = 4'd1; t_b = 4'd1; t_op = 1'b1; #5; check;

    if (errors == 0)
      $display("*** ALL TESTS PASSED ***");
    else
      $display("*** %0d ERROR(S) FOUND ***", errors);

    $finish;
  end

endmodule