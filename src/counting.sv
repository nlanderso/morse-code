module counting
    (input logic clk, rst_n, btn_sync,
     output logic dah, end_of_ditdah, end_of_word, end_of_letter);

    logic [25:0] count; 
    logic tick;

    // 25 MHz clock and want the tick to go every 1 second
    always_ff @(posedge clk, negedge rst_n) begin
        if (~rst_n) begin
            count <= 26'd0;
            tick <= 1'b0;
        end 
        else begin
            if (count == 26'd24999999) begin
                count <= 26'd0;
                tick <= 1'b1;
            end 
            else begin
                count <= count + 26'd1;
                tick <= 1'b0;
            end
        end
    end

    logic [15:0] btn_count, space_count;
    logic btn_prev;

    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            btn_count <= 16'b0;
            space_count <= 16'b0;
            btn_prev <= 1'b0;
        end
        else begin
            btn_prev <= btn_sync;

            // Button is pressed
            if (btn_sync) begin
                // So the space count is reset to 0
                space_count <= 16'b0;

                // If button has just been pressed, reset count
                if (!btn_prev) btn_count <= 16'b0;
                // Increase count but stop at 15 so no overflow
                // 15 is enough since the threshold is 3 
                else if (tick && (btn_count < 16'd15)) btn_count <= btn_count + 16'd1;
            end
            else begin                
                // Button is released, so increase space count
                if (tick && (space_count < 16'd15)) space_count <= space_count + 16'd1;
            end
        end
    end

    always_comb begin
        // If button was pressed but now is released, this is the end of a dit/dah
        end_of_ditdah = (btn_prev && !btn_sync);

        // If button was held for longer than 3 seconds
        dah = (btn_count >= 16'd3);

        // End of letter past 3 seconds of space (end of letter is a 1 cycle pulse)
        end_of_letter = (space_count == 16'd3 && tick);
        // End of word past 7 seconds of space (end of space is a 1 cycle pulse)
        end_of_word = (space_count == 16'd7 && tick);
    end

endmodule