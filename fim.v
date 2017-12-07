module maquina(CLOCK_27, SW, HEX0, KEY[3], LEDG, LEDR);

input [1:0]SW; //SW[0] = Sensor, SW[1] = Motor.
input [0:0]CLOCK_27; //clock de 27mHz da placa.
input [3:3]KEY;  ///botão de acionamento do portão.

output reg [6:0]HEX0;
output [0:0]LEDG, LEDR; // Verde indica abrindo, e vermelho fechando.
reg [1:0]ESTADO; // como são apenas 4 estados, 2 bits.

//DECLARAÇAO DOS ESTADOS:
parameter A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;

//TRANSIÇAO DE ESTADOS
initial ESTADO = A;
always @(posedge CLOCK_27[0])
begin
	case(ESTADO)
		 A: if(KEY[3] == 0 && SW[1] == 1)  ESTADO <= B; else ESTADO <= A;
		 B: if(KEY[3] == 1 && SW == 2'b00) ESTADO <= C; else if(KEY[3] == 0 && SW == 2'b01) ESTADO <= D; else ESTADO <=B;
		 C: if(KEY[3] == 0 && SW[1] == 1)  ESTADO <= D; else ESTADO <= C;
		 D: if(KEY[3] == 1 && SW == 2'b00) ESTADO <= A; else if((KEY[3] == 0 && SW[1] == 1 )|| SW[0] == 1) ESTADO <= C; else ESTADO <=D;
		endcase
end

//GERAÇAO DAS SAÍDAS
always @ (ESTADO)
begin
	case(ESTADO)
		A: HEX0 = 7'b0001110; // Mostra "F"
		B: HEX0 = 7'b1000000; // Mostra "0"
		C: HEX0 = 7'b0001000; // Mostra "A"
		D: HEX0 = 7'b1000000; // Mostra "0"
	endcase
end
// Como não é possível fazer assign dentro de um "always" será feito ao fim, usando o que está nos registradores.
assign LEDG[0] = (~ESTADO[1] && ESTADO[0]); //acende apenas no estado B = 01.
assign LEDR[0] = (ESTADO[1] && ESTADO[0]); //acende apenas no estado D = 11.

endmodule
