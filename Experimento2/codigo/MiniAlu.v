`timescale 1ns / 1ps
`include "Defintions.v"

module MiniAlu
(
 input wire Clock,
 input wire Reset,
 output wire [7:0] oLed

 
);

wire [15:0]  wIP,wIP_temp;
reg        rWriteEnable,rBranchTaken;
wire [27:0] wInstruction;
wire [3:0]  wOperation;


// Se cambia de reg a 
// reg wired como lo indica el enunciado.
reg signed [15:0] rResult;

// Se crea una variable temporal para almacenar el resultado de la
// multiplicacion y después tomar la parte más significativa y ponerla
// en rResult.
reg signed [31:0] rResultTemp;

wire [7:0]  wSourceAddr0,wSourceAddr1,wDestination,wDestinationAddr_prev;

// Se cambia el tipo de wire en un wired signed como lo indica el enunciado
// esto con el fin de obtener un resultado correcto en la multiplicación SMUL.
wire signed [15:0] wSourceData0_signed,wSourceData1_signed;

wire [15:0] wSourceData0,wSourceData1,wIPInitialValue,wImmediateValue;
wire [15:0] wSourceData0_RAM,wSourceData1_RAM;
wire [3:0] wOperation_prev;

ROM InstructionRom 
(
	.iAddress(     wIP          ),
	.oInstruction( wInstruction )
);



RAM_DUAL_READ_PORT DataRam
(
	.Clock(         Clock        ),
	.iWriteEnable(  rWriteEnable ),
	.iReadAddress0( wInstruction[7:0] ),
	.iReadAddress1( wInstruction[15:8] ),
	.iWriteAddress( wDestination ),
	.iDataIn(       rResult      ),
	.oDataOut0(     wSourceData0_RAM ),
	.oDataOut1(     wSourceData1_RAM )
);

assign wSourceData0 = (wDestinationAddr_prev==wSourceAddr0 && (
(wInstruction [27:24] != `NOP || wInstruction [27:24] != `STO || wInstruction [27:24] != `JMP ) ||
(wOperation_prev != `NOP || wOperation_prev != `BLE || wOperation_prev != `JMP || wOperation_prev != `LED )) ) ? rResult:wSourceData0_RAM;


assign wSourceData1 = (wDestinationAddr_prev==wSourceAddr1 && (
(wInstruction [27:24] != `NOP || wInstruction [27:24] != `STO || wInstruction [27:24] != `JMP || wInstruction [27:24] != `LED) ||
(wOperation_prev != `NOP || wOperation_prev != `BLE || wOperation_prev != `JMP || wOperation_prev != `LED)) ) ? rResult:wSourceData1_RAM;

// Se asigna el valor de las sources a las sources con signo
// Esto permite tomar los valores de las sources
// y darles signo para utilizarlos en la multiplicación SMUL
// y utilizar sus valores sin signo para las demás operaciones.
assign wSourceData0_signed = wSourceData0;
assign wSourceData1_signed = wSourceData1;

wire check0, check1;

assign check0  = (wDestinationAddr_prev==wSourceAddr0 && (
(wInstruction [27:24] != `NOP || wInstruction [27:24] != `STO || wInstruction [27:24] != `JMP ) ||
(wOperation_prev != `NOP || wOperation_prev != `BLE || wOperation_prev != `JMP || wOperation_prev != `LED )) ) ? 1:0;

assign check1  = (wDestinationAddr_prev==wSourceAddr1 && (
(wInstruction [27:24] != `NOP || wInstruction [27:24] != `STO || wInstruction [27:24] != `JMP || wInstruction [27:24] != `LED) ||
(wOperation_prev != `NOP || wOperation_prev != `BLE || wOperation_prev != `JMP || wOperation_prev != `LED)) ) ? 1:0;

assign wIPInitialValue = (Reset) ? 8'b0 : wDestination;


UPCOUNTER_POSEDGE IP	
(
.Clock(   Clock                ), 
.Reset(   Reset | rBranchTaken ),
// Se cambia la forma de realizar la suma para evitar el warning.
.Initial( wIPInitialValue+16'b1),
.Enable(  1'b1                 ),
.Q(       wIP_temp             )
);
assign wIP = (rBranchTaken) ? wIPInitialValue : wIP_temp;
 
// Se agrega un flip flop para almacenar el destino de la instrucciÃ³n anterior
// para lograr verificar si se necesita realizar el forwarding en el pipeline 
// para la ejecuciÃ³n correcta de la siguiente instrucciÃ³n.
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD0
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wDestination),
	.Q(wDestinationAddr_prev)
);


// Se cambia el tamaño del parametro para que sea de 4 bits en vez de 8
// siendo 4 el tamaño necesario y eliminando asÃ­ 2 warnings.
FFD_POSEDGE_SYNCRONOUS_RESET # ( 4 ) FFD1 
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[27:24]),
	.Q(wOperation)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD2
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[7:0]),
	.Q(wSourceAddr0)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD3
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[15:8]),
	.Q(wSourceAddr1)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD4
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[23:16]),
	.Q(wDestination)
);

// Se agrega un flip flop para almacenar cual es la instrucciÃ³n anterior
// para lograr verificar si se necesita realizar el forwarding en el pipeline 
// para la ejecuciÃ³n correcta de la siguiente instrucciÃ³n.
FFD_POSEDGE_SYNCRONOUS_RESET # ( 4 ) FFD5
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wOperation),
	.Q(wOperation_prev)
);

reg rFFLedEN;
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FF_LEDS
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable( rFFLedEN ),
	// Se toman solo los primeros 8 bits de wSourceData1 ya que se usan solo 8 LEDs
	// en la tarjeta, note que el cable oLed es de 8 bits tambiÃ©n. AsÃ­ se evita un
	// warning.
	.D( wSourceData1 [7:0] ),
	.Q( oLed    )
);

assign wImmediateValue = {wSourceAddr1,wSourceAddr0};

always @ ( * )
begin
	case (wOperation)
	//-------------------------------------
	`NOP:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
	end
	//-------------------------------------
	`ADD:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult      <= wSourceData1 + wSourceData0;
	end
	//-------------------------------------
	`STO:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b1;
		rBranchTaken <= 1'b0;
		rResult      <= wImmediateValue;
	end
	//-------------------------------------
	`BLE:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		if (wSourceData1 <= wSourceData0 )
			rBranchTaken <= 1'b1;
		else
			rBranchTaken <= 1'b0;
		
	end
	//-------------------------------------	
	`JMP:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b1;
	end
	//-------------------------------------	
	`LED:
	begin
		rFFLedEN     <= 1'b1;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b0;
	end
	//-------------------------------------
	`SUB:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult      <= wSourceData0 - wSourceData1;
	end
	//-------------------------------------
	`SMUL:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		// Se calcula la multiplicacion y se guarda en un variable temporal.
		rResultTemp  <= wSourceData0_signed * wSourceData1_signed;
		// Se toma la parte alta de la variable temporal y se guarda en el resultado.
		rResult		 <= rResultTemp [31:16];
	end	
	//-------------------------------------
	default:
	begin
		rFFLedEN     <= 1'b1;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b0;
	end	
	//-------------------------------------	
	endcase	
end


endmodule