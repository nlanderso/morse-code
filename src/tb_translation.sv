module tb_translation();
    logic rst_n;
    logic clk;
    logic end_of_letter;
    logic end_of_ditdah;
    logic dah;
    logic end_of_word;

    logic [6:0] letter;
    logic [6:0] letter_1;
    logic [6:0] letter_2;

    int pass_count = 0;
    int fail_count = 0;

    translation_fsm fsm(.*);

    translation trans(.*);

    always #5 clk = ~clk;

    // end_of_ditdah high for one cycle
    // if dah is asserted, it was a dah, otherwise was a dit
    task send_element(input logic is_dah);
        @(posedge clk);
        dah = is_dah;
        end_of_ditdah = 1;
        @(posedge clk);
        end_of_ditdah = 0;
        repeat(2) @(posedge clk);
    endtask

    task send_eol();
        @(posedge clk);
        end_of_letter = 1;
        @(posedge clk);
        end_of_letter = 0;
        repeat(2) @(posedge clk);
    endtask

    // Check letter_1 after each letter is sent
    task check_letter(input string name, input logic [6:0] expected);
        @(posedge clk);
        if (letter_1 === expected) begin
            $display("PASS: '%s' - letter_1 = 7'b%b", name, letter_1);
            pass_count++;
        end else begin
            $display("FAIL: '%s' - Expected 7'b%b, Got 7'b%b", name, expected, letter_1);
            fail_count++;
        end
    endtask

    initial begin
        clk = 0;
        rst_n = 0; 
        end_of_letter = 0;
        end_of_ditdah = 0;
        dah = 0;
        end_of_word = 0;

        @(posedge clk);
        @(posedge clk);
        rst_n <= 1'b1;  
        @(posedge clk);

        // 'A' (.-)
        send_element(0);
        send_element(1);
        send_eol();
        check_letter("A", 7'b1110111);

        // 'B' (-..)
        send_element(1);
        send_element(0);
        send_element(0);
        send_element(0);
        send_eol();
        check_letter("B", 7'b0011111);

        // 'S' (...)
        send_element(0);
        send_element(0);
        send_element(0);
        send_eol();
        check_letter("S", 7'b1011011);

        // 'O' (---)
        send_element(1);
        send_element(1);
        send_element(1);
        send_eol();
        check_letter("O", 7'b0011101);

        // 'E' (.)
        send_element(0);
        send_eol();
        check_letter("E", 7'b1001111);

        // 'T' (-)
        send_element(1);
        send_eol();
        check_letter("T", 7'b0001111);
      
      	// 'Y' (-.--)
        send_element(1);
      	send_element(0);
      	send_element(1);
      	send_element(1);
        send_eol();
      	check_letter("Y", 7'b0111011);

        repeat(5) @(posedge clk);
        $display("Results: %0d PASSED, %0d FAILED", pass_count, fail_count);
        $finish;
    end

endmodule