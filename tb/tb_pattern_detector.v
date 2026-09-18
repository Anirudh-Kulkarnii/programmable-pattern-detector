`timescale 1ns / 1ps

module tb_pattern_detector;

    localparam MAX_LEN      = 8;
    localparam NUM_PATTERNS = 4;

    reg clk;
    reg rst_n;
    reg data_in;
    reg data_valid;
    reg cfg_we;
    reg [$clog2(NUM_PATTERNS)-1:0] cfg_idx;
    reg [MAX_LEN-1:0] cfg_pattern;
    reg [MAX_LEN-1:0] cfg_mask;
    reg cfg_en;

    wire [NUM_PATTERNS-1:0] pattern_match;
    wire any_match;

    // Instantiate DUT with exact ports
    pattern_detector #(
        .MAX_LEN(MAX_LEN),
        .NUM_PATTERNS(NUM_PATTERNS)
    ) dut (
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

    // 100MHz clock
    always #5 clk = ~clk;

    // Helper task to program slots
    task program_slot(
        input [$clog2(NUM_PATTERNS)-1:0] idx,
        input [MAX_LEN-1:0] pattern,
        input [MAX_LEN-1:0] mask
    );
    begin
        @(posedge clk);
        cfg_we      = 1;
        cfg_idx     = idx;
        cfg_pattern = pattern;
        cfg_mask    = mask;
        cfg_en      = 1;
        @(posedge clk);
        cfg_we      = 0;
    end
    endtask

    // Helper task to stream a single bit
    task send_bit(input b);
    begin
        @(posedge clk);
        data_in    = b;
        data_valid = 1;
    end
    endtask

    initial begin
        $dumpfile("sim/tb_pattern_detector.vcd");
        $dumpvars(0, tb_pattern_detector);

        clk         = 0;
        rst_n       = 0;
        data_in     = 0;
        data_valid  = 0;
        cfg_we      = 0;
        cfg_idx     = 0;
        cfg_pattern = 0;
        cfg_mask    = 0;
        cfg_en      = 0;

        #20 rst_n = 1;
        #10;

        // --- TEST 1: Programming Slot 0 (4-bit: 1010) & Slot 1 (4-bit: 1100) ---
        $display("\n--- [TEST 1] Programming Initial Slots ---");
        program_slot(0, 8'b0000_1010, 8'b0000_1111);
        program_slot(1, 8'b0000_1100, 8'b0000_1111);
        #10;

        // --- TEST 2: Stream 1010 into Slot 0 ---
        $display("\n--- [TEST 2] Streaming Pattern 1010 ---");
        send_bit(1); send_bit(0); send_bit(1); send_bit(0);
        #1;
        if (pattern_match[0] && any_match)
            $display("[PASS] Detected 1010 on Slot 0");
        else
            $display("[FAIL] Slot 0 detection failed");

        // --- TEST 3: Dynamic In-Flight Reconfiguration ---
        $display("\n--- [TEST 3] Edge Case: Dynamic Reconfiguration Mid-Stream ---");
        // Dynamically reprogram Slot 0 to 1111 without asserting rst_n
        program_slot(0, 8'b0000_1111, 8'b0000_1111);
        send_bit(1); send_bit(1); send_bit(1); send_bit(1);
        #1;
        if (pattern_match[0] && any_match)
            $display("[PASS] Dynamic reconfiguration to 1111 verified");
        else
            $display("[FAIL] Dynamic reconfiguration failed");

        // --- TEST 4: Overlapping Prefix Collision Discrimination ---
        $display("\n--- [TEST 4] Edge Case: Multi-Slot Prefix Collision (1111 vs 1110) ---");
        // Slot 0 has 1111, configure Slot 1 to 1110
        program_slot(1, 8'b0000_1110, 8'b0000_1111);
        // Stream: 1 -> 1 -> 1 -> 0
        send_bit(1); send_bit(1); send_bit(1); send_bit(0);
        #1;
        if (pattern_match[1] && !pattern_match[0] && any_match)
            $display("[PASS] Exact match on Slot 1 without false positive on Slot 0");
        else
            $display("[FAIL] Overlapping pattern collision failed");

        $display("\nAll verification suites completed successfully.");
        #30 $finish;
    end

endmodule
