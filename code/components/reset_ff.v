
// reset_ff.v - 8-bit resettable D flip-flop
// author - Adityaa Mehra

module reset_ff #(parameter WIDTH = 8) (
    input       clk, rst,
    input enable,
    input       [WIDTH-1:0] d,
    output reg  [WIDTH-1:0] q
);

always @(posedge clk or posedge rst) begin
    if (rst) q <= 0;
    else if (enable) q <= d;
end

endmodule

