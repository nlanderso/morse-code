module translation_fsm
    (input logic rst_n, clk, end_of_letter, end_of_ditdah, dah,
     output logic [6:0] letter);

    typedef enum logic [4:0] {START, A, B, C, D, E, F, G, 
                             H, I, J, K, L, M, N, 
                             O, P, Q, R, S, T, U, 
                             V, W, X, Y, Z} state_t;
                             
    state_t state, next_state;

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
                START: next_state = (dah) ? state_t'(T) : state_t'(E);
                T: next_state = (dah) ? state_t'(M) : state_t'(N);
                M: next_state = (dah) ? state_t'(O) : state_t'(G);
                O: next_state = state_t'(O);

                G: next_state = (dah) ? state_t'(Q) : state_t'(Z);
                Q: next_state = state_t'(Q);
                Z: next_state = state_t'(Z);

                N: next_state = (dah) ? state_t'(K) : state_t'(D);
                K: next_state = (dah) ? state_t'(Y) : state_t'(C);
                Y: next_state = state_t'(Y);
                C: next_state = state_t'(C);

                D: next_state = (dah) ? state_t'(X) : state_t'(B);
                X: next_state = state_t'(X);
                B: next_state = state_t'(B);

                E: next_state = (dah) ? state_t'(A) : state_t'(I);
                A: next_state = (dah) ? state_t'(W) : state_t'(R);
                W: next_state = (dah) ? state_t'(J) : state_t'(P);
                J: next_state = state_t'(J);
                P: next_state = state_t'(P);
                R: next_state = (dah) ? state_t'(R) : state_t'(L);
                L: next_state = state_t'(L);

                I: next_state = (dah) ? state_t'(U) : state_t'(S);
                U: next_state = (dah) ? state_t'(U) : state_t'(F);
                F: next_state = state_t'(F);
                S: next_state = (dah) ? state_t'(V) : state_t'(H);
                V: next_state = state_t'(V);
                H: next_state = state_t'(H);

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