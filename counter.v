module counter(
  input wire dclk,
  input wire kset,
  input wire reset,
  output reg [1:0] counter
);
  
  always@(posedge dclk) begin
    if (reset) begin
    counter <= 2'b0;
    end
    
    else if (!kset)
      counter <= counter + 1;
    end
  end
endmodule