module sub_b (/*AUTOARG*/
   // Outputs
   testo1_b, testo2_b, testo1_sub_b_rename,
   // Inputs
   testi1_b, testi2_b, testi3_b
   );

   input 	testi1_b;
   input  testi2_b;
   input        testi3_b;

   output       testo1_b;
   output testo2_b;
   output       testo1_sub_b_rename;

   wire         testi1_sub_b;
   wire         testi1_sub_clk_b;
   
   assign testo1_b = testi1_b + testi2_b;
   assign testo2_b = testi2_b ^ testi3_b;
   assign testi1_sub_b = testi1_b ^ testi3_b;
   assign testi1_sub_clk_b = testo1_b;

   sub_sub_b sub_sub_b_i0 (/*AUTOINST*/
                           // Outputs
                           .testo1_sub_b        (testo1_sub_b_rename),
                           // Inputs
                           .testi1_sub_b        (testi1_sub_b),
                           .testi1_sub_clk_b    (testi1_sub_clk_b));

endmodule

   