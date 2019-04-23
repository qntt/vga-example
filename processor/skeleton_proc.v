/**
 * NOTE: you should not need to change this file! This file will be swapped out for a grading
 * "skeleton" for testing. We will also remove your imem and dmem file.
 *
 * NOTE: skeleton should be your top-level module!
 *
 * This skeleton file serves as a wrapper around the processor to provide certain control signals
 * and interfaces to memory elements. This structure allows for easier testing, as it is easier to
 * inspect which signals the processor tries to assert when.
 */

module skeleton_proc(clock, reset, stage, head1Position, head1);
    input clock, reset;
	 
	 wire [487 : 0] snake_data;
	 output [31:0] stage;
	 assign stage = snake_data[359:328];
	 
	 output [31:0] head1Position;
	 assign head1Position = snake_data[231:200];
	 
	 output [31:0] head1;
	 assign head1 = snake_data[391:360];

    /** IMEM **/
    // Figure out how to generate a Quartus syncram component and commit the generated verilog file.
    // Make sure you configure it correctly!
    wire [11:0] address_imem;
    wire [31:0] q_imem;
    imem my_imem(
        .address    (address_imem),            // address of data
        .clock      (~clock),                  // you may need to invert the clock
        .q          (q_imem)                   // the raw instruction
    );

    /** DMEM **/
    // Figure out how to generate a Quartus syncram component and commit the generated verilog file.
    // Make sure you configure it correctly!
    wire [11:0] address_dmem;
    wire [31:0] data;
    wire wren;
    wire [31:0] q_dmem;
    dmem my_dmem(
        .address    (/* 12-bit wire */address_dmem),       // address of data
        .clock      (~clock),                  // may need to invert the clock
        .data	    (/* 32-bit data in */data),    // data you want to write
        .wren	    (/* 1-bit signal */wren),      // write enable
        .q          (/* 32-bit data out */q_dmem)    // data from dmem
    );

    /** REGFILE **/
    // Instantiate your regfile
    wire ctrl_writeEnable;
    wire [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    wire [31:0] data_writeReg;
    wire [31:0] data_readRegA, data_readRegB;
	 wire [31:0] randomNum, debug;
	 
	 integer counter;
	 reg loadSeed;
	 integer move1;
	 
	 initial begin
		move1 = 2;
		counter = 0;
		loadSeed = 1'b1;
	end
	
	always@(posedge VGA_CLK) begin
	
		if (counter == 1) begin
			loadSeed = 1'b0;
		end
		counter = counter + 1;
	
	end
	 
	 rng rng1(.clk(VGA_CLK), .reset(1'b1), .loadseed_i(loadSeed), .rngOut(randomNum[11:0]));
	 assign randomNum[31:12] = 20'b0;

    regfile my_regfile(
        clock,
        ctrl_writeEnable,
        reset,
        ctrl_writeReg,
        ctrl_readRegA,
        ctrl_readRegB,
        data_writeReg,
        data_readRegA,
        data_readRegB,
		  move1, debug, randomNum
    );

    /** PROCESSOR **/
    processor my_processor(
        // Control signals
        clock,                          // I: The master clock
        reset,                          // I: A reset signal

        // Imem
        address_imem,                   // O: The address of the data to get from imem
        q_imem,                         // I: The data from imem

        // Dmem
        address_dmem,                   // O: The address of the data to get or put from/to dmem
        data,                           // O: The data to write to dmem
        wren,                           // O: Write enable for dmem
        q_dmem,                         // I: The data from dmem

        // Regfile
        ctrl_writeEnable,               // O: Write enable for regfile
        ctrl_writeReg,                  // O: Register to write to in regfile
        ctrl_readRegA,                  // O: Register to read from port A of regfile
        ctrl_readRegB,                  // O: Register to read from port B of regfile
        data_writeReg,                  // O: Data to write to for regfile
        data_readRegA,                  // I: Data from port A of regfile
        data_readRegB,                   // I: Data from port B of regfile
		  snake_data
    );

endmodule