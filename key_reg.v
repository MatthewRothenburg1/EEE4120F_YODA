module key_reg (
  input wire [7:0] din,
  input wire reset,
  input wire dclk,
  input wire kset,
  input wire [1:0] sl,
  output reg [2:0]num_keys,
  output reg [31:0] keys
);
 
  counter c1(.dclk(dclk), .reset(reset), .counter(sl));

  //On dclk run
  always@(posedge dclk) begin
    //Reset keys 
    if (reset) begin
      keys <= 32'b0;
      num_keys <= 2'b0;
    end

    //Store into register 
    if (kset == 0) begin
      if (sl ==0) begin
        keys[7:0] <= din;
        num_keys <= 1;
      end
      
      if (sl ==1) begin
        keys[15:8] <= din;
        num_keys <= 2;
      end
      
      if (sl ==2) begin
        keys[23:16] <= din;
        num_keys <= 3;
      end
      
      if (sl ==3) begin
        keys[31:24] <= din;
        num_keys <= 4;
      end
  end
  
end
endmodule