module translation_fsm
    (input logic rst_n, clk, end_of_letter, end_of_ditdah, dah,
     output logic [6:0] letter);

    enum logic [4:0] {START, A, B, C, D, E, F, G, 
                             H, I, J, K, L, M, N, 
                             O, P, Q, R, S, T, U, 
                             V, W, X, Y, Z} state, next_state;

    // Output logic 
    always_comb begin
        case (state)
            START: letter = 7'b0;
            A: letter = 7'b1110111;
            B: letter = 7'b0011111;
            C: letter = 7'b0001101;
            D: letter = 7'b0111101;
            E: letter = 7'b1001111;
            F: letter = 7'b1000111;
            G: letter = 7'b1011110;
            H: letter = 7'b0010111;
            I: letter = 7'b0110000;
            J: letter = 7'b0111000; 
            K: letter = 7'b1010111;
            L: letter = 7'b0001110;
            M: letter = 7'b1010101;
            N: letter = 7'b0010101;
            O: letter = 7'b0011101;
            P: letter = 7'b1100111;
            Q: letter = 7'b1110011;
            R: letter = 7'b0000101;
            S: letter = 7'b1011011;
            T: letter = 7'b0001111;
            U: letter = 7'b0011100;
            V: letter = 7'b0101010;
            W: letter = 7'b0101011;
            X: letter = 7'b0110110;
            Y: letter = 7'b0111011;
            Z: letter = 7'b1101101;
            default: letter = 7'b0;
        endcase
    end

    // Next state logic
    always_comb begin
        // Maybe change order of if elseif

        if (end_of_letter) next_state = START;
        else if (!end_of_ditdah) next_state = state;
        else begin
            case (state)
                START: begin
                    if (dah) next_state = T;
                    else next_state = E;
                end
                T: begin
                    if (dah) next_state = M;
                    else next_state = N;
                end
                M: begin
                    if (dah) next_state = O;
                    else next_state = G;
                end
                O: next_state = O;

                G: begin
                    if (dah) next_state = Q;
                    else next_state = Z;
                end
                Q: next_state = Q;
                Z: next_state = Z;

                N: begin
                    if (dah) next_state = K;
                    else next_state = D;
                end
                K: begin
                    if (dah) next_state = Y;
                    else next_state = C;
                end
                Y: next_state = Y;
                C: next_state = C;

                D: begin
                    if (dah) next_state = X;
                    else next_state = B;
                end
                X: next_state = X;
                B: next_state = B;

                E: begin
                    if (dah) next_state = A;
                    else next_state = I;
                end
                A: begin
                    if (dah) next_state = W;
                    else next_state = R;
                end
                W: begin
                    if (dah) next_state = J;
                    else next_state = P;
                end
                J: next_state = J;
                P: next_state = P;
                R: begin
                    if (dah) next_state = R;
                    else next_state = L;
                end
                L: next_state = L;

                I: begin
                    if (dah) next_state = U;
                    else next_state = S;
                end
                U: begin
                    if (dah) next_state = U;
                    else next_state = F;
                end
                F: next_state = F;
                S: begin
                    if (dah) next_state = V;
                    else next_state = H;
                end
                V: next_state = V;
                H: next_state = H;

                default: next_state = state;
            endcase
        end
    end
 
    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) state <= START;
        else state <= next_state;
    end

endmodule

module translation
    (input logic rst_n, clk, end_of_letter, end_of_word,
     input logic [6:0] letter,
     output logic [6:0] letter_1, letter_2);

    logic [6:0] letter_1_in, letter_2_in;

    always_ff @(posedge clk, negedge rst_n) begin
        if (!rst_n) begin
            letter_1 <= 7'b0;
            letter_2 <= 7'b0;
        end
        else begin
            if (end_of_word) begin
                letter_1 <= 7'b0;
                letter_2 <= letter_1;
            end
            else if (end_of_letter) begin
                letter_1 <= letter;
                letter_2 <= letter_1;
            end
        end
    end
    
endmodule