`timescale 1ns / 1ps

module tb_pattern_detector;

    localparam MAX_LEN      = 8;
    localparam NUM_PATTERNS = 4;

    reg        clk;
    reg        rst_n;
    reg        data_in;
    reg        data_valid;
    reg        cfg_we;
    reg  [1:0] cfg_idx;
    reg  [7:0] cfg_pattern;
    reg  [7:0] cfg_mask;
    reg        cfg_en;
    
    wire [3:0] pattern_match;
    wire       any_match;

    pattern_detector dut (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .data_valid(data_valid),
        .cfg_we(cfg_we),
        .cfg_idx(cfg_idx),
        .cfg_pattern(cfg_pattern),
        .cfg_mask(cfg_mask),
        .cfg_en(cfg_en),
        .pattern_match(pattern_match),
        .any_match(any_match)
    );

    always #5 clk = ~clk;

    task program_slot(input [1:0] idx, input [7:0] pattern, input [7:0] mask);
    begin
        @(posedge clk);
        cfg_we      <= 1'b1;
        cfg_idx     <= idx;
        cfg_pattern <= pattern;
        cfg_mask    <= mask;
        cfg_en      <= 1'b1;
        @(posedge clk);
        cfg_we      <= 1'b0;
    end
    endtask

    task push_bit(input b);
    begin
        @(posedge clk);
        data_valid <= 1'b1;
        data_in    <= b;
    end
    endtask

    initial begin
        $dumpfile("sim/waveform.vcd");
        $dumpvars(0, tb_pattern_detector);

        clk = 0; rst_n = 0; data_in = 0; data_valid = 0; cfg_we = 0;
        #20 rst_n = 1;
        #10;

        // Slot 0: 3-bit '101'   (0x05, Mask 0x07)
        program_slot(2'd0, 8'b0000_0101, 8'b0000_0111);

        // Slot 1: 4-bit '1101'  (0x0D, Mask 0x0F)
        program_slot(2'd1, 8'b0000_1101, 8'b0000_1111);

        // Slot 2: 5-bit '10101' (0x15, Mask 0x1F)
        program_slot(2'd2, 8'b0001_0101, 8'b0001_1111);

        #30;
        // Stream: 1 -> 1 -> 0 -> 1 (Triggers Slot 0 & Slot 1 simultaneously)
        push_bit(1); push_bit(1); push_bit(0); push_bit(1);

        // Stream: 0 -> 1 (Triggers Slot 0 & Slot 2 simultaneously)
        push_bit(0); push_bit(1);

        @(posedge clk);
        data_valid <= 0;
        #50;

        $display(">> Multi-match test complete. Inspecting sim/waveform.vcd");
        $finish;
    end

endmodule
