module key_reg (
  input wire [7:0] din,
  input wire clk,
  input wire reset,
  input wire en,
  input reg [1:0] in_sel,
  input reg [1:0] out_sel
);
  
  reg [31:0] keys;
  
  always@(posedge clk) begin 
    if (reset) begin
      keys <= 32'b0;
    end
    
    if (en) begin
      if (in_sel ==0) begin
        keys[7:0] <= din
      end
      
      if (in_sel ==1) begin
        keys[15:8] <= din
      end
      
      if (in_sel ==2) begin
        keys[23:16] <= din
      end
      
      if (in_sel ==3) begin
        keys[31:24] <= din
      end
      
      