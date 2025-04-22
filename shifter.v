`include "./design/DW_shifter.v"

module shifter (

    input [0:1] shift,                              // 2-bit code for operation selection
    input [0:63] ra,                                // First operand (64 bits)
    input [0:63] rb,                                // Second operand (64 bits)
    input [0:1] ww,                                 // Width width for variable operation size (00 = 8-bit, 01 = 16-bit, 10 = 32-bit, 11 = 64-bit)
    output reg [0:63] out                           // Shift/Rotate result

);

    reg [0:5] amt1, amt2, amt3, amt4, amt5, amt6, amt7, amt8; 
    wire [0:63] sra_b, sra_h, sra_w, sra_d; 
    reg [0:3] b0, b1, b2, b3, b4, b5, b6, b7;
    reg [0:4] h0, h1, h2, h3;
    reg [0:5] w0, w1;
    reg [0:6] d0; 

    DW_shifter #(8, 4, 0) DW_shifter_b_0 (ra[0:7], 1'b1, b0, 1'b1, 1'b1, sra_b[0:7]);
    DW_shifter #(8, 4, 0) DW_shifter_b_1 (ra[8:15], 1'b1, b1, 1'b1, 1'b1, sra_b[8:15]);
    DW_shifter #(8, 4, 0) DW_shifter_b_2 (ra[16:23], 1'b1, b2, 1'b1, 1'b1, sra_b[16:23]);
    DW_shifter #(8, 4, 0) DW_shifter_b_3 (ra[24:31], 1'b1, b3, 1'b1, 1'b1, sra_b[24:31]);
    DW_shifter #(8, 4, 0) DW_shifter_b_4 (ra[32:39], 1'b1, b4, 1'b1, 1'b1, sra_b[32:39]);
    DW_shifter #(8, 4, 0) DW_shifter_b_5 (ra[40:47], 1'b1, b5, 1'b1, 1'b1, sra_b[40:47]);
    DW_shifter #(8, 4, 0) DW_shifter_b_6 (ra[48:55], 1'b1, b6, 1'b1, 1'b1, sra_b[48:55]);
    DW_shifter #(8, 4, 0) DW_shifter_b_7 (ra[56:63], 1'b1, b7, 1'b1, 1'b1, sra_b[56:63]);
    DW_shifter #(16, 5, 0) DW_shifter_h_0 (ra[0:15], 1'b1, h0, 1'b1, 1'b1, sra_h[0:15]);
    DW_shifter #(16, 5, 0) DW_shifter_h_1 (ra[16:31], 1'b1, h1, 1'b1, 1'b1, sra_h[16:31]);
    DW_shifter #(16, 5, 0) DW_shifter_h_2 (ra[32:47], 1'b1, h2, 1'b1, 1'b1, sra_h[32:47]);
    DW_shifter #(16, 5, 0) DW_shifter_h_3 (ra[48:63], 1'b1, h3, 1'b1, 1'b1, sra_h[48:63]);
    DW_shifter #(32, 6, 0) DW_shifter_w_0 (ra[0:31], 1'b1, w0, 1'b1, 1'b1, sra_w[0:31]);
    DW_shifter #(32, 6, 0) DW_shifter_w_1 (ra[32:63], 1'b1, w1, 1'b1, 1'b1, sra_w[32:63]);
    DW_shifter #(64, 7, 0) DW_shifter_d_0 (ra[0:63], 1'b1, d0, 1'b1, 1'b1, sra_d[0:63]);

    always @(*) begin
    b0=0; b1=0; b2=0; b3=0; b4=0; b5=0; b6=0; b7=0;
    h0=0; h1=0; h2=0; h3=0;
    w0=0; w1=0;
    d0=0; 
        case(shift)

            2'b00: begin                            //SLL 
                case(ww)
                2'b00: begin
                    amt1 = rb[5:7];
                    amt2 = rb[13:15];
                    amt3 = rb[21:23];
                    amt4 = rb[29:31];
                    amt5 = rb[37:39];
                    amt6 = rb[45:47];
                    amt7 = rb[53:55];
                    amt8 = rb[61:63];
                    out = { ra[0 +: 8] << amt1, ra[8 +: 8] << amt2, 
                            ra[16 +: 8] << amt3, ra[24 +: 8] << amt4, 
                            ra[32 +: 8] << amt5, ra[40 +: 8] << amt6, 
                            ra[48 +: 8] << amt7, ra[56 +: 8] << amt8 };
                end

                2'b01: begin
                    amt1 = rb[12:15];
                    amt2 = rb[28:31];
                    amt3 = rb[44:47];
                    amt4 = rb[60:63];
                    out = { ra[0 +: 16] << amt1, ra[16 +: 16] << amt2,
                            ra[32 +: 16] << amt3, ra[48 +: 16] << amt4 };
                end

                2'b10: begin
                    amt1 = rb[27:31];
                    amt2 = rb[59:63];
                    out = { ra[0 +: 32] << amt1, ra[32 +: 32] << amt2 };
                end

                2'b11: begin
                    amt1 = rb[58:63];
                    out = { ra << amt1 };
                end
                endcase 
            end

            2'b01: begin                            //SRL
                case(ww)
                2'b00: begin
                    amt1 = rb[5:7];
                    amt2 = rb[13:15];
                    amt3 = rb[21:23];
                    amt4 = rb[29:31];
                    amt5 = rb[37:39];
                    amt6 = rb[45:47];
                    amt7 = rb[53:55];
                    amt8 = rb[61:63];
                    out = { ra[0 +: 8] >> amt1, ra[8 +: 8] >> amt2, 
                            ra[16 +: 8] >> amt3, ra[24 +: 8] >> amt4, 
                            ra[32 +: 8] >> amt5, ra[40 +: 8] >> amt6, 
                            ra[48 +: 8] >> amt7, ra[56 +: 8] >> amt8 };
                end

                2'b01: begin
                    amt1 = rb[12:15];
                    amt2 = rb[28:31];
                    amt3 = rb[44:47];
                    amt4 = rb[60:63];
                    out = { ra[0 +: 16] >> amt1, ra[16 +: 16] >> amt2,
                            ra[32 +: 16] >> amt3, ra[48 +: 16] >> amt4 };
                end

                2'b10: begin
                    amt1 = rb[27:31];
                    amt2 = rb[59:63];
                    out = { ra[0 +: 32] >> amt1, ra[32 +: 32] >> amt2 };
                end

                2'b11: begin
                    amt1 = rb[58:63];
                    out = { ra >> amt1 };
                end
                endcase 
            end

            2'b10: begin // SRA
            b0 = ({1'b0, rb[5:7]} ^ 4'b1111) + 1;
            b1 = ({1'b0, rb[13:15]} ^ 4'b1111) + 1;
            b2 = ({1'b0, rb[21:23]} ^ 4'b1111) + 1;
            b3 = ({1'b0, rb[29:31]} ^ 4'b1111) + 1;
            b4 = ({1'b0, rb[37:39]} ^ 4'b1111) + 1;
            b5 = ({1'b0, rb[45:47]} ^ 4'b1111) + 1;
            b6 = ({1'b0, rb[53:55]} ^ 4'b1111) + 1;
            b7 = ({1'b0, rb[61:63]} ^ 4'b1111) + 1;
            h0 = ({1'b0, rb[12:15]} ^ 5'b11111) + 1;
            h1 = ({1'b0, rb[28:31]} ^ 5'b11111) + 1;
            h2 = ({1'b0, rb[44:47]} ^ 5'b11111) + 1;
            h3 = ({1'b0, rb[60:63]} ^ 5'b11111) + 1;
            w0 = ({1'b0, rb[27:31]} ^ 6'b111111) + 1;
            w1 = ({1'b0, rb[59:63]} ^ 6'b111111) + 1;
            d0 = ({1'b0, rb[58:63]} ^ 7'b1111111) + 1;
            case(ww)
                2'b00: out = sra_b[0:63];
                2'b01: out = sra_h[0:63];
                2'b10: out = sra_w[0:63];
                2'b11: out = sra_d[0:63];
                endcase 
            end

            2'b11: begin                            //RTTH
                case(ww)
                2'b00: out = {ra[4:7], ra[0:3], ra[12:15], ra[8:11], ra[20:23], ra[16:19], ra[28:31], ra[24:27],
                             ra[36:39], ra[32:35], ra[44:47], ra[40:43], ra[52:55], ra[48:51], ra[60:63], ra[56:59]};
                2'b01: out = {ra[8:15], ra[0:7], ra[24:31], ra[16:23], ra[40:47], ra[32:39], ra[56:63], ra[48:55]};
                2'b10: out = {ra[16:31], ra[0:15], ra[48:63], ra[32:47]};
                2'b11: out = {ra[32:63], ra[0:31]};
                endcase 
            end

            default: begin 
                out = 64'b0;                        // Default case for undefined shift codes
            end 

        endcase 
    end

endmodule 