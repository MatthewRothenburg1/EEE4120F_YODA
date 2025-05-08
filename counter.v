module counter(
  input wire clk,
  input wire reset,
  input wire en
);
  
  reg [1:0] counter;
  
  always@(posedge clk) begin
    if (reset) begin
    counter <= 2'b0;
    end
    
    if (en) begin
    counter <= counter + 1;
    end
    
    endmodule