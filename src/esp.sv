//27 MHZ
/*module top_2 (
    input  logic clk,       // 27 MHz
    input  logic rst_n,
    input  logic rx,        // desde ESP-12F
    output logic tx,        // hacia ESP-12F
    output logic boot_ok,
    output logic SRCLK
);

    localparam int BAUD_DIV = 234;

    logic tx_start, tx_done, rx_ready;
    logic [7:0] tx_data, rx_data;

    // UART transmisor
    uart_tx_2 #(.BAUD_DIV(BAUD_DIV)) tx_mod (
        .clk(clk), .rst_n(rst_n),
        .start(tx_start), .data(tx_data),
        .tx(tx), .done(tx_done)
    );

    // UART receptor
    uart_rx_2 #(.BAUD_DIV(BAUD_DIV)) rx_mod (
        .clk(clk), .rst_n(rst_n),
        .rx(rx), .data(rx_data),
        .ready(rx_ready)
    );

    // FSM de arranque
    boot_uart_fsm fsm (
        .clk(clk), .rst_n(rst_n),
        .tx_start(tx_start), .tx_data(tx_data),
        .tx_done(tx_done),
        .rx_ready(rx_ready), .rx_data(rx_data),
        .boot_ok(boot_ok),
        .SRCLK(SRCLK)
    );

    // Buffer interno para el mensaje limpio
    logic [7:0] rx_msg [0:15];
    logic [3:0] rx_msg_index;
    logic       capturing;
    logic       rx_msg_ready;
    logic [7:0] last_rx_data;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            capturing     <= 0;
            rx_msg_index  <= 0;
            rx_msg_ready  <= 0;
            last_rx_data  <= 8'h00;
            for (int i = 0; i < 16; i++) rx_msg[i] <= 8'h00;
        end else begin
            rx_msg_ready <= 0;

            if (rx_ready) begin
                last_rx_data <= rx_data;

                if (rx_data == 8'h3A) begin // ':' detectado → inicia captura
                    capturing    <= 1;
                    rx_msg_index <= 0;
                    for (int i = 0; i < 16; i++) rx_msg[i] <= 8'h00;
                end else if (rx_data == 8'h0A) begin // '\n' → fin de mensaje
                    capturing    <= 0;
                    rx_msg_ready <= 1;
                end else if (capturing && rx_msg_index < 16) begin
                    rx_msg[rx_msg_index] <= rx_data;
                    rx_msg_index <= rx_msg_index + 1;
                end
            end
        end
    end
endmodule*/

module uart_tx_2 #(parameter int BAUD_DIV = 234) (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       start,
    input  logic [7:0] data,
    output logic       tx,
    output logic       done
);

    typedef enum logic [1:0] {IDLE, TRANSMIT} state_t;
    state_t state;

    logic [9:0] shift_reg;
    logic [3:0] bit_cnt;
    logic [15:0] baud_cnt;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            tx        <= 1;
            done      <= 0;
            baud_cnt  <= 0;
            bit_cnt   <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    tx   <= 1;
                    if (start) begin
                        shift_reg <= {1'b1, data, 1'b0}; // STOP + DATA + START
                        tx        <= 0;
                        state     <= TRANSMIT;
                        baud_cnt  <= 0;
                        bit_cnt   <= 0;
                    end
                end

                TRANSMIT: begin
                    if (baud_cnt == BAUD_DIV - 1) begin
                        baud_cnt  <= 0;
                        bit_cnt   <= bit_cnt + 1;
                        shift_reg <= shift_reg >> 1;
                        tx        <= shift_reg[1];
                        if (bit_cnt == 9) begin
                            state <= IDLE;
                            done  <= 1;
                            tx    <= 1;
                        end
                    end else begin
                        baud_cnt <= baud_cnt + 1;
                    end
                end
            endcase
        end
    end
endmodule

