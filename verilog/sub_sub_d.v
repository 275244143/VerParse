module sub_sub_d (/*AUTOARG*/
   // Outputs
   testo1_sub_d,
   // Inputs
   testi1_sub_d, testi1_sub_clk_d
   );

   input testi1_sub_d;
   input testi1_sub_clk_d;
   output testo1_sub_d;

   always @*
     if (testi1_sub_clk_d) testo1_sub_d <= testi1_sub_d;

endmodule
