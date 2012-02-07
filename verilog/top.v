module top (/*AUTOARG*/
   // Outputs
   top_out, testo1_a
   );

`define TEST_DEFINE 3'b100
`define ANOTHER_DEFINE 4'b1111
   
   output top_out;
   output testo1_a;

   wire                 testi2_b;
   wire                 testi2_d_rename;
   wire                 reset;
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire                 testo1_b;               // From sub_b_i0 of sub_b.v
   wire                 testo1_c;               // From sub_c_i0 of sub_c.v
   wire                 testo1_d;               // From sub_d_i0 of sub_d.v
   wire                 testo1_sub_a;           // From sub_a_i0 of sub_a.v
   wire                 testo1_sub_b_rename_again;    // From sub_b_i0 of sub_b.v
   wire                 testo1_sub_c;           // From sub_c_i0 of sub_c.v
   wire                 testo1_sub_d;           // From sub_d_i0 of sub_d.v
   wire                 testo2_a;               // From sub_a_i0 of sub_a.v
   wire                 testo2_b;               // From sub_b_i0 of sub_b.v
   wire                 testo2_c;               // From sub_c_i0 of sub_c.v
   wire  [1:0]          testo2_d;               // From sub_d_i0 of sub_d.v
   // End of automatics
   
   assign reset  = ~top_out;
   assign top_out = testo1_a | testo1_b | testo1_c | testo1_d;
   assign testi2_d_rename = testo2_a;
   assign {testi1_b, testi2_b} = testo2_d;

   sub_a sub_a_i0 (
                   .floating_input      (      ),
                   .zero_tied           ( 1'b0 ),
                   .reset_n             (~reset),
                   .bus_in              ({testo1_sub_c, testo2_d[1], 1'b0}),
                   /*AUTOINST*/
                   // Outputs
                   .testo1_a            (testo1_a),
                   .testo2_a            (testo2_a),
                   .testo1_sub_a        (testo1_sub_a),
                   // Inputs
                   .testi1_a            (testi1_a),
                   .testi2_a            (testi2_a),
                   .testi3_a            (testi3_a));

   sub_b sub_b_i0 (/*AUTOINST*/
                   // Outputs
                   .testo1_b            (testo1_b),
                   .testo2_b            (testo2_b),
                   .testo1_sub_b_rename (testo1_sub_b_rename_again),
                   // Inputs
                   .testi1_b            (testo1_c),
                   .testi2_b            (testi2_b),
                   .testi3_b            (testi3_b));

   sub_c sub_c_i0 (/*AUTOINST*/
                   // Outputs
                   .testo1_c            (testo1_c),
                   .testo2_c            (testo2_c),
                   .testo1_sub_c        (testo1_sub_c),
                   // Inputs
                   .testi1_c            (testi1_c),
                   .testi2_c            (testi2_c),
                   .testi3_c            (testi3_c),
                   .testi1_sub_c_rename (testo1_sub_b_rename_again));

   sub_d sub_d_i0 (/*AUTOINST*/
                   // Outputs
                   .testo1_d            (testo1_d),
                   .testo2_d            (testo2_d),
                   .testo1_sub_d        (testo1_sub_d),
                   // Inputs
                   .testi1_d            (testi1_d),
                   .testi2_d            (testi2_d_rename),
                   .testi3_d            (testi3_d));

endmodule