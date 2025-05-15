module newDea(
  input wire clk,
  input wire reset,
  input wire kset,
  input wire dclk,
  input wire [7:0] din,
  output reg [7:0] dout
);
  
  reg [31:0] key;
  
  always @(posedge clk) begin
    if (reset) begin
      key <= 32'b0;  // Reset key
      dout <= 8'b0;  // Reset output
    end else begin
      if (kset)
        key <= {key[23:0], din};   // Latch key when kset is high
      
      if (dclk)
        dout <= din ^ key[7:0]; // XOR encryption of data clock
    end
  end