module uart_rx_2 #(parameter int BAUD_DIV = 234) (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       rx,
    output logic [7:0] data,
    output logic       ready
);

    typedef enum logic [2:0] {IDLE, START, DATA, STOP, DONE} state_t;
    state_t state;

    logic [7:0] shift_reg;
    logic [3:0] bit_cnt;
    logic [15:0] baud_cnt;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            ready     <= 0;
            baud_cnt  <= 0;
            bit_cnt   <= 0;
            shift_reg <= 8'h00;
            data      <= 8'h00;
        end else begin
            ready <= 0;
            case (state)
                IDLE: if (!rx) begin
                    state    <= START;
                    baud_cnt <= 0;
                end

                START: if (baud_cnt == (BAUD_DIV >> 1)) begin
                    if (!rx) begin
                        baud_cnt <= 0;
                        bit_cnt  <= 0;
                        state    <= DATA;
                    end else state <= IDLE;
                end else baud_cnt <= baud_cnt + 1;

                DATA: if (baud_cnt == BAUD_DIV - 1) begin
                    baud_cnt <= 0;
                    shift_reg[bit_cnt] <= rx;
                    if (bit_cnt == 7) state <= STOP;
                    else bit_cnt <= bit_cnt + 1;
                end else baud_cnt <= baud_cnt + 1;

                STOP: if (baud_cnt == BAUD_DIV - 1) begin
                    baud_cnt <= 0;
                    state    <= DONE;
                end else baud_cnt <= baud_cnt + 1;

                DONE: begin
                    data  <= shift_reg;
                    ready <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule

