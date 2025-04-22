module mesh_3x3(
    input clk,
    input reset,
    input [63:0]PE_0_in_packet, PE_1_in_packet, PE_2_in_packet, PE_4_in_packet, PE_5_in_packet, PE_6_in_packet,
    input [63:0]PE_8_in_packet, PE_9_in_packet, PE_10_in_packet,
    input si_0_PE, si_1_PE, si_2_PE, si_4_PE, si_5_PE, si_6_PE, si_8_PE, si_9_PE, si_10_PE,
    input ro_0_PE, ro_1_PE, ro_2_PE,  ro_4_PE,  ro_5_PE,  ro_6_PE,  ro_8_PE,  ro_9_PE,  ro_10_PE,
    output [63:0]PE_0_out_packet, PE_1_out_packet, PE_2_out_packet, PE_4_out_packet, PE_5_out_packet, PE_6_out_packet,
    output [63:0]PE_8_out_packet, PE_9_out_packet, PE_10_out_packet,
    output so_0_PE, so_1_PE, so_2_PE, so_4_PE, so_5_PE, so_6_PE, so_8_PE, so_9_PE, so_10_PE,
    output ri_0_PE,  ri_1_PE, ri_2_PE, ri_4_PE, ri_5_PE,  ri_6_PE, ri_8_PE,  ri_9_PE,  ri_10_PE,
    output polarity_PE_0, polarity_PE_1, polarity_PE_2, polarity_PE_4, polarity_PE_5, polarity_PE_6, polarity_PE_8, 
    output polarity_PE_9, polarity_PE_10              
);   


wire hs[95:0];
wire [63:0]packet[77:0];
 // Dummy wires for boundary connections
wire dummy_wire;
wire [63:0] dummy_packet;

gold_router r0(.clk(clk), .reset(reset),
    .si_E(hs[2]), .si_W(dummy_wire), .si_S(dummy_wire), .si_N(hs[14]), .si_PE(si_0_PE),
    .ro_E(hs[1]), .ro_W(dummy_wire), .ro_S(dummy_wire), .ro_N(hs[13]), .ro_PE(ro_0_PE),
    .E_packet_in(packet[3]), .W_packet_in(dummy_packet), .S_packet_in(dummy_packet), .N_packet_in(packet[15]), .PE_packet_in(PE_0_in_packet),
    .ri_E(hs[3]), .ri_W(dummy_wire), .ri_S(dummy_wire), .ri_N(hs[15]), .ri_PE(ri_0_PE),
    .so_E(hs[0]), .so_W(dummy_wire), .so_S(dummy_wire), .so_N(hs[12]), .so_PE(so_0_PE),
    .router_out_E(packet[2]), .router_out_W(dummy_packet), .router_out_S(dummy_packet), .router_out_N(packet[14]), .router_out_PE(PE_0_out_packet), 
    .polarity(polarity_PE_0));

gold_router r1(.clk(clk), .reset(reset),
    .si_E(hs[6]), .si_W(hs[0]), .si_S(dummy_wire), .si_N(hs[18]), .si_PE(si_1_PE),
    .ro_E(hs[5]), .ro_W(hs[3]), .ro_S(dummy_wire), .ro_N(hs[17]), .ro_PE(ro_1_PE),
    .E_packet_in(packet[7]), .W_packet_in(packet[2]), .S_packet_in(dummy_packet), .N_packet_in(packet[17]), .PE_packet_in(PE_1_in_packet),
    .ri_E(hs[7]), .ri_W(hs[1]), .ri_S(dummy_wire), .ri_N(hs[19]), .ri_PE(ri_1_PE),
    .so_E(hs[4]), .so_W(hs[2]), .so_S(dummy_wire), .so_N(hs[16]), .so_PE(so_1_PE),
    .router_out_E(packet[6]), .router_out_W(packet[3]), .router_out_S(dummy_packet), .router_out_N(packet[16]), .router_out_PE(PE_1_out_packet), 
    .polarity(polarity_PE_1));

