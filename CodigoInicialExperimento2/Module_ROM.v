`timescale 1ns / 1ps
`include "Defintions.v"

`define LOOP1 8'd8
`define LOOP2 8'd5

`define LOOP3 8'd3

`define LOOP4 8'd4

`define LOOP5 8'd5

module ROM
(
	input  wire[15:0]  		iAddress,
	output reg [27:0] 		oInstruction
);	
always @ ( iAddress )
begin

	case (iAddress)

	0: oInstruction = { `NOP ,24'd4000    };
	1: oInstruction = { `STO , `R7,16'b0001 };
	2: oInstruction = { `STO ,`R3,16'h1     }; 
	3: oInstruction = { `STO, `R4,16'd1000 };
	4: oInstruction = { `STO, `R5,16'd0     };  //j
//LOOP2:
	5: oInstruction = { `LED ,8'b0,`R7,8'b0 };
	6: oInstruction = { `STO ,`R1,16'h0     }; 	
	7: oInstruction = { `STO ,`R2,16'd05000 };
//LOOP1:	
	8: oInstruction = { `ADD ,`R1,`R1,`R3    }; 
	9: oInstruction = { `BLE ,`LOOP1,`R1,`R2 }; 
	
	10: oInstruction = { `ADD ,`R5,`R5,`R3    };
	11: oInstruction = { `BLE ,`LOOP2,`R5,`R4 };	
	12: oInstruction = { `NOP ,24'd4000       }; 
	13: oInstruction = { `ADD ,`R7,`R7,`R3    };
	14: oInstruction = { `JMP ,  8'd2,16'b0   };
	default:
		oInstruction = { `LED ,  24'b10101010 };		//NOP
	endcase
	/*
	case (iAddress)
	
	0: oInstruction = { `NOP , 24'd4000  };
	1: oInstruction = { `STO , `R1,16'd5 };
	2: oInstruction = { `STO , `R2,16'd10 };
	3: oInstruction = { `SUB , `R3, `R1, `R2 };	
	4: oInstruction = { `LED , 8'b0,`R3,8'b0 };	
	5: oInstruction = { `BLE ,`LOOP3,`R1,`R2 };	

	default:
	
	oInstruction = { `LED ,  24'b10101010 };	
	
	endcase
	*/
	
	/*
	
	case (iAddress)

	0: oInstruction = { `NOP ,24'h0    };
	1: oInstruction = { `NOP ,24'h0    };
	2: oInstruction = { `STO ,`R7,16'd1 };
	3: oInstruction = { `STO ,`R3,16'd500     }; 
	4: oInstruction = { `STO ,`R4,16'd1000 };//j
//LOOP5:
	5: oInstruction = { `NOP ,24'h0    };
	6: oInstruction = { `ADD ,`R5, `R4, `R3}; 	
	7: oInstruction = { `STO ,`R2,16'd05000 };
	8: oInstruction = { `NOP ,24'h0    };
	9: oInstruction = { `BLE ,`LOOP5,`R5,`R2 };
	
	10: oInstruction = { `ADD ,`R5,`R5,`R3    };
	11: oInstruction = { `BLE ,`LOOP2,`R5,`R4 };	
	12: oInstruction = { `NOP ,24'd4000       }; 
	13: oInstruction = { `ADD ,`R7,`R7,`R3    };
	14: oInstruction = { `JMP ,  8'd2,16'b0   };
	default:
		oInstruction = 28'd0;		//NOP
	endcase	
	

	*/
	/*
	// Verificación del pipeline
	case (iAddress)

	0: oInstruction = {`NOP,`R1,`R1,`R0}; 
	1: oInstruction = {`STO, `R1,16'd5}; 
	
	2: oInstruction = {`STO,`R0,16'd3};
	// Se ve como si la instrucción pasada es un STO y la presente un NOP
	// no se aplica el forwarding aquneu el destino anterior es igual a 
	// una de la fuentes presentes.
	3: oInstruction = {`NOP,`R0,`R1,`R0};
	
	// Se ve como si la instrucción pasada es un NOP y la presente un ADD
	// no se aplica el forwarding aunque el destino anterior es igual a 
	// una de la fuentes presentes.
	4: oInstruction = {`ADD, `R1,`R1,`R0};
	
	// Se ve como si la instrucción pasada es un ADD y la presente un ADD
	// y el destino anterior es igual a una de la fuentes presentes se aplica el forwarding.
	5: oInstruction = {`ADD, `R2,`R1,`R0};
	// Se ve como aunque la instrucción presente es un STO pero  
	
	6: oInstruction = {`STO, `R2,`R1,`R0};

	default:
		oInstruction = 28'd0;		//NOP
	endcase	
	
	*/




	
end
	
endmodule