/*TODOS COMANDOS*/
module boot_uart_fsm (
    input  logic       clk,
    input  logic       rst_n,
    output logic       tx_start,
    output logic [7:0] tx_data,
    input  logic       tx_done,
    input  logic       rx_ready,
    input  logic [7:0] rx_data,
    output logic       boot_ok,
    output logic       SRCLK,

    output logic [2:0] fsm_state,
    output logic [5:0] fsm_tx_index,
    output logic [7:0] fsm_tx_data,
    output logic       fsm_tx_start,

    output logic [7:0] rx_debug0,  rx_debug1,  rx_debug2,  rx_debug3,
                       rx_debug4,  rx_debug5,  rx_debug6,  rx_debug7,
                       rx_debug8,  rx_debug9,  rx_debug10, rx_debug11,
                       rx_debug12, rx_debug13, rx_debug14, rx_debug15,
                       rx_debug16, rx_debug17, rx_debug18, rx_debug19,
                       rx_debug20, rx_debug21, rx_debug22, rx_debug23,
                       rx_debug24, rx_debug25, rx_debug26, rx_debug27,
                       rx_debug28, rx_debug29, rx_debug30, rx_debug31
);

    typedef enum logic [2:0] { IDLE, SEND, WAIT_TX, WAIT_RX, CHECK, DONE } state_t;
    state_t state;

    logic [7:0] cmd_mem [0:63];
    logic [5:0] cmd_ptr;
    logic [1:0] cmd_index;
    logic [5:0] cmd_end;

    logic [7:0] rx_buffer [0:31];
    logic [5:0] rx_index;
    logic       ok_received;

    logic [3:0] div;
    logic       pulsito;
    logic       srclk_en;

    assign SRCLK         = srclk_en ? ~pulsito : 1'b0;
    assign fsm_state     = state;
    assign fsm_tx_index  = cmd_ptr;
    assign fsm_tx_data   = tx_data;
    assign fsm_tx_start  = tx_start;

    // Visualización del buffer UART
    assign rx_debug0  = rx_buffer[0];   assign rx_debug1  = rx_buffer[1];
    assign rx_debug2  = rx_buffer[2];   assign rx_debug3  = rx_buffer[3];
    assign rx_debug4  = rx_buffer[4];   assign rx_debug5  = rx_buffer[5];
    assign rx_debug6  = rx_buffer[6];   assign rx_debug7  = rx_buffer[7];
    assign rx_debug8  = rx_buffer[8];   assign rx_debug9  = rx_buffer[9];
    assign rx_debug10 = rx_buffer[10];  assign rx_debug11 = rx_buffer[11];
    assign rx_debug12 = rx_buffer[12];  assign rx_debug13 = rx_buffer[13];
    assign rx_debug14 = rx_buffer[14];  assign rx_debug15 = rx_buffer[15];
    assign rx_debug16 = rx_buffer[16];  assign rx_debug17 = rx_buffer[17];
    assign rx_debug18 = rx_buffer[18];  assign rx_debug19 = rx_buffer[19];
    assign rx_debug20 = rx_buffer[20];  assign rx_debug21 = rx_buffer[21];
    assign rx_debug22 = rx_buffer[22];  assign rx_debug23 = rx_buffer[23];
    assign rx_debug24 = rx_buffer[24];  assign rx_debug25 = rx_buffer[25];
    assign rx_debug26 = rx_buffer[26];  assign rx_debug27 = rx_buffer[27];
    assign rx_debug28 = rx_buffer[28];  assign rx_debug29 = rx_buffer[29];
    assign rx_debug30 = rx_buffer[30];  assign rx_debug31 = rx_buffer[31];

    // Pulso lento
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            div     <= 0;
            pulsito <= 0;
        end else begin
            div <= (div == 4'd13) ? 0 : div + 1;
            if (div == 4'd13) pulsito <= ~pulsito;
        end
    end

    // Comandos AT en hexadecimal
    always_comb begin
        // Comando 0: AT\r\n
        cmd_mem[0] = 8'h41; cmd_mem[1] = 8'h54; cmd_mem[2] = 8'h0D; cmd_mem[3] = 8'h0A;

        // Comando 1: AT+CWMODE=3\r\n
        cmd_mem[4]  = 8'h41; cmd_mem[5]  = 8'h54; cmd_mem[6]  = 8'h2B; cmd_mem[7]  = 8'h43;
        cmd_mem[8]  = 8'h57; cmd_mem[9]  = 8'h4D; cmd_mem[10] = 8'h4F; cmd_mem[11] = 8'h44;
        cmd_mem[12] = 8'h45; cmd_mem[13] = 8'h3D; cmd_mem[14] = 8'h33; cmd_mem[15] = 8'h0D;
        cmd_mem[16] = 8'h0A;

        // Comando 2: AT+CIPMUX=1\r\n
        cmd_mem[17] = 8'h41; cmd_mem[18] = 8'h54; cmd_mem[19] = 8'h2B; cmd_mem[20] = 8'h43;
        cmd_mem[21] = 8'h49; cmd_mem[22] = 8'h50; cmd_mem[23] = 8'h4D; cmd_mem[24] = 8'h55;
        cmd_mem[25] = 8'h58; cmd_mem[26] = 8'h3D; cmd_mem[27] = 8'h31; cmd_mem[28] = 8'h0D;
        cmd_mem[29] = 8'h0A;

        // Comando 3: AT+CIPSERVER=1,80\r\n
        cmd_mem[30] = 8'h41; cmd_mem[31] = 8'h54; cmd_mem[32] = 8'h2B; cmd_mem[33] = 8'h43;
        cmd_mem[34] = 8'h49; cmd_mem[35] = 8'h50; cmd_mem[36] = 8'h53; cmd_mem[37] = 8'h45;
        cmd_mem[38] = 8'h52; cmd_mem[39] = 8'h56; cmd_mem[40] = 8'h45; cmd_mem[41] = 8'h52;
        cmd_mem[42] = 8'h3D; cmd_mem[43] = 8'h31; cmd_mem[44] = 8'h2C; cmd_mem[45] = 8'h38;
        cmd_mem[46] = 8'h30; cmd_mem[47] = 8'h0D; cmd_mem[48] = 8'h0A;
    end

    always_comb begin
        case (cmd_index)
            2'd0: cmd_end = 4;
            2'd1: cmd_end = 17;
            2'd2: cmd_end = 30;
            2'd3: cmd_end = 49;
            default: cmd_end = 0;
        endcase
    end

    // FSM principal
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            cmd_ptr     <= 0;
            cmd_index   <= 0;
            tx_start    <= 0;
            boot_ok     <= 0;
            srclk_en    <= 0;
            rx_index    <= 0;
            ok_received <= 0;
        end else begin
            case (state)

                // Estado inicial: prepara el comando
                IDLE: begin
                    cmd_ptr     <= (cmd_index == 0) ? 0 :
                                   (cmd_index == 1) ? 4 :
                                   (cmd_index == 2) ? 17 : 30;
                    rx_index    <= 0;
                    ok_received <= 0;
                    state       <= SEND;
                end

                // Envío de bytes del comando actual
                SEND: begin
                    if (cmd_ptr < cmd_end) begin
                        tx_data  <= cmd_mem[cmd_ptr];
                        tx_start <= 1;
                        state    <= WAIT_TX;
                    end else begin
                        tx_start <= 0;
                        tx_data  <= 8'h00;
                        state    <= WAIT_RX;
                    end
                end

                // Espera a que se complete la transmisión UART
                WAIT_TX: begin
                    tx_start <= 0;
                    if (tx_done) begin
                        cmd_ptr <= cmd_ptr + 1;
                        state   <= SEND;
                    end
                end

                // Recepción UART y detección en tiempo real de "OK\r\n"
                WAIT_RX: begin
                    if (rx_ready) begin
                        rx_buffer[rx_index] <= rx_data;

                        if (rx_index >= 3 &&
                            rx_buffer[rx_index-3] == 8'h4F && // 'O'
                            rx_buffer[rx_index-2] == 8'h4B && // 'K'
                            rx_buffer[rx_index-1] == 8'h0D && // '\r'
                            rx_data               == 8'h0A) begin // '\n'
                            state <= CHECK;
                        end else if (rx_index < 31) begin
                            rx_index <= rx_index + 1;
                        end else begin
                            state <= CHECK;
                        end
                    end
                end

                // Validación de respuesta: busca "OK\r\n" en todo el buffer
                CHECK: begin
                    logic found_ok;
                    found_ok = 0;
                    for (int i = 0; i <= 28; i++) begin
                        if (rx_buffer[i]   == 8'h4F && // 'O'
                            rx_buffer[i+1] == 8'h4B && // 'K'
                            rx_buffer[i+2] == 8'h0D && // '\r'
                            rx_buffer[i+3] == 8'h0A) begin // '\n'
                            found_ok = 1;
                        end
                    end
                    ok_received <= found_ok;

                    if (found_ok) begin
                        if (cmd_index < 3) begin
                            cmd_index <= cmd_index + 1;
                            state     <= IDLE;
                        end else begin
                            boot_ok  <= 1;
                            srclk_en <= 1;
                            state    <= DONE;
                        end
                    end else begin
                        state <= DONE;
                    end
                end

                // Estado final: FSM detenida
                DONE: begin
                    tx_start <= 0;
                    srclk_en <= srclk_en;
                    // Puedes inspeccionar rx_buffer y boot_ok aquí
                end

            endcase
        end
    end
endmodule



//Todos los comandos fail
/*module top (
    input  logic clk,       // 27 MHz
    input  logic rst_n,
    input  logic rx,        // desde ESP-12F
    output logic tx,        // hacia ESP-12F
    output logic boot_ok
);

    localparam int BAUD_DIV = 234;

    logic tx_start, tx_done, rx_ready;
    logic [7:0] tx_data, rx_data;

    uart_tx #(.BAUD_DIV(BAUD_DIV)) tx_mod (
        .clk(clk), .rst_n(rst_n),
        .start(tx_start), .data(tx_data),
        .tx(tx), .done(tx_done)
    );

    uart_rx #(.BAUD_DIV(BAUD_DIV)) rx_mod (
        .clk(clk), .rst_n(rst_n),
        .rx(rx), .data(rx_data),
        .ready(rx_ready)
    );

    boot_uart_fsm fsm (
        .clk(clk), .rst_n(rst_n),
        .tx_start(tx_start), .tx_data(tx_data),
        .tx_done(tx_done),
        .rx_ready(rx_ready), .rx_data(rx_data),
        .boot_ok(boot_ok)
    );
endmodule

module uart_tx #(parameter int BAUD_DIV = 234) (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       start,
    input  logic [7:0] data,
    output logic       tx,
    output logic       done
);

    typedef enum logic [1:0] {IDLE, TRANSMIT} state_t;
    state_t state;

    logic [9:0] shift_reg;
    logic [3:0] bit_cnt;
    logic [15:0] baud_cnt;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            tx        <= 1;
            done      <= 0;
            baud_cnt  <= 0;
            bit_cnt   <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    tx   <= 1;
                    if (start) begin
                        shift_reg <= {1'b1, data, 1'b0};
                        tx        <= 0;
                        state     <= TRANSMIT;
                        baud_cnt  <= 0;
                        bit_cnt   <= 0;
                    end
                end

                TRANSMIT: begin
                    if (baud_cnt == BAUD_DIV - 1) begin
                        baud_cnt  <= 0;
                        bit_cnt   <= bit_cnt + 1;
                        shift_reg <= shift_reg >> 1;
                        tx        <= shift_reg[1];
                        if (bit_cnt == 9) begin
                            state <= IDLE;
                            done  <= 1;
                            tx    <= 1;
                        end
                    end else begin
                        baud_cnt <= baud_cnt + 1;
                    end
                end
            endcase
        end
    end
endmodule

module uart_rx #(parameter int BAUD_DIV = 234) (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       rx,
    output logic [7:0] data,
    output logic       ready
);

    typedef enum logic [2:0] {IDLE, START, DATA, STOP, DONE} state_t;
    state_t state;

    logic [7:0] shift_reg;
    logic [3:0] bit_cnt;
    logic [15:0] baud_cnt;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            ready     <= 0;
            baud_cnt  <= 0;
            bit_cnt   <= 0;
            shift_reg <= 8'h00;
            data      <= 8'h00;
        end else begin
            ready <= 0;
            case (state)
                IDLE: if (!rx) begin
                    state    <= START;
                    baud_cnt <= 0;
                end

                START: if (baud_cnt == (BAUD_DIV >> 1)) begin
                    if (!rx) begin
                        baud_cnt <= 0;
                        bit_cnt  <= 0;
                        state    <= DATA;
                    end else state <= IDLE;
                end else baud_cnt <= baud_cnt + 1;

                DATA: if (baud_cnt == BAUD_DIV - 1) begin
                    baud_cnt <= 0;
                    shift_reg[bit_cnt] <= rx;
                    if (bit_cnt == 7) state <= STOP;
                    else bit_cnt <= bit_cnt + 1;
                end else baud_cnt <= baud_cnt + 1;

                STOP: if (baud_cnt == BAUD_DIV - 1) begin
                    baud_cnt <= 0;
                    state    <= DONE;
                end else baud_cnt <= baud_cnt + 1;

                DONE: begin
                    data  <= shift_reg;
                    ready <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule

module boot_uart_fsm (
    input  logic       clk,
    input  logic       rst_n,
    output logic       tx_start,
    output logic [7:0] tx_data,
    input  logic       tx_done,
    input  logic       rx_ready,
    input  logic [7:0] rx_data,
    output logic       boot_ok
);

    typedef enum logic [2:0] {
        IDLE, SEND, WAIT_TX, WAIT_RX, CHECK, DONE
    } state_t;
    state_t state;

    logic [7:0] cmd_mem [0:63];
    logic [7:0] rx_buf [0:3];
    logic [5:0] tx_index;
    logic [2:0] cmd_phase;
    logic [1:0] rx_index;
    logic       ok_flag;

    // Comandos AT predefinidos
    always_comb begin
        // Comando 0: "AT\r\n"
        cmd_mem[0] = "A"; cmd_mem[1] = "T"; cmd_mem[2] = "\r"; cmd_mem[3] = "\n";

        // Comando 1: "AT+CWMODE=3\r\n"
        cmd_mem[4]  = "A"; cmd_mem[5]  = "T"; cmd_mem[6]  = "+"; cmd_mem[7]  = "C";
        cmd_mem[8]  = "W"; cmd_mem[9]  = "M"; cmd_mem[10] = "O"; cmd_mem[11] = "D";
        cmd_mem[12] = "E"; cmd_mem[13] = "="; cmd_mem[14] = "3"; cmd_mem[15] = "\r";
        cmd_mem[16] = "\n";

        // Comando 2: "AT+CIPMUX=1\r\n"
        cmd_mem[17] = "A"; cmd_mem[18] = "T"; cmd_mem[19] = "+"; cmd_mem[20] = "C";
        cmd_mem[21] = "I"; cmd_mem[22] = "P"; cmd_mem[23] = "M"; cmd_mem[24] = "U";
        cmd_mem[25] = "X"; cmd_mem[26] = "="; cmd_mem[27] = "1"; cmd_mem[28] = "\r";
        cmd_mem[29] = "\n";

        // Comando 3: "AT+CIPSERVER=1,80\r\n"
        cmd_mem[30] = "A"; cmd_mem[31] = "T"; cmd_mem[32] = "+"; cmd_mem[33] = "C";
        cmd_mem[34] = "I"; cmd_mem[35] = "P"; cmd_mem[36] = "S"; cmd_mem[37] = "E";
        cmd_mem[38] = "R"; cmd_mem[39] = "V"; cmd_mem[40] = "E"; cmd_mem[41] = "R";
        cmd_mem[42] = "="; cmd_mem[43] = "1"; cmd_mem[44] = ","; cmd_mem[45] = "8";
        cmd_mem[46] = "0"; cmd_mem[47] = "\r"; cmd_mem[48] = "\n";
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            tx_start  <= 0;
            tx_data   <= 8'h00;
            tx_index  <= 0;
            cmd_phase <= 0;
            rx_index  <= 0;
            ok_flag   <= 0;
            boot_ok   <= 0;
        end else begin
            case (state)
                IDLE: begin
                    tx_index  <= cmd_phase * 16;
                    tx_start  <= 1;
                    tx_data   <= cmd_mem[cmd_phase * 16];
                    state     <= SEND;
                end

                SEND: begin
                    tx_start <= 0;
                    if (tx_done) begin
                        tx_index <= tx_index + 1;
                        if (cmd_mem[tx_index + 1] != 8'h00) begin
                            tx_start <= 1;
                            tx_data  <= cmd_mem[tx_index + 1];
                        end else begin
                            state <= WAIT_RX;
                            rx_index <= 0;
                        end
                    end
                end

                WAIT_RX: begin
                    if (rx_ready) begin
                        rx_buf[rx_index] <= rx_data;
                        rx_index <= rx_index + 1;
                        if (rx_index == 3) state <= CHECK;
                    end
                end

                CHECK: begin
                    if (rx_buf[0] == "O" && rx_buf[1] == "K") begin
                        cmd_phase <= cmd_phase + 1;
                        if (cmd_phase == 3) state <= DONE;
                        else state <= IDLE;
                    end else begin
                        state <= IDLE; // Reintenta si no recibe OK
                    end
                end

                DONE: begin
                    boot_ok <= 1;
                end
            endcase
        end
    end
endmodule*/
