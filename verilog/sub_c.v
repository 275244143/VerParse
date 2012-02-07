module sub_c (/*AUTOARG*/
   // Outputs
   testo1_c, testo2_c, testo1_sub_c,
   // Inputs
   testi1_c, testi2_c, testi3_c, testi1_sub_c_rename
   );

   input 	testi1_c;
   input  testi2_c;
   input        testi3_c;
   input        testi1_sub_c_rename;

   output       testo1_c;
   output testo2_c;
   output       testo1_sub_c;

   wire         testi1_sub_c_rename;
   wire         testi1_sub_clk_c;
   
   assign testo1_c = testi1_c + testi2_c;
   assign testo2_c = testi2_c ^ testi3_c;
//   assign testi1_sub_c_rename = testi1_c ^ testi3_c;
   assign testi1_sub_clk_c = testo1_c;

   sub_sub_c sub_sub_c_i0 (/*AUTOINST*/
                           // Outputs
                           .testo1_sub_c        (testo1_sub_c),
                           // Inputs
                           .testi1_sub_c        (testi1_sub_c_rename),
                           .testi1_sub_clk_c    (testi1_sub_clk_c));

endmodule

   