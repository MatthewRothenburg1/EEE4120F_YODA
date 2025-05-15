module key_reg (
  input wire [7:0] din,

  input wire reset,
  input wire dclk,
  input wire kset,
  
  input wire [1:0] sl,
  
  output reg [7:0] dout
);
  rese
  reg [31:0] keys;
  counter c0(.dclk(dclk), .reset(reset), .counter(sl));

  always@(posedge dclk) begin 
    if (reset) begin
      keys <= 32'b0;
    end
    //Store into register 
    if (kset == 0) begin
      if (sl ==0) begin
        keys[7:0] <= din
      end
      
      if (sl ==1) begin
        keys[15:8] <= din
      end
      
      if (sl ==2) begin
        keys[23:16] <= din
      end
      
      if (sl ==3) begin
        keys[31:24] <= din
      end
  end
  //Output the key 
  else begin
    if (sl ==0) begin
      dout <= keys[7:0];
    end  
    if (sl ==1) begin
      dout <= keys[15:8];
    end
    if (sl ==2) begin
      dout <= keys[23:16];
    end
    
    if (sl ==3) begin
      dout <= keys[31:24];
    end
  end
end
endmodule