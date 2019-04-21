module linear_rng (clock, initialSeed, random);

input clock;
input [31:0] initialSeed;

output reg [31:0] random;

initial begin

	random = 587;

end

always @(posedge clock) begin

	random = (8121 * random + 28411) % 1024;

end

endmodule 