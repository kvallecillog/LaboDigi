

module imul
( 
	input wire [3:0] wMulA,
	input wire [3:0] wMulB,
	output reg [7:0] rResult
);

	reg rCarry1;
	reg rCarry2;
	reg rCarry3;
	reg [2:0] rTemp1,rTemp2;
	reg hola1,hola2,hola3;
	
	always @ (*) begin

		// Operacion para obtener R0.
		rResult [0] = wMulA[0] & wMulB [0];
		
		// Operacion para obtener R1.
		{rCarry1,rResult [1]} = (wMulA [0] & wMulB [1]) + (wMulA [1] & wMulB [0]);
		
		// Operacion para obtener R2.
		{rCarry1,rTemp1 [0]} = wMulA [2] & wMulB [0] + wMulA [1] & wMulB [0] + rCarry1;
		{rCarry2,rResult[2]} = (wMulA[0]&wMulB[2])+ rTemp1[0];
		
		// Operacion para obtener R3.
		{rCarry1,rTemp1 [1]} = (wMulA[3]&wMulB[0]) + (wMulA[2]&wMulB[1]) + rCarry1;
		{rCarry2,rTemp2 [0]} = (wMulA[1]&wMulB[2]) + rTemp1[1] + rCarry2;
		{rCarry3,rResult[3]} = (wMulA[0]&wMulB[3]) + rTemp2[0];
		
		
		// Operacion para obtener R4.
		{rCarry1,rTemp1 [2]} = (wMulA[3]&wMulB[1]) + rCarry1;
		{rCarry2,rTemp2 [1]} = (wMulA[2]&wMulB[2])+ rTemp1[2]+rCarry2;
		{rCarry3,rResult[4]} = (wMulA[1]&wMulB[3])+ rTemp2[2]+rCarry3;		

		// Operacion para obtener R5.
		{rCarry2,rTemp2 [2]} = (wMulA[3]&wMulB[2])+rCarry2+rCarry1;
		{rCarry3,rResult[5]} = (wMulA[2]&wMulB[3])+ rTemp2[2]+rCarry3;		
		
		// Operacion para obtener R6 y R7.
		{rResult[7],rResult[6]} = (wMulA[3]&wMulB[3])+rCarry2+rCarry3;


		
	end
endmodule






module test;

	reg  [3:0] mul1,mul2;
	wire  [7:0] result;

	imul multiplier(.wMulA(mul1),.wMulB(mul2),.rResult(result));
	
	initial begin
		
		mul1<=4'b0011;
		mul2<=4'b0011;
				
		#200 $display("El resultado es: %b", result);
	
//		#2 $finish;
	end

endmodule