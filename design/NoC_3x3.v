`include "./src/PE.v"     // Including the Processing Element (PE) module
`include "./src/mesh_3x3.v" // Including the router module
`include "./src/nic.v"    // Including the NIC (Network Interface Controller) module

module NoC_3x3(
    input clk,
    input reset,


    input [0:31]node0_inst_in,//from inst mem
	input [0:63]node0_d_in,//From data mem to the processor
	output [0:31]node0_pc_out,//to inst mem
	output [0:63]node0_d_out, // from processor to data mem
	output [0:31]node0_addr_out,//from processor to data mem
	output node0_memWrEn,//in data meme
	output node0_memEn,//in data mem

    input [0:31]node1_inst_in,//from inst mem
	input [0:63]node1_d_in,//From data mem to the processor
	output [0:31]node1_pc_out,//to inst mem
	output [0:63]node1_d_out, // from processor to data mem
	output [0:31]node1_addr_out,//from processor to data mem
	output node1_memWrEn,//in data meme
	output node1_memEn,//in data mem

    input [0:31]node2_inst_in,//from inst mem
	input [0:63]node2_d_in,//From data mem to the processor
	output [0:31]node2_pc_out,//to inst mem
	output [0:63]node2_d_out, // from processor to data mem
	output [0:31]node2_addr_out,//from processor to data mem
	output node2_memWrEn,//in data meme
	output node2_memEn,//in data mem


    input [0:31]node4_inst_in,//from inst mem
	input [0:63]node4_d_in,//From data mem to the processor
	output [0:31]node4_pc_out,//to inst mem
	output [0:63]node4_d_out, // from processor to data mem
	output [0:31]node4_addr_out,//from processor to data mem
	output node4_memWrEn,//in data meme
	output node4_memEn,//in data mem

    input [0:31]node5_inst_in,//from inst mem
	input [0:63]node5_d_in,//From data mem to the processor
	output [0:31]node5_pc_out,//to inst mem
	output [0:63]node5_d_out, // from processor to data mem
	output [0:31]node5_addr_out,//from processor to data mem
	output node5_memWrEn,//in data meme
	output node5_memEn,//in data mem

    input [0:31]node6_inst_in,//from inst mem
	input [0:63]node6_d_in,//From data mem to the processor
	output [0:31]node6_pc_out,//to inst mem
	output [0:63]node6_d_out, // from processor to data mem
	output [0:31]node6_addr_out,//from processor to data mem
	output node6_memWrEn,//in data meme
	output node6_memEn,//in data mem


    input [0:31]node8_inst_in,//from inst mem
	input [0:63]node8_d_in,//From data mem to the processor
	output [0:31]node8_pc_out,//to inst mem
	output [0:63]node8_d_out, // from processor to data mem
	output [0:31]node8_addr_out,//from processor to data mem
	output node8_memWrEn,//in data meme
	output node8_memEn,//in data mem

    input [0:31]node9_inst_in,//from inst mem
	input [0:63]node9_d_in,//From data mem to the processor
	output [0:31]node9_pc_out,//to inst mem
	output [0:63]node9_d_out, // from processor to data mem
	output [0:31]node9_addr_out,//from processor to data mem
	output node9_memWrEn,//in data meme
	output node9_memEn,//in data mem

    input [0:31]node10_inst_in,//from inst mem
	input [0:63]node10_d_in,//From data mem to the processor
	output [0:31]node10_pc_out,//to inst mem
	output [0:63]node10_d_out, // from processor to data mem
	output [0:31]node10_addr_out,//from processor to data mem
	output node10_memWrEn,//in data meme
	output node10_memEn//in data mem



);

wire[63:0]PE_0_in_packet, PE_1_in_packet, PE_2_in_packet, PE_4_in_packet, PE_5_in_packet, PE_6_in_packet;
wire [63:0]PE_8_in_packet, PE_9_in_packet, PE_10_in_packet;
wire si_0_PE, si_1_PE, si_2_PE, si_4_PE, si_5_PE, si_6_PE, si_8_PE, si_9_PE, si_10_PE;
wire ro_0_PE, ro_1_PE, ro_2_PE,  ro_4_PE,  ro_5_PE,  ro_6_PE,  ro_8_PE,  ro_9_PE,  ro_10_PE;
wire [63:0]PE_0_out_packet, PE_1_out_packet, PE_2_out_packet, PE_4_out_packet, PE_5_out_packet, PE_6_out_packet;
wire [63:0]PE_8_out_packet, PE_9_out_packet, PE_10_out_packet;
wire so_0_PE, so_1_PE, so_2_PE, so_4_PE, so_5_PE, so_6_PE, so_8_PE, so_9_PE, so_10_PE;
wire ri_0_PE,  ri_1_PE, ri_2_PE, ri_4_PE, ri_5_PE,  ri_6_PE, ri_8_PE,  ri_9_PE,  ri_10_PE;
wire polarity_PE_0, polarity_PE_1, polarity_PE_2, polarity_PE_3, polarity_PE_4, polarity_PE_5, polarity_PE_6, polarity_PE_8; 
wire polarity_PE_9, polarity_PE_10;                

//NIC
wire [0:1] node0_addr_nic;
wire [0:63] node0_din_nic, node0_dout_nic;
wire node0_nicEn, node0_nicWrEn;

wire [0:1] node1_addr_nic;
wire [0:63] node1_din_nic, node1_dout_nic;
wire node1_nicEn, node1_nicWrEn;

wire [0:1] node2_addr_nic;
wire [0:63] node2_din_nic, node2_dout_nic;
wire node2_nicEn, node2_nicWrEn;


wire [0:1] node4_addr_nic;
wire [0:63] node4_din_nic, node4_dout_nic;
wire node4_nicEn, node4_nicWrEn;

wire [0:1] node5_addr_nic;
wire [0:63] node5_din_nic, node5_dout_nic;
wire node5_nicEn, node5_nicWrEn;

wire [0:1] node6_addr_nic;
wire [0:63] node6_din_nic, node6_dout_nic;
wire node6_nicEn, node6_nicWrEn;


wire [0:1] node8_addr_nic;
wire [0:63] node8_din_nic, node8_dout_nic;
wire node8_nicEn, node8_nicWrEn;

wire [0:1] node9_addr_nic;
wire [0:63] node9_din_nic, node9_dout_nic;
wire node9_nicEn, node9_nicWrEn;

wire [0:1] node10_addr_nic;
wire [0:63] node10_din_nic, node10_dout_nic;
wire node10_nicEn, node10_nicWrEn;




//Mesh
mesh_3x3 mesh(
.clk(clk),
.reset(reset),

.PE_0_in_packet(PE_0_in_packet), .PE_1_in_packet(PE_1_in_packet), .PE_2_in_packet(PE_2_in_packet),
.PE_4_in_packet(PE_4_in_packet), .PE_5_in_packet(PE_5_in_packet), .PE_6_in_packet(PE_6_in_packet),
.PE_8_in_packet(PE_8_in_packet), .PE_9_in_packet(PE_9_in_packet), .PE_10_in_packet(PE_10_in_packet),

.si_0_PE(si_0_PE), .si_1_PE(si_1_PE), .si_2_PE(si_2_PE), 
.si_4_PE(si_4_PE), .si_5_PE(si_5_PE), .si_6_PE(si_6_PE), 
.si_8_PE(si_8_PE), .si_9_PE(si_9_PE), .si_10_PE(si_10_PE),

.ro_0_PE(ro_0_PE), .ro_1_PE(ro_1_PE), .ro_2_PE(ro_2_PE),
.ro_4_PE(ro_4_PE), .ro_5_PE(ro_5_PE), .ro_6_PE(ro_6_PE),
.ro_8_PE(ro_8_PE), .ro_9_PE(ro_9_PE), .ro_10_PE(ro_10_PE),

.PE_0_out_packet(PE_0_out_packet), .PE_1_out_packet(PE_1_out_packet), .PE_2_out_packet(PE_2_out_packet),
.PE_4_out_packet(PE_4_out_packet), .PE_5_out_packet(PE_5_out_packet), .PE_6_out_packet(PE_6_out_packet), 
.PE_8_out_packet(PE_8_out_packet), .PE_9_out_packet(PE_9_out_packet), .PE_10_out_packet(PE_10_out_packet), 

.so_0_PE(so_0_PE), .so_1_PE(so_1_PE), .so_2_PE(so_2_PE), 
.so_4_PE(so_4_PE), .so_5_PE(so_5_PE), .so_6_PE(so_6_PE), 
.so_8_PE(so_8_PE), .so_9_PE(so_9_PE), .so_10_PE(so_10_PE),

.ri_0_PE(ri_0_PE), .ri_1_PE(ri_1_PE), .ri_2_PE(ri_2_PE),
.ri_4_PE(ri_4_PE), .ri_5_PE(ri_5_PE), .ri_6_PE(ri_6_PE), 
.ri_8_PE(ri_8_PE), .ri_9_PE(ri_9_PE), .ri_10_PE(ri_10_PE),

.polarity_PE_0(polarity_PE_0), .polarity_PE_1(polarity_PE_1), .polarity_PE_2(polarity_PE_2),
.polarity_PE_4(polarity_PE_4), .polarity_PE_5(polarity_PE_5), .polarity_PE_6(polarity_PE_6), 
.polarity_PE_8(polarity_PE_8), .polarity_PE_9(polarity_PE_9), .polarity_PE_10(polarity_PE_10)
);



//Processors

// Instantiate 16 Processing Elements (PEs) with their corresponding input and output signals


PE pe0(
    .clk(clk),
    .reset(reset),
    .instr_addr(node0_pc_out),
    .instr(node0_inst_in),
    .data_addr(node0_addr_out),
    .data_in(node0_d_in),                                                                                                
    .data_out(node0_d_out),
    .mem_en(node0_memEn),
    .mem_wr_en(node0_memWrEn),
    .nic_addr(node0_addr_nic),
    .d_in(node0_din_nic),
    .d_out(node0_dout_nic),
    .nic_en(node0_nicEn),
    .nic_wr_en(node0_nicWrEn)
);

PE pe1(
    .clk(clk),
    .reset(reset),
    .instr_addr(node1_pc_out),
    .instr(node1_inst_in),
    .data_addr(node1_addr_out),
    .data_in(node1_d_in),                                                                                                
    .data_out(node1_d_out),
    .mem_en(node1_memEn),
    .mem_wr_en(node1_memWrEn),
    .nic_addr(node1_addr_nic),
    .d_in(node1_din_nic),
    .d_out(node1_dout_nic),
    .nic_en(node1_nicEn),
    .nic_wr_en(node1_nicWrEn)
);

PE pe2(
    .clk(clk),
    .reset(reset),
    .instr_addr(node2_pc_out),
    .instr(node2_inst_in),
    .data_addr(node2_addr_out),
    .data_in(node2_d_in),                                                                                                
    .data_out(node2_d_out),
    .mem_en(node2_memEn),
    .mem_wr_en(node2_memWrEn),
    .nic_addr(node2_addr_nic),
    .d_in(node2_din_nic),
    .d_out(node2_dout_nic),
    .nic_en(node2_nicEn),
    .nic_wr_en(node2_nicWrEn)
);


PE pe4(
    .clk(clk),
    .reset(reset),
    .instr_addr(node4_pc_out),
    .instr(node4_inst_in),
    .data_addr(node4_addr_out),
    .data_in(node4_d_in),                                                                                                
    .data_out(node4_d_out),
    .mem_en(node4_memEn),
    .mem_wr_en(node4_memWrEn),
    .nic_addr(node4_addr_nic),
    .d_in(node4_din_nic),
    .d_out(node4_dout_nic),
    .nic_en(node4_nicEn),
    .nic_wr_en(node4_nicWrEn)
);

PE pe5(
    .clk(clk),
    .reset(reset),
    .instr_addr(node5_pc_out),
    .instr(node5_inst_in),
    .data_addr(node5_addr_out),
    .data_in(node5_d_in),                                                                                                
    .data_out(node5_d_out),
    .mem_en(node5_memEn),
    .mem_wr_en(node5_memWrEn),
    .nic_addr(node5_addr_nic),
    .d_in(node5_din_nic),
    .d_out(node5_dout_nic),
    .nic_en(node5_nicEn),
    .nic_wr_en(node5_nicWrEn)
);

PE pe6(
    .clk(clk),
    .reset(reset),
    .instr_addr(node6_pc_out),
    .instr(node6_inst_in),
    .data_addr(node6_addr_out),
    .data_in(node6_d_in),                                                                                                
    .data_out(node6_d_out),
    .mem_en(node6_memEn),
    .mem_wr_en(node6_memWrEn),
    .nic_addr(node6_addr_nic),
    .d_in(node6_din_nic),
    .d_out(node6_dout_nic),
    .nic_en(node6_nicEn),
    .nic_wr_en(node6_nicWrEn)
);

PE pe8(
    .clk(clk),
    .reset(reset),
    .instr_addr(node8_pc_out),
    .instr(node8_inst_in),
    .data_addr(node8_addr_out),
    .data_in(node8_d_in),                                                                                                
    .data_out(node8_d_out),
    .mem_en(node8_memEn),
    .mem_wr_en(node8_memWrEn),
    .nic_addr(node8_addr_nic),
    .d_in(node8_din_nic),
    .d_out(node8_dout_nic),
    .nic_en(node8_nicEn),
    .nic_wr_en(node8_nicWrEn)
);

PE pe9(
    .clk(clk),
    .reset(reset),
    .instr_addr(node9_pc_out),
    .instr(node9_inst_in),
    .data_addr(node9_addr_out),
    .data_in(node9_d_in),                                                                                                
    .data_out(node9_d_out),
    .mem_en(node9_memEn),
    .mem_wr_en(node9_memWrEn),
    .nic_addr(node9_addr_nic),
    .d_in(node9_din_nic),
    .d_out(node9_dout_nic),
    .nic_en(node9_nicEn),
    .nic_wr_en(node9_nicWrEn)
);

PE pe10(
    .clk(clk),
    .reset(reset),
    .instr_addr(node10_pc_out),
    .instr(node10_inst_in),
    .data_addr(node10_addr_out),
    .data_in(node10_d_in),                                                                                                
    .data_out(node10_d_out),
    .mem_en(node10_memEn),
    .mem_wr_en(node10_memWrEn),
    .nic_addr(node10_addr_nic),
    .d_in(node10_din_nic),
    .d_out(node10_dout_nic),
    .nic_en(node10_nicEn),
    .nic_wr_en(node10_nicWrEn)
);

// wire [0:1] node1_addr_nic;
// wire [0:63] node1_din_nic, node1_dout_nic;
// wire node1_nicEn, node1_nicWrEn;


nic nic_0(
    .clk(clk),                   // Clock signal
    .reset(reset),                 // Reset signal
    .addr(node0_addr_nic),            // 2-bit Address input
    .d_in(node0_din_nic),           // 64-bit Data input
    .d_out(node0_dout_nic),          // 64-bit Data output
    .nicEn(node0_nicEn),                 // NIC Enable signal
    .nicWrEn(node0_nicWrEn),               // NIC Write Enable signal
    .net_so(si_0_PE),               // Network Shift Out
    .net_ro(ri_0_PE),                // Network Read Output (ready)
    .net_do(PE_0_in_packet),        // 64-bit Data output to Network
    .net_polarity(polarity_PE_0),          // Network Polarity signal
    .net_si(so_0_PE),                // Network Shift In
    .net_ri(ro_0_PE),               // Network Read Input (ready)
    .net_di(PE_0_out_packet)          // 64-bit Data input from Network
);

nic nic_1(
    .clk(clk),                   // Clock signal
    .reset(reset),                 // Reset signal
    .addr(node1_addr_nic),            // 2-bit Address input
    .d_in(node1_din_nic),           // 64-bit Data input
    .d_out(node1_dout_nic),          // 64-bit Data output
    .nicEn(node1_nicEn),                 // NIC Enable signal
    .nicWrEn(node1_nicWrEn),               // NIC Write Enable signal
    .net_so(si_1_PE),               // Network Shift Out
    .net_ro(ri_1_PE),                // Network Read Output (ready)
    .net_do(PE_1_in_packet),        // 64-bit Data output to Network
    .net_polarity(polarity_PE_1),          // Network Polarity signal
    .net_si(so_1_PE),                // Network Shift In
    .net_ri(ro_1_PE),               // Network Read Input (ready)
    .net_di(PE_1_out_packet)          // 64-bit Data input from Network
);



nic nic_2(
    .clk(clk),                   // Clock signal
    .reset(reset),                 // Reset signal
    .addr(node2_addr_nic),            // 2-bit Address input
    .d_in(node2_din_nic),           // 64-bit Data input
    .d_out(node2_dout_nic),          // 64-bit Data output
    .nicEn(node2_nicEn),                 // NIC Enable signal
    .nicWrEn(node2_nicWrEn),               // NIC Write Enable signal
    .net_so(si_2_PE),               // Network Shift Out
    .net_ro(ri_2_PE),                // Network Read Output (ready)
    .net_do(PE_2_in_packet),        // 64-bit Data output to Network
    .net_polarity(polarity_PE_2),          // Network Polarity signal
    .net_si(so_2_PE),                // Network Shift In
    .net_ri(ro_2_PE),               // Network Read Input (ready)
    .net_di(PE_2_out_packet)          // 64-bit Data input from Network
);




nic nic_4(
    .clk(clk),                   // Clock signal
    .reset(reset),                 // Reset signal
    .addr(node4_addr_nic),            // 2-bit Address input
    .d_in(node4_din_nic),           // 64-bit Data input
    .d_out(node4_dout_nic),          // 64-bit Data output
    .nicEn(node4_nicEn),                 // NIC Enable signal
    .nicWrEn(node4_nicWrEn),               // NIC Write Enable signal
    .net_so(si_4_PE),               // Network Shift Out
    .net_ro(ri_4_PE),                // Network Read Output (ready)
    .net_do(PE_4_in_packet),        // 64-bit Data output to Network
    .net_polarity(polarity_PE_4),          // Network Polarity signal
    .net_si(so_4_PE),                // Network Shift In
    .net_ri(ro_4_PE),               // Network Read Input (ready)
    .net_di(PE_4_out_packet)          // 64-bit Data input from Network
);



nic nic_5(
    .clk(clk),                   // Clock signal
    .reset(reset),                 // Reset signal
    .addr(node5_addr_nic),            // 2-bit Address input
    .d_in(node5_din_nic),           // 64-bit Data input
    .d_out(node5_dout_nic),          // 64-bit Data output
    .nicEn(node5_nicEn),                 // NIC Enable signal
    .nicWrEn(node5_nicWrEn),               // NIC Write Enable signal
    .net_so(si_5_PE),               // Network Shift Out
    .net_ro(ri_5_PE),                // Network Read Output (ready)
    .net_do(PE_5_in_packet),        // 64-bit Data output to Network
    .net_polarity(polarity_PE_5),          // Network Polarity signal
    .net_si(so_5_PE),                // Network Shift In
    .net_ri(ro_5_PE),               // Network Read Input (ready)
    .net_di(PE_5_out_packet)          // 64-bit Data input from Network
);



nic nic_6(
    .clk(clk),                   // Clock signal
    .reset(reset),                 // Reset signal
    .addr(node6_addr_nic),            // 2-bit Address input
    .d_in(node6_din_nic),           // 64-bit Data input
    .d_out(node6_dout_nic),          // 64-bit Data output
    .nicEn(node6_nicEn),                 // NIC Enable signal
    .nicWrEn(node6_nicWrEn),               // NIC Write Enable signal
    .net_so(si_6_PE),               // Network Shift Out
    .net_ro(ri_6_PE),                // Network Read Output (ready)
    .net_do(PE_6_in_packet),        // 64-bit Data output to Network
    .net_polarity(polarity_PE_6),          // Network Polarity signal
    .net_si(so_6_PE),                // Network Shift In
    .net_ri(ro_6_PE),               // Network Read Input (ready)
    .net_di(PE_6_out_packet)          // 64-bit Data input from Network
);




nic nic_8(
    .clk(clk),                   // Clock signal
    .reset(reset),                 // Reset signal
    .addr(node8_addr_nic),            // 2-bit Address input
    .d_in(node8_din_nic),           // 64-bit Data input
    .d_out(node8_dout_nic),          // 64-bit Data output
    .nicEn(node8_nicEn),                 // NIC Enable signal
    .nicWrEn(node8_nicWrEn),               // NIC Write Enable signal
    .net_so(si_8_PE),               // Network Shift Out
    .net_ro(ri_8_PE),                // Network Read Output (ready)
    .net_do(PE_8_in_packet),        // 64-bit Data output to Network
    .net_polarity(polarity_PE_8),          // Network Polarity signal
    .net_si(so_8_PE),                // Network Shift In
    .net_ri(ro_8_PE),               // Network Read Input (ready)
    .net_di(PE_8_out_packet)          // 64-bit Data input from Network
);



nic nic_9(
    .clk(clk),                   // Clock signal
    .reset(reset),                 // Reset signal
    .addr(node9_addr_nic),            // 2-bit Address input
    .d_in(node9_din_nic),           // 64-bit Data input
    .d_out(node9_dout_nic),          // 64-bit Data output
    .nicEn(node9_nicEn),                 // NIC Enable signal
    .nicWrEn(node9_nicWrEn),               // NIC Write Enable signal
    .net_so(si_9_PE),               // Network Shift Out
    .net_ro(ri_9_PE),                // Network Read Output (ready)
    .net_do(PE_9_in_packet),        // 64-bit Data output to Network
    .net_polarity(polarity_PE_9),          // Network Polarity signal
    .net_si(so_9_PE),                // Network Shift In
    .net_ri(ro_9_PE),               // Network Read Input (ready)
    .net_di(PE_9_out_packet)          // 64-bit Data input from Network
);



nic nic_10(
    .clk(clk),                   // Clock signal
    .reset(reset),                 // Reset signal
    .addr(node10_addr_nic),            // 2-bit Address input
    .d_in(node10_din_nic),           // 64-bit Data input
    .d_out(node10_dout_nic),          // 64-bit Data output
    .nicEn(node10_nicEn),                 // NIC Enable signal
    .nicWrEn(node10_nicWrEn),               // NIC Write Enable signal
    .net_so(si_10_PE),               // Network Shift Out
    .net_ro(ri_10_PE),                // Network Read Output (ready)
    .net_do(PE_10_in_packet),        // 64-bit Data output to Network
    .net_polarity(polarity_PE_10),          // Network Polarity signal
    .net_si(so_10_PE),                // Network Shift In
    .net_ri(ro_10_PE),               // Network Read Input (ready)
    .net_di(PE_10_out_packet)          // 64-bit Data input from Network
);


endmodule