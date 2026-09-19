module and_beh_intra (
  input  a, b,
  output reg y
);

  always @(a, b)
    y = #5 (a & b);

endmodule