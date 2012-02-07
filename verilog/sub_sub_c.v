module sub_sub_c (/*AUTOARG*/
   // Outputs
   testo1_sub_c,
   // Inputs
   testi1_sub_c, testi1_sub_clk_c
   );

   input testi1_sub_c;
   input testi1_sub_clk_c;
   output testo1_sub_c;

   always @*
     if (testi1_sub_clk_c) testo1_sub_c <= testi1_sub_c;

endmodule
