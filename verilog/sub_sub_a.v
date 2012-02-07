module sub_sub_a (/*AUTOARG*/
   // Outputs
   testo1_sub_a,
   // Inputs
   testi1_sub_a, testi1_sub_clk_a
   );

   input testi1_sub_a;
   input testi1_sub_clk_a;
   output testo1_sub_a;

   always @*
     if (testi1_sub_clk_a) testo1_sub_a <= testi1_sub_a;

endmodule
