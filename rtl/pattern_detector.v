`timescale 1ns / 1ps
`default_nettype none

module pattern_detector #(
    parameter MAX_LEN = 8,
    parameter NUM_PATTERNS = 4
)(
    input  wire clk,
    input  wire rst_n,

    // Serial data input
    input  wire data_in,
    input  wire data_valid,

    // Runtime configuration interface
    input  wire cfg_we,
    input  wire [$clog2(NUM_PATTERNS)-1:0] cfg_idx,
    input  wire [MAX_LEN-1:0] cfg_pattern,
    input  wire [MAX_LEN-1:0] cfg_mask,
    input  wire cfg_en,

    // Output match flags
    output wire [NUM_PATTERNS-1:0] pattern_match,
    output wire any_match
);

    // Sliding shift register for data stream
    reg [MAX_LEN-1:0] shift_reg;

    // Pattern configuration storage
    reg [MAX_LEN-1:0] patterns [0:NUM_PATTERNS-1];
    reg [MAX_LEN-1:0] masks    [0:NUM_PATTERNS-1];
    reg [NUM_PATTERNS-1:0] enabled;

    // 1. Shift register datapath
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= {MAX_LEN{1'b0}};
        end else if (data_valid) begin
            shift_reg <= {shift_reg[MAX_LEN-2:0], data_in};
        end
    end

    // 2. Configuration storage logic
    integer k;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            enabled <= {NUM_PATTERNS{1'b0}};
            for (k = 0; k < NUM_PATTERNS; k = k + 1) begin
                patterns[k] <= {MAX_LEN{1'b0}};
                masks[k]    <= {MAX_LEN{1'b0}};
            end
        end else if (cfg_we) begin
            enabled[cfg_idx]  <= cfg_en;
            patterns[cfg_idx] <= cfg_pattern;
            masks[cfg_idx]    <= cfg_mask;
        end
    end

    // 3. Parallel masked comparison logic
    genvar p;
    generate
        for (p = 0; p < NUM_PATTERNS; p = p + 1) begin : gen_match
            assign pattern_match[p] = enabled[p] && 
                                      (((shift_reg ^ patterns[p]) & masks[p]) == {MAX_LEN{1'b0}});
        end
    endgenerate

    // 4. Any match reduction
    assign any_match = |pattern_match;

endmodule
`default_nettype wire
