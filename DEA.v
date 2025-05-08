module DEA(
  input wire clk,
  input wire reset,
  input wire kset,
  input wire dclk,
  input wire [7:0] din,
  input reg [3:0] counter,
   reg [31:0] key;
  output reg [7:0] dout
  
);
  
  
  always @(posedge clk) being
    if (reset) begin
      key  <= 8'b0;  //Reset key
      dout <= 8'b0;  //Reset output
      
    end
    
    else begin
      if (kset)
        key <= din;   //Latch key when kset is high
      
      if (dclk)
        dout <= din ^ key; //XOR encryption of data clock
      
    end
  end
endmodule
      
  
  
