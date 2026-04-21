module ChipInterface
    (output logic AA, AB, AC, AD, AE, AF, AG, CAT,
     output logic [7:0] led,
     input logic clock, reset_n, btn_up);

    logic [25:0] count; 

    // 25 MHz clock and want the LED to blink every 1 second (on for 0.5, off for 0.5)
    always_ff @(posedge clock, negedge reset_n) begin
        if (~reset_n) begin
            count <= 26'd0;
            led <= 8'b0;
        end 
        else begin
            if (count == 26'd12500000) begin
                count <= 26'd0;
                led[0] <= ~led[0];
            end 
            else begin
                count <= count + 26'd1;
            end
        end
    end

    logic [24:0] display_counter;
    logic [6:0] display_letter, letter_1, letter_2;

    always_ff @(posedge clock, negedge reset_n) begin
        if (!reset_n) begin
            display_counter <= 25'd0;
            CAT <= 0;
        end else begin
            if (display_counter >= 25'd250000) begin
                display_counter <= 25'd0;
                CAT <= ~CAT; 
            end else begin
                display_counter <= display_counter + 25'd1;
            end
        end
    end

    assign {AA, AB, AC, AD, AE, AF, AG} = (CAT) ? letter_2 : letter_1;

    logic btn_sync, btn_temp, dah, end_of_ditdah, end_of_word, end_of_letter;

    // 2FF synchronizer
    always_ff @(posedge clock, negedge reset_n) begin
        if (!reset_n) begin
            btn_temp <= 1'b0;
            btn_sync <= 1'b0;
        end
        else begin
            btn_temp <= btn_up;
            btn_sync <= btn_temp;
        end
    end

    counting counts (.clk(clock), .rst_n(reset_n), .*);

    logic [6:0] translated_letter;
    translation_fsm morse (.rst_n(reset_n), .clk(clock), .letter(translated_letter), .*);
    translation translate (.rst_n(reset_n), .clk(clock), .letter(translated_letter), .*);

endmodule 