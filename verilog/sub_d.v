module sub_d (/*AUTOARG*/
   // Outputs
   testo1_d, testo2_d, testo1_sub_d,
   // Inputs
   testi1_d, testi2_d, testi3_d
   );

   input 	testi1_d;
   input  testi2_d;
   input        testi3_d;

   output       testo1_d;
   output [1:0] testo2_d;
   output       testo1_sub_d;

   wire         testi1_sub_d;
   wire         testi1_sub_clk_d;
   
   assign testo1_d = testi1_d + testi2_d;
   assign testo2_d = {testi2_d ^ testi3_d, 1'b0};
   assign testi1_sub_d = testi1_d ^ testi3_d;
   assign testi1_sub_clk_d = testo1_d;

   sub_sub_d sub_sub_d (/*AUTOINST*/
                        // Outputs
                        .testo1_sub_d   (testo1_sub_d),
                        // Inputs
                        .testi1_sub_d   (testi2_d),
                        .testi1_sub_clk_d(testi1_sub_clk_d));

endmodule

   