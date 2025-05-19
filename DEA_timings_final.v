
`timescale 1ns/1ps  // Explicitly define time units (1ns) and precision (1ps)

module UI_tb;
    // Registers to hold the key and message
    integer file;
    integer i;
    integer message_length;
    
    reg [7:0] key_length;
    reg [7:0] c;
    reg [7:0] key [4:0];
    reg [7:0] message [10000000:0];
    reg [7:0] encrypted_message [10000000:0];

    // DEA module interface
    reg reset;
    reg dclk;          // Clock signal (10ns period = 5ns high, 5ns low)
    reg [7:0] din;
    wire [7:0] dout;
    reg kset;

    // Timing measurement
    integer start_time, end_time;
    integer load_time, encrypt_time, write_time;
    integer load_cycles, encrypt_cycles, write_cycles;
    
    // Clock parameters
    parameter CLK_PERIOD = 2;  // 2ns clock period
    parameter HALF_PERIOD = 1;  // 1ns half-period

    // Instantiate the DEA module
    DEA dut (
        .kset(kset),
        .reset(reset),
        .dclk(dclk),
        .din(din),
        .dout(dout)
    );
    
    initial begin
        // Initialize clock
        dclk = 0;
        
        // =============================================
        // Phase 1: File Loading (Non-clock-synchronous)
        // =============================================
        start_time = $time;
        
        file = $fopen("test_input.txt", "r");
        if (file == 0) begin
            $display("Failed to open file");
            $finish;
        end 
        
        // Read key
        key_length = 0;
        
        key[0] = 8'hAA;
        key[1] = 8'hAA;
        key[2] = 8'hAA;
        key[3] = 8'hAA;

        // Read message
        message_length = 0;
        while (message_length <100000)begin
             c = $fgetc(file);
            message[message_length] = c[7:0];
            message_length = message_length + 1;
            c = $fgetc(file);
            $display(message_length);
    end
        
        $fclose(file);
        end_time = $time;
        load_time = end_time - start_time;
        load_cycles = load_time / CLK_PERIOD;
        $display("[LOAD] Completed in %0d ns (%0d clock cycles)", load_time, load_cycles);
        
        // =============================================
        // Phase 2: Encryption (Clock-synchronous)
        // =============================================
        start_time = $time;
        
        // Reset sequence
        #10;
        kset = 0;
        din = 8'h00;
        reset = 1;
        #HALF_PERIOD; dclk = 1; #HALF_PERIOD; dclk = 0;
        reset = 0;
        
        // Load key
        kset = 1;
        for (i = 0; i < key_length; i = i + 1) begin
            din = key[i];
            #HALF_PERIOD; dclk = 1; #HALF_PERIOD; dclk = 0;
        end
        
        // Encrypt message
        kset = 0;
        for (i = 0; i < message_length; i = i + 1) begin
            din = message[i];
            #HALF_PERIOD; dclk = 1; #HALF_PERIOD; dclk = 0;
            encrypted_message[i] = dout;
        end
        
        end_time = $time;
        encrypt_time = end_time - start_time;
        encrypt_cycles = encrypt_time / CLK_PERIOD;
        $display("[ENCRYPT] Completed in %0d ns (%0d clock cycles)", encrypt_time, encrypt_cycles);
        
        // =============================================
        // Phase 3: Output Display
        // =============================================
        start_time = $time;
        
        for (i = 0; i < message_length; i = i + 1) begin
            $display("%h", encrypted_message[i]);
        end
        
        end_time = $time;
        write_time = end_time - start_time;
        write_cycles = write_time / CLK_PERIOD;
        $display("[WRITE] Completed in %0d ns (%0d clock cycles)", write_time, write_cycles);
        
        // =============================================
        // Final Report
        // =============================================
        $display("\n=== TIMING SUMMARY ===");
        $display("Phase            Time (ns)   Clock Cycles");
        $display("----------------------------------------");
        $display("File Load:       %-8d    %-8d", load_time, load_cycles);
        $display("Encryption:      %-8d    %-8d", encrypt_time, encrypt_cycles);
        $display("Output Display:  %-8d    %-8d", write_time, write_cycles);
        $display("----------------------------------------");
        $display("TOTAL:           %-8d    %-8d", 
                load_time + encrypt_time + write_time,
                load_cycles + encrypt_cycles + write_cycles);
        
        $finish;
    end
endmodule