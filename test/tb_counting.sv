module tb_counting();

    logic clk, rst_n, btn_sync;
    logic dah, end_of_ditdah, end_of_word, end_of_letter;

    int pass_count = 0;
    int fail_count = 0;

    counting dut (.*);

    initial clk = 0;
    always #5 clk = ~clk;

    // Force ticks to go high then low instead of waiting 1 second
    task force_ticks(input int n);
        repeat(n) begin
            @(posedge clk);
            force dut.tick = 1'b1;
            @(posedge clk);
            force dut.tick = 1'b0;
        end
        release dut.tick;
    endtask

    task check_signal(input string label, input logic actual, input logic expected);
        if (actual === expected) begin
            $display("PASS: %s = %b", label, actual);
            pass_count++;
        end else begin
            $display("FAIL: %s expected %b, got %b", label, expected, actual);
            fail_count++;
        end
    endtask

    // Mimics pressing btn_sync
    task press_and_release(input int hold_ticks, input logic expect_dah);
        @(posedge clk);
        // Press the button
        btn_sync = 1'b1;
        force_ticks(hold_ticks);

        @(posedge clk); 
        #1;              
        btn_sync = 1'b0; // Release the button after the next posedge

        check_signal("dit (0) or dah (1)", dah, expect_dah);
        check_signal("end_of_ditdah high on release", end_of_ditdah, 1'b1);

        @(posedge clk); #1;
        check_signal("end_of_ditdah low after release", end_of_ditdah, 1'b0);
    endtask

    initial begin
        btn_sync = 0;
        rst_n = 1'b0;
        @(posedge clk);
        rst_n = 1'b1;
        @(posedge clk);

        // Press for a dit (1 tick)
        $display("Test 1: Press for a dit (1 tick)");
        press_and_release(1, 1'b0);
        @(posedge clk);

        // Press for 2 ticks
        $display("Test 2: Press for a dit (2 tick)");
        press_and_release(2, 1'b0);
        @(posedge clk);

        // Press for 3 ticks (dah)
        $display("Test 3: Press for a dah (3 ticks)");
        press_and_release(3, 1'b1);
        @(posedge clk);

        // Press for 5 ticks
        $display("Test 4: Press for a dah (5 ticks)");
        press_and_release(5, 1'b1);
        @(posedge clk);

        $display("Test 5: End of letter");
        press_and_release(1, 1'b0);

        btn_sync = 0;
        force_ticks(2);
        @(posedge clk); #1;
        check_signal("end_of_letter low at tick 2", end_of_letter, 1'b0);

        // Tick 3 
        force dut.tick = 1'b1;
        @(posedge clk); #1;
        check_signal("end_of_letter high at tick 3", end_of_letter, 1'b1);
        force dut.tick = 1'b0;
        release dut.tick;

        @(posedge clk); #1;
        check_signal("end_of_letter low after pulse", end_of_letter, 1'b0);

        // Test 6
        $display("Test 6: end_of_word at 7 ticks of space");
        // reset space_count
        press_and_release(1, 1'b0); 

        btn_sync = 0;
        force_ticks(6);
        @(posedge clk); #1;
        check_signal("end_of_word low at tick 6", end_of_word, 1'b0);

        // Tick 7
        force dut.tick = 1'b1;
        @(posedge clk); #1;
        check_signal("end_of_word high at tick 7", end_of_word, 1'b1);
        check_signal("end_of_letter low at tick 7", end_of_letter, 1'b0);
        force dut.tick = 1'b0;
        release dut.tick;

        @(posedge clk); #1;
        check_signal("end_of_word low after pulse", end_of_word, 1'b0);

        @(posedge clk);
        $display("RESULTS: %0d PASSED, %0d FAILED", pass_count, fail_count);
        $finish;
    end
  
//   	initial begin
//       $dumpfile("dump.vcd"); 
//       $dumpvars;
//     end

endmodule