module nic (
    input wire clk,                   // Clock signal
    input wire reset,                 // Reset signal
    input wire [1:0] addr,            // 2-bit Address input
    input wire [63:0] d_in,           // 64-bit Data input
    output reg [63:0] d_out,          // 64-bit Data output
    input wire nicEn,                 // NIC Enable signal
    input wire nicWrEn,               // NIC Write Enable signal
    output wire net_so,               // Network Shift Out
    input wire net_ro,                // Network Read Output (ready)
    output wire [63:0] net_do,        // 64-bit Data output to Network
    input wire net_polarity,          // Network Polarity signal
    input wire net_si,                // Network Shift In
    output wire net_ri,               // Network Read Input (ready)
    input wire [63:0] net_di          // 64-bit Data input from Network
);

    // Internal Registers for NOC and NIC Buffers and Shift Registers
    reg [63:0] noc_buffer, nic_buffer;
    reg noc_sr, nic_sr;
    always @(*) begin
        if (!nicEn) begin
            d_out = 64'd0;  // If NIC is not enabled, output zero
        end else begin
            case (addr)
                2'b00: d_out = nic_buffer;          // NIC buffer data
                2'b01: begin
                    d_out[62:0] = 63'd0;            // Clear lower 63 bits
                    d_out[63] = nic_sr;             // Indicate NIC shift register status
                end
                2'b10: d_out = noc_buffer;          // NOC buffer data
                default: begin
                    d_out[62:0] = 63'd0;            // Clear lower 63 bits
                    d_out[63] = noc_sr;             // Indicate NOC shift register status
                end
            endcase
        end
    end
    // Assign network output signals
    assign net_so = noc_sr && noc_buffer[0] != net_polarity;  // Network Shift Out condition
    assign net_do = noc_buffer;                                 // 64-bit Data output to Network
    assign net_ri = !nic_sr;                                     // Indicate NIC is ready to receive data

    // Always block for sequential logic on the positive edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            // Reset buffers and shift registers
            noc_sr <= 1'b0;
            nic_sr <= 1'b0;
            noc_buffer <= 64'd0;    // Reset NOC buffer
            nic_buffer <= 64'd0;    // Reset NIC buffer
        end else begin
            // Data transfer into NOC buffer (write operation)
            if (!noc_sr && nicEn && nicWrEn && addr == 2'b10) begin
                noc_buffer <= d_in;
                noc_sr <= 1'b1;    // Indicate data available in NOC buffer
            end

            // Data transfer out of NOC buffer (read operation)
            if (net_ro && (noc_buffer[0] != net_polarity) && noc_sr) begin
                noc_sr <= 1'b0;    // Clear shift register flag after transfer
            end

            // Data transfer into NIC buffer (write operation)
            if (net_si && !nic_sr) begin
                nic_buffer <= net_di;
                nic_sr <= 1'b1;    // Indicate data available in NIC buffer
            end

            // Data transfer out of NIC buffer (read operation)
            if ((!nicWrEn && addr == 2'b00)  && nicEn && nic_sr) begin
                nic_sr <= 1'b0;    // Clear shift register flag after transfer
            end
        end
    end



endmodule

