`timescale 1ns / 1ps 
//This testbench assumes the presence of:
//A Verilog source file my_IP.v defining the UUT (simple combinatorial adder and multiplier with registered outputs).
//Text files: "my_IP_A.txt", "my_IP_B.txt" containing all possible test vectors.
//As well as text files "my_IP_GOLD_sum.txt", "my_IP_GOLD_prod.txt" containing the golden outputs

module gg_my_IP_TB;

parameter MAX_test_length = 255**2;
parameter stim_coverage = 30; //search space coverage(percentage).Use 100 for full coverage
reg 		clk, reset;
wire[15:0] 	prod;
wire[8:0]	sum;
integer	fid_sum_testout, fid_prod_testout; 	//Used by $fwrite as output file pointers
reg[7:0]	in_A[MAX_test_length-1:0];				//Allocate memory for input stimulus
reg[7:0]	in_B[MAX_test_length-1:0]; 			//Allocate memory for input stimulus
reg[15:0]	gold_Out_1[MAX_test_length-1:0];
reg[15:0]	gold_Out_2[MAX_test_length-1:0];
reg[15:0]	addr_in, addr_out;		//input/Golden Output buffer Address pointers
integer	i, test_points; 			//Iteration counter

// Initialize Simulation
initial
 begin
  $readmemb("my_IP_A.txt", in_A);				//read stimulus for A from file
  $readmemb("my_IP_B.txt", in_B);				//read stimulus for B from file
  $readmemb("my_IP_GOLD_sum.txt", gold_Out_1); 		//Golden output for sum
  $readmemb("my_IP_GOLD_prod.txt", gold_Out_2);		//Golden output for prod
  fid_sum_testout = $fopen("my_IP_sum.txt");		//output file for sum output.
  fid_prod_testout = $fopen("my_IP_prod.txt");		//output file for prod output.
  clk = 0; reset = 0; i = 0; addr_in = 0;
  addr_out = 0;
  #100; reset = 1;
 end 

//Clock Generator
always @(posedge reset)
begin
	forever #10 clk = ~clk;
end

//Instantiate the Unit Under Test (UUT)
gg_my_IP uut (.a(in_A[addr_in]),
		 .b(in_B[addr_in]),
		 .clk(clk),
		 .reset(reset),
		 .sum(sum),
		 .prod(prod));

//Stimulus (Exhaustive(full search space) or Randomized(a subset of the search space))
always @ (posedge clk)
begin
 if(reset)
   begin
	test_points = (MAX_test_length/100)*stim_coverage;//calculate search space coverage
	i = i+1; addr_in <= {$random};			   //Pick an input vector randomly
	addr_out <= addr_in;					   //Compensate for IP's 1clk latency
	if (i > test_points)
	 begin i = 0;
	  $display("TEST COMPLETE... \n\n");
	  $fclose(fid_sum_testout);
	  $fclose(fid_prod_testout);
	  $finish;
	end
  end//reset
end//always
//Output Monitor
always @ (posedge clk)
begin
 if(reset)
   begin //Compare actual output vector with Golden ouput vector
	if (sum[8:0] == gold_Out_1[addr_out][15:0])
$display("PASSED\t time:%0d\t i:%0d\t IN_A:%0d\t IN_B:%0d\t G1:%0d\t SUM:%d\ \n", $time,i,in_A[addr_in],in_B[addr_in],gold_Out_1[addr_out][15:0], sum[8:0]);
	else
$display("FAILED\t time:%0d\t i:%0d\t IN_A:%0d\t IN_B:%0d\t G1:%0d\t SUM:%d\ \n", $time,i,in_A[addr_in],in_B[addr_in],gold_Out_1[addr_out][15:0], sum[8:0]);
	if (prod[15:0] == gold_Out_2[addr_out][15:0])
$display("PASSED\t time:%0d\t i:%0d\t IN_A:%0d\t IN_B:%0d\t G2:%0d\t PROD:%d\ \n", $time,i,in_A[addr_in],in_B[addr_in],gold_Out_2[addr_out][15:0],prod[15:0]);
	else
$display("FAILED\t time:%0d\t i:%0d\t IN_A:%0d\t IN_B:%0d\t G2:%0d\t PROD:%d\ \n", $time,i,in_A[addr_in],in_B[addr_in],gold_Out_2[addr_out][15:0],prod[15:0]);
   end//reset

$fwrite(fid_sum_testout, "%b\n", sum[8:0]); 	//Record output to file
$fwrite(fid_prod_testout, "%b\n", prod[15:0]);
end//always

endmodule


