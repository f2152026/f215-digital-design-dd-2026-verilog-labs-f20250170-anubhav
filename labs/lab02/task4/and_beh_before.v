module and_beh_before (
  input  a, b,
  output reg y
);

  always @(a, b) begin
    #5;
    y = a & b;
  end

endmodule