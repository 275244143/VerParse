module sub_a (/*AUTOARG*/
   reset_n, floating_input, zero_tied, bus_in,
   // Outputs
   testo1_a, testo2_a, testo1_sub_a,
   // Inputs
   testi1_a, testi2_a, testi3_a
   );

   input        floating_input;
   input 	testi1_a;
   input  testi2_a;
   input        testi3_a;
   input        reset_n;
   input        zero_tied;
   input [2:0]  bus_in;

   output       testo1_a;
   output testo2_a;
   output       testo1_sub_a;

   wire         testi1_sub_a;
   wire         testi1_sub_clk_a;
   wire         test1;

   assign test1 = floating_input | testi1_a | bus_in[1];
   assign testo1_a = testi1_a + testi2_a;
   assign testo2_a = testi2_a ^ testi3_a;
   assign testi1_sub_a = testi1_a ^ testi3_a;
   assign testi1_sub_clk_a = testo1_a | reset_n | zero_tied | bus_in[0];

   sub_sub_a sub_sub_a_i0 (/*AUTOINST*/
                           // Outputs
                           .testo1_sub_a        (testo1_sub_a),
                           // Inputs
                           .testi1_sub_a        (testi1_sub_a),
                           .testi1_sub_clk_a    (testi1_sub_clk_a));

endmodule

   