gold_router r2(.clk(clk), .reset(reset),
    .si_E(hs[10]), .si_W(hs[4]), .si_S(dummy_wire), .si_N(hs[22]), .si_PE(si_2_PE),
    .ro_E(hs[9]), .ro_W(hs[7]), .ro_S(dummy_wire), .ro_N(hs[21]), .ro_PE(ro_2_PE),
    .E_packet_in(packet[11]), .W_packet_in(packet[6]), .S_packet_in(dummy_packet), .N_packet_in(packet[19]), .PE_packet_in(PE_2_in_packet),
    .ri_E(hs[11]), .ri_W(hs[5]), .ri_S(dummy_wire), .ri_N(hs[23]), .ri_PE(ri_2_PE),
    .so_E(hs[8]), .so_W(hs[6]), .so_S(dummy_wire), .so_N(hs[20]), .so_PE(so_2_PE),
    .router_out_E(packet[10]), .router_out_W(packet[7]), .router_out_S(dummy_packet), .router_out_N(packet[18]), .router_out_PE(PE_2_out_packet), 
    .polarity(polarity_PE_2));


gold_router r4(.clk(clk), .reset(reset),
    .si_E(hs[30]), .si_W(dummy_wire), .si_S(hs[12]), .si_N(hs[42]), .si_PE(si_4_PE),
    .ro_E(hs[29]), .ro_W(dummy_wire), .ro_S(hs[15]), .ro_N(hs[41]), .ro_PE(ro_4_PE),
    .E_packet_in(packet[25]), .W_packet_in(dummy_packet), .S_packet_in(packet[14]), .N_packet_in(packet[37]), .PE_packet_in(PE_4_in_packet),
    .ri_E(hs[31]), .ri_W(dummy_wire), .ri_S(hs[13]), .ri_N(hs[43]), .ri_PE(ri_4_PE),
    .so_E(hs[28]), .so_W(dummy_wire), .so_S(hs[14]), .so_N(hs[40]), .so_PE(so_4_PE),
    .router_out_E(packet[24]), .router_out_W(dummy_packet), .router_out_S(packet[15]), .router_out_N(packet[36]), .router_out_PE(PE_4_out_packet), 
    .polarity(polarity_PE_4));

gold_router r5(.clk(clk), .reset(reset),
    .si_E(hs[34]), .si_W(hs[28]), .si_S(hs[16]), .si_N(hs[46]), .si_PE(si_5_PE),
    .ro_E(hs[33]), .ro_W(hs[31]), .ro_S(hs[19]), .ro_N(hs[45]), .ro_PE(ro_5_PE),
    .E_packet_in(packet[29]), .W_packet_in(packet[24]), .S_packet_in(packet[16]), .N_packet_in(packet[39]), .PE_packet_in(PE_5_in_packet),
    .ri_E(hs[35]), .ri_W(hs[29]), .ri_S(hs[17]), .ri_N(hs[47]), .ri_PE(ri_5_PE),
    .so_E(hs[32]), .so_W(hs[30]), .so_S(hs[18]), .so_N(hs[44]), .so_PE(so_5_PE),
    .router_out_E(packet[28]), .router_out_W(packet[25]), .router_out_S(packet[17]), .router_out_N(packet[38]), .router_out_PE(PE_5_out_packet), 
    .polarity(polarity_PE_5));

