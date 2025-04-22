 `include "./src/DW_mult_pipe.v"
 `include "./src/DW_div_pipe.v"
 `include "./src/DW_sqrt_pipe.v"
 `include "./src/shifter.v"
module forwarding_unit (
    input  wire         clk,         // Clock signal: triggers operations on rising edge.
    input  wire         reset,       // Synchronous reset signal: when high, resets the register file.
    input  wire [0:4]   ra11_id,      // 5-bit read address for port 1 (from ID stage).
    input  wire [0:4]   ra22_id,      // 5-bit read address for port 2 (from ID stage).
    output reg  [0:63]  rsid,       // 64-bit read data output from port 1 (to ID stage).
    output reg  [0:63]  rtid_id,       // 64-bit read data output from port 2 (to ID stage).
    input  wire [0:4]   wb_wa,       // 5-bit write address (from WB stage).
    input  wire         wb_reg_wr,   // Write enable signal from the WB stage.
    input  wire [0:63]  wb_wd,       // 64-bit write data (from WB stage).
    input  wire [0:2]   wb_ppp       // 3-bit partial write precision selector (from WB stage).
);

    // Declare a register file with 32 entries; each entry is 64 bits wide.
    reg [0:63] reg_file [0:31];  // This holds the contents of the registers.

    // Combinational Read Port 1: Generate rsid based on ra11_id.
    always @(*) begin
        // Check if the read address is 0.
        if (ra11_id == 0)
            rsid = 64'd0;  // Register zero is hardwired to zero.
        else begin
            // Read the data from the register file at address ra11_id.
            rsid = reg_file[ra11_id];  
            // If a write is enabled and the read address matches the write address,
            // update rsid based on the partial write mode (wb_ppp).
            if (wb_reg_wr && (ra11_id == wb_wa)) begin
                case (wb_ppp)
                    3'b000: begin
                        rsid = wb_wd;  // Full 64-bit update.
                    end
                    3'b001: begin
                        rsid[0:31] = wb_wd[0:31];  // Update lower 32 bits.
                    end
                    3'b010: begin
                        rsid[32:63] = wb_wd[32:63];  // Update upper 32 bits.
                    end
                    3'b011: begin
                        // Update selected 8-bit segments: bits 0-7, 16-23, 32-39, and 48-55.
                        rsid[0:7]   = wb_wd[0:7];
                        rsid[16:23] = wb_wd[16:23];
                        rsid[32:39] = wb_wd[32:39];
                        rsid[48:55] = wb_wd[48:55];
                    end
                    3'b100: begin
                        // Update alternative 8-bit segments: bits 8-15, 24-31, 40-47, and 56-63.
                        rsid[8:15]  = wb_wd[8:15];
                        rsid[24:31] = wb_wd[24:31];
                        rsid[40:47] = wb_wd[40:47];
                        rsid[56:63] = wb_wd[56:63];
                    end
                    default: ; // If no case matches, do nothing.
                endcase  // End of case for partial write precision.
            end  // End of write check for port 1.
        end  // End of else branch when ra11_id is nonzero.
    end  // End of always block for read port 1.

    // Combinational Read Port 2: Generate rtid_id based on ra22_id.
    always @(*) begin
        // Check if the read address is 0.
        if (ra22_id == 0)
            rtid_id = 64'd0;  // Register zero is hardwired to zero.
        else begin
            // Read the data from the register file at address ra22_id.
            rtid_id = reg_file[ra22_id];
            // If a write is enabled and the read address matches the write address,
            // update rtid_id based on the partial write mode.
            if (wb_reg_wr && (ra22_id == wb_wa)) begin
                case (wb_ppp)
                    3'b000: begin
                        rtid_id = wb_wd;  // Full 64-bit update.
                    end
                    3'b001: begin
                        rtid_id[0:31] = wb_wd[0:31];  // Update lower 32 bits.
                    end
                    3'b010: begin
                        rtid_id[32:63] = wb_wd[32:63];  // Update upper 32 bits.
                    end
                    3'b011: begin
                        // Update selected 8-bit segments: bits 0-7, 16-23, 32-39, and 48-55.
                        rtid_id[0:7]   = wb_wd[0:7];
                        rtid_id[16:23] = wb_wd[16:23];
                        rtid_id[32:39] = wb_wd[32:39];
                        rtid_id[48:55] = wb_wd[48:55];
                    end
                    3'b100: begin
                        // Update alternative 8-bit segments: bits 8-15, 24-31, 40-47, and 56-63.
                        rtid_id[8:15]  = wb_wd[8:15];
                        rtid_id[24:31] = wb_wd[24:31];
                        rtid_id[40:47] = wb_wd[40:47];
                        rtid_id[56:63] = wb_wd[56:63];
                    end
                    default: ; // Do nothing if wb_ppp doesn't match expected values.
                endcase  // End of case for port 2 partial write.
            end  // End of write check for port 2.
        end  // End of else branch when ra22_id is nonzero.
    end  // End of always block for read port 2.

    // Synchronous Write Block: Writes data into the register file on the rising edge of clk.
    integer i;  // Loop variable for initializing register file.
    always @(posedge clk) begin
        if (reset) begin
            // When reset is active, initialize all 32 registers to 0.
            for (i = 0; i < 32; i = i + 1)
                reg_file[i] <= 64'd0;  // Set register i to zero.
        end
        else begin
            // Check if write enable is asserted and the write address is not zero.
            if (wb_reg_wr && (wb_wa != 5'b00000)) begin
                // Use a case statement to perform a full or partial write based on wb_ppp.
                case (wb_ppp)
                    3'b000: begin
                        reg_file[wb_wa] <= wb_wd;  // Write the full 64-bit data.
                    end
                    3'b001: begin
                        reg_file[wb_wa][0:31] <= wb_wd[0:31];  // Write the lower 32 bits.
                    end
                    3'b010: begin
                        reg_file[wb_wa][32:63] <= wb_wd[32:63];  // Write the upper 32 bits.
                    end
                    3'b011: begin
                        // Write specific 8-bit segments: update bits 0-7, 16-23, 32-39, and 48-55.
                        reg_file[wb_wa][0:7]   <= wb_wd[0:7];
                        reg_file[wb_wa][16:23] <= wb_wd[16:23];
                        reg_file[wb_wa][32:39] <= wb_wd[32:39];
                        reg_file[wb_wa][48:55] <= wb_wd[48:55];
                    end
                    3'b100: begin
                        // Write alternative 8-bit segments: update bits 8-15, 24-31, 40-47, and 56-63.
                        reg_file[wb_wa][8:15]  <= wb_wd[8:15];
                        reg_file[wb_wa][24:31] <= wb_wd[24:31];
                        reg_file[wb_wa][40:47] <= wb_wd[40:47];
                        reg_file[wb_wa][56:63] <= wb_wd[56:63];
                    end
                    default: ; // Do nothing if wb_ppp is not recognized.
                endcase  // End of case statement for wb_ppp in write block.
            end  // End of if statement checking wb_reg_wr and nonzero wb_wa.
        end  // End of else block when reset is not active.
    end  // End of always block for synchronous write.

endmodule



module PE (
    input  wire         clk,
    input  wire         reset,
    output wire [0:31]  instr_addr,
    input  wire [0:31]  instr,
    output wire [0:31]  data_addr,
    input  wire [0:63]  data_in,                                                                                                
    output wire [0:63]  data_out,
    output wire         mem_en,
    output wire         mem_wr_en,
    output wire [0:1]   nic_addr,
    output wire [0:63]  d_in,
    input  wire [0:63]  d_out,
    output wire         nic_en,
    output wire         nic_wr_en
);

    //-------------------------------------------------------------------------
    // Register Declarations (Internal Control & Pipeline Registers)
    //-------------------------------------------------------------------------
    // Program Counter
    reg [0:31] pc;
    // Stall control register
    reg        Stalling_logic;

    // Pipeline Stage Registers:
    // IF/ID stage: Contains the fetched instruction and a WB flag.
    reg [0:32] ifstage_idstage_instrcutio;
    // ID/EX stage: Holds control signals and operands for execution.
    reg [0:179] idstage_exstage_instru;
    // EX/WB stage: Holds the execution result, destination address, and write-back controls.
    reg [0:72] ex_eritebac_instr;

    //-------------------------------------------------------------------------
    // Wire Declarations by Pipeline Stage
    //-------------------------------------------------------------------------
    // *** ID Stage Wires ***
    // Data read from the register file forwarded from ID stage
    wire [0:63] rsid, rtid_id;
    // Instruction decoding signals
    wire [0:5]  id_opcode, idfunclogic;
    wire        flushingid;
    // Control signals generated in the ID stage
    wire        wr_regid;
    wire [0:2]  aluopid;
    wire        oddevenid;
    wire        moddivid;
    wire [0:1]  id_shift;
	wire [0:7]  h0, h1, h2, h3;
    wire [0:15] w0, w1;
    wire [0:31] d0;
    wire [0:2]  idexop;
    wire        loadid;
    wire        storeid;
	wire [0:31] sqrt_w0, sqrt_w1;
    wire [0:63] sqrt_d0;
    wire [0:63] sqrt_b, sqrt_h, sqrt_w, sqrt_d;
    wire        branchid_dec;
    wire        branchidPrepl;
    wire        sqmultidstage;
    // Register addresses for source operands in the ID stage
    wire [0:4]  ra11_id, ra22_id;

    // *** EX Stage Wires ***
    // Control and data signals coming from the ID/EX stage register
    wire        ex_registerwrite;
	wire [0:7]  remainderb0, remainderb1, remainderb2, remainderb3,
                remainderb4, remainderb5, remainderb6, remainderb7;
    wire [0:63] remainderb;
	    wire [0:15] remainder_mod0, remainder_mod1, remainder_mod2, remainder_mod3;
    wire [0:63] remainder_mod;
  wire [0:3]   b5, b6, b7;
    wire [0:2]  opcide_ex;
    wire [0:63] rs11_ex, rt11_ex;
	wire [0:63] sqmultoutwe;
	wire [0:63] moddivision_b, moddivision_h, moddivision_w, moddivision_d;
    wire [0:3]  b0, b1, b2, b3, b4;
	    wire [0:2]  wb_ppp;
    wire        wb_reg_wr;
    wire [0:63] sqmultoutree0;
	wire [0:15] sqrt_h0, sqrt_h1, sqrt_h2, sqrt_h3;
    wire [0:63] sqmultoutree;

    // Forwarded operand signals in the EX stage (may be updated via forwarding logic)
    reg  [0:63] rs11_ex_fw, rt11_ex_fw;
    // Additional control signals for EX stage operations
    wire [0:1]  store_exage123;
    wire        oddex_even;
    wire        sqmul_exx;
    wire        moddiv_ex;
	    wire [0:31] remaindw0, remaindw1;
    wire [0:63] remaindw;
	    wire [0:63] modulusd0;
    wire [0:63] modulusd;
    wire [0:1]  shiftex;
    wire [0:2]  code_ex1_ex1;
    wire        load1_ex, store_ex;
	    wire [0:7]   sqrt_b4, sqrt_b5, sqrt_b6, sqrt_b7;
    // ALU output for arithmetic/logic operations
    wire [0:63] out_alu1;

    // Multiplication/Square wires (results for various element widths)
    wire [0:15] outsqmultr0, outsqmultr1, outsqmultr2, outsqmultr3;
    wire [0:63] outsqmultr;
	    wire [0:63] shiftingouter;

    wire [0:31] sqmultoutwe0, sqmultoutwe1;
    // Division wires (byte-level results)
    wire [0:7]  quotfounda0, quotfounda1, quotfounda2, quotfounda3,
                quotfounda4, quotfounda5, quotfounda6, quotfounda7;
    wire [0:63] quotfounda;


    // Division wires (half-word-level results)
    wire [0:15] quotfoundbd0, quotfoundbd1, quotfoundbd2, quotfoundbd3;
    wire [0:63] quotfoundbd;
    // Division wires (word-level results)
    wire [0:31] quotw_quot0, quotw_quot1;
    wire [0:63] quotw_quot;

    // Division wires (double-word-level results)
    wire [0:63] quotd0;
    wire [0:63] quotd;

    // Miscellaneous division wires
    wire [0:14] dont;


    // Square Root wires
    wire [0:7]  sqrt_b0, sqrt_b1, sqrt_b2, sqrt_b3;


    // Shifter output

    // Additional EX stage control signals
    wire        stall;
    wire        takentaken;
    wire        ex_branch_takennz, ex_branch;
    // Final EX/MEM result (after possible memory read)
    reg  [0:63] ex_mem_final_out;
    // EX stage result
    reg  [0:63] ex_out;

    // *** WB Stage Wires ***
    // Write-back stage signals (data to write, destination address, partial write mode, and write enable)
    wire [0:63] wb_wd;
    wire [0:4]  wb_wa;
	assign outsqmultr = {outsqmultr0, outsqmultr1, outsqmultr2, outsqmultr3};
	assign sqmultoutwe = {sqmultoutwe0, sqmultoutwe1};
	assign sqmultoutree = sqmultoutree0;

    //-------------------------------------------------------------------------
    // Assign Statements (Grouped by Pipeline Stage)
    //-------------------------------------------------------------------------
    // --- IF Stage ---
    // Connect the program counter to the instruction address output.
    assign instr_addr = pc;

    // --- ID Stage ---
    // Decode the instruction fields from the IF/ID pipeline register.
    assign id_opcode    = ifstage_idstage_instrcutio[0:5];
    assign idfunclogic  = ifstage_idstage_instrcutio[26:31];
    assign flushingid   = ifstage_idstage_instrcutio[32];

    // Instantiate the demux module to generate control signals from the opcode and function fields.
    demux demux_0 (
        id_opcode,
        idfunclogic,
        flushingid,
        takentaken,
        wr_regid,
        aluopid,
        oddevenid,
        moddivid,
        id_shift,
        idexop,
        loadid,
        storeid,
        branchid_dec,
        branchidPrepl,
        sqmultidstage
    );

    // Select source register addresses based on the instruction type.
    assign ra11_id = (storeid || branchidPrepl) ? ifstage_idstage_instrcutio[6:10] : ifstage_idstage_instrcutio[11:15];
    assign ra22_id = ifstage_idstage_instrcutio[16:20];

    // Instantiate the forwarding unit to resolve data hazards.
    forwarding_unit fw_0 (
        clk,
        reset,
        ra11_id,
        ra22_id,
        rsid,
        rtid_id,
        wb_wa,
        wb_reg_wr,
        wb_wd,
        wb_ppp
    );

    // --- EX Stage ---
    // Extract control and operand signals from the ID/EX pipeline register.
    assign ex_registerwrite  = idstage_exstage_instru[149];
    assign opcide_ex         = idstage_exstage_instru[150:152];
    assign store_ex          = idstage_exstage_instru[161];
    assign ex_branch_takennz = idstage_exstage_instru[162];
    assign ex_branch         = idstage_exstage_instru[163];
    assign rs11_ex           = idstage_exstage_instru[0:63];
    assign shiftex           = idstage_exstage_instru[155:156];
    assign code_ex1_ex1      = idstage_exstage_instru[157:159];
    assign load1_ex          = idstage_exstage_instru[160];
    //assign store_ex          = idstage_exstage_instru[161];
    assign rt11_ex           = idstage_exstage_instru[64:127];
    assign store_exage123    = idstage_exstage_instru[164:165];
    assign oddex_even        = idstage_exstage_instru[153];
    assign sqmul_exx         = idstage_exstage_instru[169];
    assign moddiv_ex         = idstage_exstage_instru[154];
    //assign ex_branch_takennz = idstage_exstage_instru[162];
    //assign ex_branch         = idstage_exstage_instru[163];
	assign remainderb = {remainderb0, remainderb1, remainderb2, remainderb3, remainderb4, remainderb5, remainderb6, remainderb7};
	assign remainder_mod = {remainder_mod0, remainder_mod1, remainder_mod2, remainder_mod3};
	assign remaindw = {remaindw0, remaindw1};
	assign modulusd = modulusd0;

    // Instantiate the ALU (arithmetic/logic unit) module for the EX stage.
    logic_op logic_op1 (
        opcide_ex,
        rs11_ex_fw,
        rt11_ex_fw,
        store_exage123,
        out_alu1
    );




// 8-bit multiplications (4 segments) � output: outsqmultr[0�3]
DW_mult_pipe #(8, 8) multplicationpipes0 (clk, !reset, 1'b1, 1'b0, !oddex_even ? rs11_ex_fw[0:7]   : rs11_ex_fw[8:15],   !sqmul_exx ? (!oddex_even ? rt11_ex_fw[0:7]   : rt11_ex_fw[8:15])   : (!oddex_even ? rs11_ex_fw[0:7]   : rs11_ex_fw[8:15]),   outsqmultr0);  // byte 0
DW_mult_pipe #(8, 8) multplicationpipes1 (clk, !reset, 1'b1, 1'b0, !oddex_even ? rs11_ex_fw[16:23] : rs11_ex_fw[24:31],  !sqmul_exx ? (!oddex_even ? rt11_ex_fw[16:23] : rt11_ex_fw[24:31]) : (!oddex_even ? rs11_ex_fw[16:23] : rs11_ex_fw[24:31]), outsqmultr1);  // byte 1
	assign sqrt_h = {sqrt_h0, sqrt_h1, sqrt_h2, sqrt_h3};
	assign sqrt_w = {sqrt_w0, sqrt_w1};
	assign sqrt_d = sqrt_d0;

DW_mult_pipe #(8, 8) multplicationpipes2 (clk, !reset, 1'b1, 1'b0, !oddex_even ? rs11_ex_fw[32:39] : rs11_ex_fw[40:47],  !sqmul_exx ? (!oddex_even ? rt11_ex_fw[32:39] : rt11_ex_fw[40:47]) : (!oddex_even ? rs11_ex_fw[32:39] : rs11_ex_fw[40:47]), outsqmultr2);  // byte 2
DW_mult_pipe #(8, 8) multplicationpipes3 (clk, !reset, 1'b1, 1'b0, !oddex_even ? rs11_ex_fw[48:55] : rs11_ex_fw[56:63],  !sqmul_exx ? (!oddex_even ? rt11_ex_fw[48:55] : rt11_ex_fw[56:63]) : (!oddex_even ? rs11_ex_fw[48:55] : rs11_ex_fw[56:63]), outsqmultr3);  // byte 3

// 16-bit multiplications (2 segments) � output: sqmultoutwe[0�1]
DW_mult_pipe #(16, 16) multplicationpipes4 (clk, !reset, 1'b1, 1'b0, !oddex_even ? rs11_ex_fw[0:15]  : rs11_ex_fw[16:31],  !sqmul_exx ? (!oddex_even ? rt11_ex_fw[0:15]  : rt11_ex_fw[16:31])  : (!oddex_even ? rs11_ex_fw[0:15]  : rs11_ex_fw[16:31]),  sqmultoutwe0);  // half-word 0
DW_mult_pipe #(16, 16) multplicationpipes5 (clk, !reset, 1'b1, 1'b0, !oddex_even ? rs11_ex_fw[32:47] : rs11_ex_fw[48:63],  !sqmul_exx ? (!oddex_even ? rt11_ex_fw[32:47] : rt11_ex_fw[48:63])  : (!oddex_even ? rs11_ex_fw[32:47] : rs11_ex_fw[48:63]),  sqmultoutwe1);  // half-word 1

// 32-bit multiplication � output: sqmultoutree0
DW_mult_pipe #(32, 32) multplicationpipes6 (clk, !reset, 1'b1, 1'b0, !oddex_even ? rs11_ex_fw[0:31]  : rs11_ex_fw[32:63],  !sqmul_exx ? (!oddex_even ? rt11_ex_fw[0:31]  : rt11_ex_fw[32:63])  : (!oddex_even ? rs11_ex_fw[0:31]  : rs11_ex_fw[32:63]),  sqmultoutree0); // full 32-bit word

// 8-bit divisions (8 segments)
DW_div_pipe #(8, 8, 0, 1, 2, 1, 2, 0) DW_div_pipe_0  (clk, !reset, 1'b1, rs11_ex_fw[0:7],   rt11_ex_fw[0:7],   quotfounda0,  remainderb0,  dont[0]);  // Divides bytes 0
DW_div_pipe #(8, 8, 0, 1, 2, 1, 2, 0) DW_div_pipe_1  (clk, !reset, 1'b1, rs11_ex_fw[8:15],  rt11_ex_fw[8:15],  quotfounda1,  remainderb1,  dont[1]);  // Divides bytes 1
DW_div_pipe #(8, 8, 0, 1, 2, 1, 2, 0) DW_div_pipe_2  (clk, !reset, 1'b1, rs11_ex_fw[16:23], rt11_ex_fw[16:23], quotfounda2,  remainderb2,  dont[2]);  // Divides bytes 2
DW_div_pipe #(8, 8, 0, 1, 2, 1, 2, 0) DW_div_pipe_3  (clk, !reset, 1'b1, rs11_ex_fw[24:31], rt11_ex_fw[24:31], quotfounda3,  remainderb3,  dont[3]);  // Divides bytes 3

// 16-bit divisions (4 half-words)
DW_div_pipe #(16, 16, 0, 1, 2, 1, 2, 0) DW_div_pipe_8  (clk, !reset, 1'b1, rs11_ex_fw[0:15],   rt11_ex_fw[0:15],   quotfoundbd0, remainder_mod0, dont[8]);   // Divides half-word 0
DW_div_pipe #(16, 16, 0, 1, 2, 1, 2, 0) DW_div_pipe_9  (clk, !reset, 1'b1, rs11_ex_fw[16:31],  rt11_ex_fw[16:31],  quotfoundbd1, remainder_mod1, dont[9]);   // Divides half-word 1
DW_div_pipe #(16, 16, 0, 1, 2, 1, 2, 0) DW_div_pipe_10 (clk, !reset, 1'b1, rs11_ex_fw[32:47],  rt11_ex_fw[32:47],  quotfoundbd2, remainder_mod2, dont[10]);  // Divides half-word 2
DW_div_pipe #(16, 16, 0, 1, 2, 1, 2, 0) DW_div_pipe_11 (clk, !reset, 1'b1, rs11_ex_fw[48:63],  rt11_ex_fw[48:63],  quotfoundbd3, remainder_mod3, dont[11]);  // Divides half-word 3

DW_div_pipe #(8, 8, 0, 1, 2, 1, 2, 0) DW_div_pipe_4  (clk, !reset, 1'b1, rs11_ex_fw[32:39], rt11_ex_fw[32:39], quotfounda4,  remainderb4,  dont[4]);  // Divides bytes 4
DW_div_pipe #(8, 8, 0, 1, 2, 1, 2, 0) DW_div_pipe_5  (clk, !reset, 1'b1, rs11_ex_fw[40:47], rt11_ex_fw[40:47], quotfounda5,  remainderb5,  dont[5]);  // Divides bytes 5
DW_div_pipe #(8, 8, 0, 1, 2, 1, 2, 0) DW_div_pipe_6  (clk, !reset, 1'b1, rs11_ex_fw[48:55], rt11_ex_fw[48:55], quotfounda6,  remainderb6,  dont[6]);  // Divides bytes 6
DW_div_pipe #(8, 8, 0, 1, 2, 1, 2, 0) DW_div_pipe_7  (clk, !reset, 1'b1, rs11_ex_fw[56:63], rt11_ex_fw[56:63], quotfounda7,  remainderb7,  dont[7]);  // Divides bytes 7

// 32-bit divisions (2 words)
DW_div_pipe #(32, 32, 0, 1, 2, 1, 2, 0) DW_div_pipe_12 (clk, !reset, 1'b1, rs11_ex_fw[0:31],  rt11_ex_fw[0:31],  quotw_quot0,  remaindw0,     dont[12]);  // Divides word 0
DW_div_pipe #(32, 32, 0, 1, 2, 1, 2, 0) DW_div_pipe_13 (clk, !reset, 1'b1, rs11_ex_fw[32:63], rt11_ex_fw[32:63], quotw_quot1,  remaindw1,     dont[13]);  // Divides word 1


	DW_div_pipe #(64, 64, 0, 1, 2, 1, 2, 0) DW_div_pipe_14 (
		clk,
		!reset,
		1'b1,
		rs11_ex_fw,
		rt11_ex_fw,
		quotd0,
		modulusd0,
		dont[14]
	);

	assign quotfounda = {quotfounda0, quotfounda1, quotfounda2, quotfounda3, quotfounda4, quotfounda5, quotfounda6, quotfounda7};
	assign quotfoundbd = {quotfoundbd0, quotfoundbd1, quotfoundbd2, quotfoundbd3};
	assign quotw_quot = {quotw_quot0, quotw_quot1};
	assign quotd = quotd0;

	always @(*)
	begin
		rt11_ex_fw = rt11_ex;
		if(wb_reg_wr && idstage_exstage_instru[175:179] == wb_wa && wb_wa != 5'b0)
		begin
			if(wb_ppp == 3'b000)
			begin
				rt11_ex_fw[0:63] = wb_wd[0:63];
			end
			if(wb_ppp == 3'b001)
			begin
				rt11_ex_fw[0:31] = wb_wd[0:31];
			end
			if(wb_ppp == 3'b010)
			begin
				rt11_ex_fw[32:63] = wb_wd[32:63];
			end
			if(wb_ppp == 3'b011)
			begin
				rt11_ex_fw[0:7] = wb_wd[0:7];
				rt11_ex_fw[16:23] = wb_wd[16:23];
				rt11_ex_fw[32:39] = wb_wd[32:39];
				rt11_ex_fw[48:55] = wb_wd[48:55];
			end
			if(wb_ppp == 3'b100)
			begin
				rt11_ex_fw[8:15] = wb_wd[8:15];
				rt11_ex_fw[24:31] = wb_wd[24:31];
				rt11_ex_fw[40:47] = wb_wd[40:47];
				rt11_ex_fw[56:63] = wb_wd[56:63];
			end
		end
	end

// 8-bit square root pipes (8 bytes)
DW_sqrt_pipe #(8, 0, 2, 1, 2, 0) DW_sqrt_pipe_0  (clk, !reset, 1'b1, rs11_ex_fw[0:7],    b0); assign sqrt_b0 = {4'b0, b0};   // sqrt(byte 0)
DW_sqrt_pipe #(8, 0, 2, 1, 2, 0) DW_sqrt_pipe_1  (clk, !reset, 1'b1, rs11_ex_fw[8:15],   b1); assign sqrt_b1 = {4'b0, b1};   // sqrt(byte 1)
DW_sqrt_pipe #(8, 0, 2, 1, 2, 0) DW_sqrt_pipe_2  (clk, !reset, 1'b1, rs11_ex_fw[16:23],  b2); assign sqrt_b2 = {4'b0, b2};   // sqrt(byte 2)
DW_sqrt_pipe #(8, 0, 2, 1, 2, 0) DW_sqrt_pipe_3  (clk, !reset, 1'b1, rs11_ex_fw[24:31],  b3); assign sqrt_b3 = {4'b0, b3};   // sqrt(byte 3)
DW_sqrt_pipe #(8, 0, 2, 1, 2, 0) DW_sqrt_pipe_4  (clk, !reset, 1'b1, rs11_ex_fw[32:39],  b4); assign sqrt_b4 = {4'b0, b4};   // sqrt(byte 4)
DW_sqrt_pipe #(8, 0, 2, 1, 2, 0) DW_sqrt_pipe_5  (clk, !reset, 1'b1, rs11_ex_fw[40:47],  b5); assign sqrt_b5 = {4'b0, b5};   // sqrt(byte 5)
DW_sqrt_pipe #(8, 0, 2, 1, 2, 0) DW_sqrt_pipe_6  (clk, !reset, 1'b1, rs11_ex_fw[48:55],  b6); assign sqrt_b6 = {4'b0, b6};   // sqrt(byte 6)
DW_sqrt_pipe #(8, 0, 2, 1, 2, 0) DW_sqrt_pipe_7  (clk, !reset, 1'b1, rs11_ex_fw[56:63],  b7); assign sqrt_b7 = {4'b0, b7};   // sqrt(byte 7)

// 16-bit square root pipes (4 half-words)
DW_sqrt_pipe #(16, 0, 2, 1, 2, 0) DW_sqrt_pipe_8  (clk, !reset, 1'b1, rs11_ex_fw[0:15],   h0); assign sqrt_h0 = {8'b0, h0};   // sqrt(half-word 0)
DW_sqrt_pipe #(16, 0, 2, 1, 2, 0) DW_sqrt_pipe_9  (clk, !reset, 1'b1, rs11_ex_fw[16:31],  h1); assign sqrt_h1 = {8'b0, h1};   // sqrt(half-word 1)
DW_sqrt_pipe #(16, 0, 2, 1, 2, 0) DW_sqrt_pipe_10 (clk, !reset, 1'b1, rs11_ex_fw[32:47],  h2); assign sqrt_h2 = {8'b0, h2};   // sqrt(half-word 2)
DW_sqrt_pipe #(16, 0, 2, 1, 2, 0) DW_sqrt_pipe_11 (clk, !reset, 1'b1, rs11_ex_fw[48:63],  h3); assign sqrt_h3 = {8'b0, h3};   // sqrt(half-word 3)

// 32-bit square root pipes (2 words)
DW_sqrt_pipe #(32, 0, 2, 1, 2, 0) DW_sqrt_pipe_12 (clk, !reset, 1'b1, rs11_ex_fw[0:31],   w0); assign sqrt_w0 = {16'b0, w0};  // sqrt(word 0)
DW_sqrt_pipe #(32, 0, 2, 1, 2, 0) DW_sqrt_pipe_13 (clk, !reset, 1'b1, rs11_ex_fw[32:63],  w1); assign sqrt_w1 = {16'b0, w1};  // sqrt(word 1)

// 64-bit square root pipe
DW_sqrt_pipe #(64, 0, 2, 1, 2, 0) DW_sqrt_pipe_14 (clk, !reset, 1'b1, rs11_ex_fw, d0);                           // sqrt(double word)
	assign sqrt_d0 = {32'b0, d0};

	assign sqrt_b = {sqrt_b0, sqrt_b1, sqrt_b2, sqrt_b3, sqrt_b4, sqrt_b5, sqrt_b6, sqrt_b7};

	shifter shifter_0 (shiftex, rs11_ex_fw, rt11_ex_fw, store_exage123, shiftingouter);

	always @(*)
	begin
		ex_out = 64'dx;
		case (code_ex1_ex1)
			3'b001: begin
				ex_out = out_alu1;
			end
			3'b010: begin
				if(store_exage123 == 2'b00)
					ex_out = outsqmultr;
				if(store_exage123 == 2'b01)
					ex_out = sqmultoutwe;
				if(store_exage123 == 2'b10)
					ex_out = sqmultoutree;
			end
			3'b011: begin
				if(store_exage123 == 2'b00)
					ex_out = moddivision_b;
				if(store_exage123 == 2'b01)
					ex_out = moddivision_h;
				if(store_exage123 == 2'b10)
					ex_out = moddivision_w;
				if(store_exage123 == 2'b11)
					ex_out = moddivision_d;
			end
			3'b100: begin
				if(store_exage123 == 2'b00)
					ex_out = sqrt_b;
				if(store_exage123 == 2'b01)
					ex_out = sqrt_h;
				if(store_exage123 == 2'b10)
					ex_out = sqrt_w;
				if(store_exage123 == 2'b11)
					ex_out = sqrt_d;
			end
			3'b110: begin
				ex_out = shiftingouter;
			end
			3'b101: begin
				ex_out = rs11_ex_fw;
			end
		endcase
	end

	always @(*)
	begin
		ex_mem_final_out = ex_out;
		if(load1_ex)
		begin
			ex_mem_final_out = Stalling_logic ? data_in : d_out;
		end
	end

	assign data_addr = {{16{1'b0}}, idstage_exstage_instru[128:143]};
	assign nic_addr = data_addr[30:31];

	assign data_out = rs11_ex_fw;
	assign d_in = rs11_ex_fw;

	assign mem_en = !(data_addr[16] && data_addr[17]) && (store_ex || (load1_ex && stall));
	assign mem_wr_en = !(data_addr[16] && data_addr[17]) && store_ex;

	assign nic_en = (data_addr[16] && data_addr[17]) && (store_ex || load1_ex);
	assign nic_wr_en = (data_addr[16] && data_addr[17]) && store_ex;
    
	assign stall = !Stalling_logic && ((load1_ex && !(data_addr[16] && data_addr[17])) || (ex_registerwrite && (code_ex1_ex1 == 3'b010 || code_ex1_ex1 == 3'b011 || code_ex1_ex1 == 3'b100)));

	assign takentaken = ex_branch && ((!ex_branch_takennz && rs11_ex_fw == 64'd0) || (ex_branch_takennz && rs11_ex_fw != 64'd0));

	// wb logic
	assign wb_wd = ex_eritebac_instr[0:63];
	assign wb_wa = ex_eritebac_instr[64:68];
	assign wb_ppp = ex_eritebac_instr[69:71];
	assign wb_reg_wr = ex_eritebac_instr[72];

	// forwarding from wb to rs11_ex
	always @(*)
	begin
		rs11_ex_fw = rs11_ex;
		if(wb_reg_wr && idstage_exstage_instru[170:174] == wb_wa && wb_wa != 5'b0)
		begin
			if(wb_ppp == 3'b000)
			begin
				rs11_ex_fw[0:63] = wb_wd[0:63];
			end
			if(wb_ppp == 3'b001)
			begin
				rs11_ex_fw[0:31] = wb_wd[0:31];
			end
			if(wb_ppp == 3'b010)
			begin
				rs11_ex_fw[32:63] = wb_wd[32:63];
			end
			if(wb_ppp == 3'b011)
			begin
				rs11_ex_fw[0:7] = wb_wd[0:7];
				rs11_ex_fw[16:23] = wb_wd[16:23];
				rs11_ex_fw[32:39] = wb_wd[32:39];
				rs11_ex_fw[48:55] = wb_wd[48:55];
			end
			if(wb_ppp == 3'b100)
			begin
				rs11_ex_fw[8:15] = wb_wd[8:15];
				rs11_ex_fw[24:31] = wb_wd[24:31];
				rs11_ex_fw[40:47] = wb_wd[40:47];
				rs11_ex_fw[56:63] = wb_wd[56:63];
			end
		end
	end

	// forwarding from wb to rt11_ex

	assign moddivision_b = !moddiv_ex ? quotfounda : remainderb;
	assign moddivision_h = !moddiv_ex ? quotfoundbd : remainder_mod;
	assign moddivision_w = !moddiv_ex ? quotw_quot : remaindw;
	assign moddivision_d = !moddiv_ex ? quotd : modulusd;
	always @(posedge clk)
	begin
    if(reset)
    begin
        pc <= 32'd0;

        Stalling_logic <= 1'b0;

        ifstage_idstage_instrcutio <= 33'd0;
        idstage_exstage_instru <= 180'd0;
        ex_eritebac_instr <= 73'd0;

		ifstage_idstage_instrcutio[32] <= 1'b1; // wb_ff

		idstage_exstage_instru[149] <= 1'b0; // reg_wr
		idstage_exstage_instru[160] <= 1'b0; // ld
		idstage_exstage_instru[161] <= 1'b0; // st
		idstage_exstage_instru[163] <= 1'b0; // branch

		ex_eritebac_instr[72] <= 1'b0; // reg_wr
    end
    else
    begin
        Stalling_logic <= stall;

        if(!stall)
        begin
            if(takentaken)
            begin
                pc <= {{16{1'b0}}, idstage_exstage_instru[128:143]};
            end
            else
            begin
                pc <= pc + 4;
            end

			ifstage_idstage_instrcutio <= {instr, takentaken}; // not taken branch

            idstage_exstage_instru <= {
                rsid, 
				rtid_id, 
				ifstage_idstage_instrcutio[16:31], 
				ifstage_idstage_instrcutio[6:10],
                wr_regid, 
				aluopid, 
				oddevenid, 
				moddivid, 
				id_shift,
                idexop, 
				loadid, 
				storeid, 
				branchid_dec, 
				branchidPrepl,
                ifstage_idstage_instrcutio[24:25], 
				ifstage_idstage_instrcutio[21:23], 
				sqmultidstage, 
				ra11_id, 
				ra22_id
            };

			// 0:63, 64:68, 69:71, 72
			// wd, wa, ppp, reg_wr
            ex_eritebac_instr <= {ex_mem_final_out, idstage_exstage_instru[144:148], idstage_exstage_instru[166:168], idstage_exstage_instru[149]};
        end
    end
end

endmodule

//-----------------------------------------------------------------------------
// Module: logic_op
// Description: Performs logical and arithmetic operations (bitwise and vector)
//              based on opcode and width mode. Supports AND, OR, XOR, NOT,
//              VADD (vector add), and VSUB (vector subtract).
//-----------------------------------------------------------------------------

module logic_op (
    input [0:2] opcide_ex,            // 3-bit ALU operation selector
    input [0:63] rs11_ex_fw,            // First source operand (64-bit)
    input [0:63] rt11_ex_fw,            // Second source operand (64-bit)
    input [0:1] store_exage123,                // Width specifier:
                                      // 00: 8-bit elements
                                      // 01: 16-bit elements
                                      // 10: 32-bit elements
                                      // 11: 64-bit (full register)
    output reg [0:63] out_alu1         // ALU result (64-bit)
);

    always @(*) begin
        // Default output set to 0 (in case no operation matches)
        out_alu1 = 64'd0;

        // ---------------------
        // Bitwise AND Operation
        // ---------------------
        if (opcide_ex == 3'b000) begin
            out_alu1 = rs11_ex_fw & rt11_ex_fw;

        // ---------------------
        // Bitwise OR Operation
        // ---------------------
        end else if (opcide_ex == 3'b001) begin
            out_alu1 = rs11_ex_fw | rt11_ex_fw;

        // ---------------------
        // Bitwise XOR Operation
        // ---------------------
        end else if (opcide_ex == 3'b010) begin
            out_alu1 = rs11_ex_fw ^ rt11_ex_fw;

        // ---------------------
        // Bitwise NOT Operation (only uses first operand)
        // ---------------------
        end else if (opcide_ex == 3'b011) begin
            out_alu1 = ~rs11_ex_fw;

        // ---------------------
        // Vector ADD Operation
        // Each element size is determined by store_exage123
        // ---------------------
        end else if (opcide_ex == 3'b100) begin
            // Vector of 8-bit adds
            if (store_exage123 == 2'b00) begin
                out_alu1 = {
                    rs11_ex_fw[0:7]   + rt11_ex_fw[0:7],
                    rs11_ex_fw[8:15]  + rt11_ex_fw[8:15],
                    rs11_ex_fw[16:23] + rt11_ex_fw[16:23],
                    rs11_ex_fw[24:31] + rt11_ex_fw[24:31],
                    rs11_ex_fw[32:39] + rt11_ex_fw[32:39],
                    rs11_ex_fw[40:47] + rt11_ex_fw[40:47],
                    rs11_ex_fw[48:55] + rt11_ex_fw[48:55],
                    rs11_ex_fw[56:63] + rt11_ex_fw[56:63]
                };

            // Vector of 16-bit adds
            end else if (store_exage123 == 2'b01) begin
                out_alu1 = {
                    rs11_ex_fw[0:15]   + rt11_ex_fw[0:15],
                    rs11_ex_fw[16:31]  + rt11_ex_fw[16:31],
                    rs11_ex_fw[32:47]  + rt11_ex_fw[32:47],
                    rs11_ex_fw[48:63]  + rt11_ex_fw[48:63]
                };

            // Vector of 32-bit adds
            end else if (store_exage123 == 2'b10) begin
                out_alu1 = {
                    rs11_ex_fw[0:31]   + rt11_ex_fw[0:31],
                    rs11_ex_fw[32:63]  + rt11_ex_fw[32:63]
                };

            // 64-bit add (scalar)
            end else begin
                out_alu1 = rs11_ex_fw + rt11_ex_fw;
            end

        // ---------------------
        // Vector SUB Operation
        // Each element size is determined by store_exage123
        // ---------------------
        end else if (opcide_ex == 3'b101) begin
            // Vector of 8-bit subs
            if (store_exage123 == 2'b00) begin
                out_alu1 = {
                    rs11_ex_fw[0:7]   - rt11_ex_fw[0:7],
                    rs11_ex_fw[8:15]  - rt11_ex_fw[8:15],
                    rs11_ex_fw[16:23] - rt11_ex_fw[16:23],
                    rs11_ex_fw[24:31] - rt11_ex_fw[24:31],
                    rs11_ex_fw[32:39] - rt11_ex_fw[32:39],
                    rs11_ex_fw[40:47] - rt11_ex_fw[40:47],
                    rs11_ex_fw[48:55] - rt11_ex_fw[48:55],
                    rs11_ex_fw[56:63] - rt11_ex_fw[56:63]
                };

            // Vector of 16-bit subs
            end else if (store_exage123 == 2'b01) begin
                out_alu1 = {
                    rs11_ex_fw[0:15]   - rt11_ex_fw[0:15],
                    rs11_ex_fw[16:31]  - rt11_ex_fw[16:31],
                    rs11_ex_fw[32:47]  - rt11_ex_fw[32:47],
                    rs11_ex_fw[48:63]  - rt11_ex_fw[48:63]
                };

            // Vector of 32-bit subs
            end else if (store_exage123 == 2'b10) begin
                out_alu1 = {
                    rs11_ex_fw[0:31]   - rt11_ex_fw[0:31],
                    rs11_ex_fw[32:63]  - rt11_ex_fw[32:63]
                };

            // 64-bit sub (scalar)
            end else begin
                out_alu1 = rs11_ex_fw - rt11_ex_fw;
            end
        end
    end

endmodule

// Decoder module: Generates control signals based on the op-code and function code.
// Port names have been updated to match the instantiation names.
module demux (
    input  wire [0:5]  id_opcode,        // Operation code from the instruction
    input  wire [0:5]  idfunclogic,  // Function code (for R-type instructions)
    input  wire        flushingid,          // Signal to flush the pipeline (e.g. branch misprediction)
    input  wire        takentaken,      // Indicates that a branch is taken
    output reg         wr_regid,         // Register write enable
    output reg [0:2]   aluopid,         // ALU operation selector
    output reg         oddevenid,       // Even/odd flag for certain operations
    output reg         moddivid,        // Selects between division and modulo
    output reg [0:1]   id_shift,          // Shift operation selector
    output reg [0:2]   idexop,        // Execution code to choose the data path in EX stage
    output reg         loadid,             // Load signal
    output reg         storeid,             // Store signal
    output reg         branchid_dec,    // Branch condition (zero or non-zero)
    output reg         branchidPrepl,         // Branch signal
    output reg         sqmultidstage      // Select between multiplication and square operations
);

	// Default assignments for control signals.
	always @(*) begin
		wr_regid      = 1'b0;
		aluopid      = 3'b000;
		oddevenid    = 1'b0;
		moddivid     = 1'b0;
		id_shift       = 2'b00;
		idexop     = 3'b000;
		loadid          = 1'b0;
		storeid          = 1'b0;
		branchid_dec = 1'b0;
		branchidPrepl      = 1'b0;
		sqmultidstage  = 1'b0;
		
		// Only generate control signals if not flushing and no branch is taken.
		if (!flushingid && !takentaken) begin
			// R-Type instruction: op_code equals 6'b101010
			if (id_opcode == 6'b101010) begin
				wr_regid = 1'b1;
				loadid     = 1'b0;
				storeid     = 1'b0;
				branchidPrepl = 1'b0;
				// R-Type operations determined by function_code:
				if (idfunclogic == 6'b000001) begin      // Specific R-type operation
					aluopid  = 3'b000;
					idexop = 3'b001;
				end else if (idfunclogic == 6'b000010) begin // OR
					aluopid  = 3'b001;
					idexop = 3'b001;
				end else if (idfunclogic == 6'b000011) begin // XOR
					aluopid  = 3'b010;
					idexop = 3'b001;
				end else if (idfunclogic == 6'b000100) begin // NOT
					aluopid  = 3'b011;
					idexop = 3'b001;
				end else if (idfunclogic == 6'b000101) begin // MOV
					idexop = 3'b101;
				end else if (idfunclogic == 6'b000110) begin // ADD
					aluopid  = 3'b100;
					idexop = 3'b001;
				end else if (idfunclogic == 6'b000111) begin // SUB
					aluopid  = 3'b101;
					idexop = 3'b001;
				end else if (idfunclogic == 6'b001000) begin // MULEU
					sqmultidstage = 1'b0;
					oddevenid   = 1'b0;
					idexop    = 3'b010;
				end else if (idfunclogic == 6'b001001) begin // MULOU
					sqmultidstage = 1'b0;
					oddevenid   = 1'b1;
					idexop    = 3'b010;
				end else if (idfunclogic == 6'b001010) begin // SLL
					id_shift   = 2'b00;
					idexop = 3'b110;
				end else if (idfunclogic == 6'b001011) begin // SRL
					id_shift   = 2'b01;
					idexop = 3'b110;
				end else if (idfunclogic == 6'b001100) begin // SRA
					id_shift   = 2'b10;
					idexop = 3'b110;
				end else if (idfunclogic == 6'b001101) begin // RTTH
					id_shift   = 2'b11;
					idexop = 3'b110;
				end else if (idfunclogic == 6'b001110) begin // DIV
					moddivid = 1'b0;
					idexop = 3'b011;
				end else if (idfunclogic == 6'b001111) begin // MOD
					moddivid = 1'b1;
					idexop = 3'b011;
				end else if (idfunclogic == 6'b010000) begin // SQEU
					sqmultidstage = 1'b1;
					oddevenid   = 1'b0;
					idexop    = 3'b010;
				end else if (idfunclogic == 6'b010001) begin // SQOU
					sqmultidstage = 1'b1;
					oddevenid   = 1'b1;
					idexop    = 3'b010;
				end else if (idfunclogic == 6'b010010) begin // SQRT
					idexop = 3'b100;
				end else begin
					// Default case for unrecognized function_code.
					idexop = 3'b000; 
					wr_regid  = 1'b0;
					loadid      = 1'b0;
					storeid      = 1'b0;
					branchidPrepl  = 1'b0;
				end
			// Load instruction: op_code equals 6'b100000
			end else if (id_opcode == 6'b100000) begin
				wr_regid = 1'b1;
				loadid     = 1'b1;
				storeid     = 1'b0;
				branchidPrepl = 1'b0;
			// Store instruction: op_code equals 6'b100001
			end else if (id_opcode == 6'b100001) begin
				wr_regid = 1'b0;
				loadid     = 1'b0;
				storeid     = 1'b1;
				branchidPrepl = 1'b0;
			// Branch if equal to zero (bez): op_code equals 6'b100010
			end else if (id_opcode == 6'b100010) begin
				wr_regid      = 1'b0;
				loadid          = 1'b0;
				storeid          = 1'b0;
				branchid_dec = 1'b0;
				branchidPrepl      = 1'b1;
			// Branch if not equal to zero (bnez): op_code equals 6'b100011
			end else if (id_opcode == 6'b100011) begin
				wr_regid      = 1'b0;
				loadid          = 1'b0;
				storeid          = 1'b0;
				branchid_dec = 1'b1;
				branchidPrepl      = 1'b1;
			// No-operation (nop): op_code equals 6'b111100
			end else if (id_opcode == 6'b111100) begin
				idexop = 3'b000;
				wr_regid  = 1'b0;
				loadid      = 1'b0;
				storeid      = 1'b0;
				branchidPrepl  = 1'b0;
			end
		end
	end

endmodule

