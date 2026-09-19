module tb;

  reg  [1:0] t_a, t_b;
  wire       t_gt, t_lt, t_eq;

  integer errors;
  integer onehot_count;
  integer i, j;   // loop counters, wide enough to actually reach 4

  comp2 DUT (
    .A  (t_a),
    .B  (t_b),
    .GT (t_gt),
    .LT (t_lt),
    .EQ (t_eq)
  );

  initial begin
    errors = 0;

    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        t_a = i;
        t_b = j;
        #5;

        onehot_count = t_gt + t_lt + t_eq;
        if (onehot_count != 1) begin
          $display("FAIL (one-hot): A=%0d B=%0d -> GT=%b LT=%b EQ=%b (expected exactly one high, got %0d)",
                    t_a, t_b, t_gt, t_lt, t_eq, onehot_count);
          errors = errors + 1;
        end

        if (t_a > t_b && !t_gt) begin
          $display("FAIL (GT): A=%0d B=%0d -> expected GT=1, got GT=%b", t_a, t_b, t_gt);
          errors = errors + 1;
        end
        if (t_a < t_b && !t_lt) begin
          $display("FAIL (LT): A=%0d B=%0d -> expected LT=1, got LT=%b", t_a, t_b, t_lt);
          errors = errors + 1;
        end
        if (t_a == t_b && !t_eq) begin
          $display("FAIL (EQ): A=%0d B=%0d -> expected EQ=1, got EQ=%b", t_a, t_b, t_eq);
          errors = errors + 1;
        end

        $display("%0t: A=%0d B=%0d | GT=%b LT=%b EQ=%b", $time, t_a, t_b, t_gt, t_lt, t_eq);
      end
    end

    if (errors == 0)
      $display("*** ALL TESTS PASSED ***");
    else
      $display("*** %0d ERROR(S) FOUND ***", errors);

    $finish;
  end

endmodule