gold_router r6(.clk(clk), .reset(reset),
    .si_E(hs[38]), .si_W(hs[32]), .si_S(hs[20]), .si_N(hs[50]), .si_PE(si_6_PE),
    .ro_E(hs[37]), .ro_W(hs[35]), .ro_S(hs[23]), .ro_N(hs[49]), .ro_PE(ro_6_PE),
    .E_packet_in(packet[33]), .W_packet_in(packet[28]), .S_packet_in(packet[18]), .N_packet_in(packet[41]), .PE_packet_in(PE_6_in_packet),
    .ri_E(hs[39]), .ri_W(hs[33]), .ri_S(hs[21]), .ri_N(hs[51]), .ri_PE(ri_6_PE),
    .so_E(hs[36]), .so_W(hs[34]), .so_S(hs[22]), .so_N(hs[48]), .so_PE(so_6_PE),
    .router_out_E(packet[32]), .router_out_W(packet[29]), .router_out_S(packet[19]), .router_out_N(packet[40]), .router_out_PE(PE_6_out_packet), 
    .polarity(polarity_PE_6));


gold_router r8(.clk(clk), .reset(reset),
    .si_E(hs[58]), .si_W(dummy_wire), .si_S(hs[40]), .si_N(hs[70]), .si_PE(si_8_PE),
    .ro_E(hs[57]), .ro_W(dummy_wire), .ro_S(hs[43]), .ro_N(hs[69]), .ro_PE(ro_8_PE),
    .E_packet_in(packet[47]), .W_packet_in(dummy_packet), .S_packet_in(packet[36]), .N_packet_in(packet[59]), .PE_packet_in(PE_8_in_packet),
    .ri_E(hs[59]), .ri_W(dummy_wire), .ri_S(hs[41]), .ri_N(hs[71]), .ri_PE(ri_8_PE),
    .so_E(hs[56]), .so_W(dummy_wire), .so_S(hs[42]), .so_N(hs[68]), .so_PE(so_8_PE),
    .router_out_E(packet[46]), .router_out_W(dummy_packet), .router_out_S(packet[37]), .router_out_N(packet[58]), .router_out_PE(PE_8_out_packet), 
    .polarity(polarity_PE_8));

gold_router r9(.clk(clk), .reset(reset),
    .si_E(hs[62]), .si_W(hs[56]), .si_S(hs[44]), .si_N(hs[74]), .si_PE(si_9_PE),
    .ro_E(hs[61]), .ro_W(hs[59]), .ro_S(hs[47]), .ro_N(hs[73]), .ro_PE(ro_9_PE),
    .E_packet_in(packet[51]), .W_packet_in(packet[46]), .S_packet_in(packet[38]), .N_packet_in(packet[61]), .PE_packet_in(PE_9_in_packet),
    .ri_E(hs[63]), .ri_W(hs[57]), .ri_S(hs[45]), .ri_N(hs[75]), .ri_PE(ri_9_PE),
    .so_E(hs[60]), .so_W(hs[58]), .so_S(hs[46]), .so_N(hs[72]), .so_PE(so_9_PE),
    .router_out_E(packet[50]), .router_out_W(packet[47]), .router_out_S(packet[39]), .router_out_N(packet[60]), .router_out_PE(PE_9_out_packet), 
    .polarity(polarity_PE_9));

gold_router r10(.clk(clk), .reset(reset),
    .si_E(hs[66]), .si_W(hs[60]), .si_S(hs[48]), .si_N(hs[78]), .si_PE(si_10_PE),
    .ro_E(hs[65]), .ro_W(hs[63]), .ro_S(hs[51]), .ro_N(hs[77]), .ro_PE(ro_10_PE),
    .E_packet_in(packet[55]), .W_packet_in(packet[50]), .S_packet_in(packet[40]), .N_packet_in(packet[63]), .PE_packet_in(PE_10_in_packet),
    .ri_E(hs[67]), .ri_W(hs[61]), .ri_S(hs[49]), .ri_N(hs[79]), .ri_PE(ri_10_PE),
    .so_E(hs[64]), .so_W(hs[62]), .so_S(hs[50]), .so_N(hs[76]), .so_PE(so_10_PE),
    .router_out_E(packet[54]), .router_out_W(packet[51]), .router_out_S(packet[41]), .router_out_N(packet[62]), .router_out_PE(PE_10_out_packet), 
    .polarity(polarity_PE_10));


endmodule