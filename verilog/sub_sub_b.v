module sub_sub_b (/*AUTOARG*/
   // Outputs
   testo1_sub_b,
   // Inputs
   testi1_sub_b, testi1_sub_clk_b
   );

   input testi1_sub_b;
   input testi1_sub_clk_b;
   output testo1_sub_b;

   always @*
     if (testi1_sub_clk_b) testo1_sub_b <= testi1_sub_b;

endmodule
