library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_Unit is
    port(
        instruction                	: IN  std_logic_vector(31 downto 0);  -- Entrada da Instrução
        Stall                			: IN  std_logic;  				   -- Entrada do Hazard
        AluSrc, RegWrite, MemToReg 	: OUT std_logic;                      -- Sinais de Controle (1 Bit)
        MemRead, MemWrite, Branch  	: OUT std_logic;                      -- Sinais de Controle (1 Bit)
        Soma_PC 					: OUT std_logic;			   	   -- Sinais de Controle (1 Bit)	
        AluOp		               	: OUT std_logic_vector(1 downto 0);   -- Saída da Operação da ALU (2 Bits)
        S_funct7 					: OUT std_logic_vector(6 downto 0);   -- Saída do Funct7
        S_funct3 					: OUT std_logic_vector(2 downto 0);   -- Saída do Funct3
        S_opcode 					: OUT std_logic_vector(6 downto 0);   -- Saída do Opcode
        JumpReg					: OUT std_logic;				   -- Indica quando a instrução é jalr	
        mode						: OUT std_logic;				   -- Indica se é uma operação vetorial
        Vecsize					: OUT std_logic_vector(1 downto 0));  -- Indica o tamanho do vetor
        
end Control_Unit;

architecture TypeArchitecture of Control_Unit is

signal opcode : std_logic_vector(6 downto 0);	-- Opcode da Instrução
signal funct7 : std_logic_vector(6 downto 0);	-- Funct7 da Instrução
signal funct3 : std_logic_vector(2 downto 0);	-- Funct3 da Instrução


begin
	-- Definição do Opcode da Instrução
	opcode(0) <= instruction(0);
	opcode(1) <= instruction(1);
	opcode(2) <= instruction(2);
	opcode(3) <= instruction(3);
	opcode(4) <= instruction(4);
	opcode(5) <= instruction(5);
	opcode(6) <= instruction(6);
	Soma_PC <= '0'; 
	JumpReg <= '0';

	process(Stall)
	begin
		IF (Stall = '1') THEN
			AluSrc <= '0';
			RegWrite <= '0';
			MemToReg <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			Branch <= '0';
			Soma_PC <= '0';
			JumpReg <= '0';
		end if; 
	end process;
	-- Definição das Funct7, Funct3 e dos Sinais de Controle de acordo com o opcode.
	process(opcode)
	begin
		IF (opcode = "0110011") THEN		-- R-Type Instruction
			funct7(6) <= instruction(31);
			funct7(5) <= instruction(30);
			funct7(4) <= instruction(29);
			funct7(3) <= instruction(28);
			funct7(2) <= instruction(27);
			funct7(1) <= instruction(26);
			funct7(0) <= instruction(25);
			funct3(2) <= instruction (14);
			funct3(1) <= instruction (13);
			funct3(0) <= instruction (12);
			AluSrc <= '0'; 			
			RegWrite <= '1';
			MemToReg <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			Branch <= '0';
			mode <= '0';
			Vecsize <= "11";
			AluOp <= "10";
		END IF;
		IF (opcode = "0010011") THEN		-- I-Type Instruction (ADDi, ANDi, ORi, XORi, SLTi)
			funct7(6) <= '0';
			funct7(5) <= '0';
			funct7(4) <= '0';
			funct7(3) <= '0';
			funct7(2) <= '0';
			funct7(1) <= '0';
			funct7(0) <= '0';
			funct3(2) <= instruction (14);
			funct3(1) <= instruction (13);
			funct3(0) <= instruction (12);
			AluSrc <= '1'; 			
			RegWrite <= '1';
			MemToReg <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			Branch <= '0';
			mode <= '0';
			Vecsize <= "11";
			AluOp <= "10";
		END IF;
		IF (opcode = "0000011") THEN		-- I-Type Instruction (Load)
			funct7(6) <= '0';
			funct7(5) <= '0';
			funct7(4) <= '0';
			funct7(3) <= '0';
			funct7(2) <= '0';
			funct7(1) <= '0';
			funct7(0) <= '0';
			funct3(2) <= '0';
			funct3(1) <= '0';
			funct3(0) <= '0';
			AluSrc <= '1'; 			
			RegWrite <= '1';
			MemToReg <= '1';
			MemRead <= '1';
			MemWrite <= '0';
			Branch <= '0';
			mode <= '0';
			Vecsize <= "11";
			AluOp <= "00";
		END IF;
		IF (opcode = "1100111") THEN		-- I-Type Instruction (Jump) 
			funct7(6) <= '0';
			funct7(5) <= '0';
			funct7(4) <= '0';
			funct7(3) <= '0';
			funct7(2) <= '0';
			funct7(1) <= '0';
			funct7(0) <= '0';
			funct3(2) <= '0';
			funct3(1) <= '0';
			funct3(0) <= '0';
			AluSrc <= '0'; 			
			RegWrite <= '0';
			MemToReg <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			Branch <= '0';
			Soma_PC <= '1';
			JumpReg <= '1';
			mode <= '0';
			Vecsize <= "11";
			AluOp <= "01";
		END IF;
		IF (opcode = "0100011") THEN		-- S-Type Instruction 
			funct7(6) <= '0';
			funct7(5) <= '0';
			funct7(4) <= '0';
			funct7(3) <= '0';
			funct7(2) <= '0';
			funct7(1) <= '0';
			funct7(0) <= '0';
			funct3(2) <= '0';
			funct3(1) <= '0';
			funct3(0) <= '0';
			AluSrc <= '1'; 			
			RegWrite <= '0';
			MemToReg <= '0';
			MemRead <= '0';
			MemWrite <= '1';
			Branch <= '0';
			mode <= '0';
			Vecsize <= "11";
			AluOp <= "00";
		END IF;
		IF (opcode = "1101111") THEN		-- UJ-Type Instruction (jal)
			funct7(6) <= '0';
			funct7(5) <= '0';
			funct7(4) <= '0';
			funct7(3) <= '0';
			funct7(2) <= '0';
			funct7(1) <= '0';
			funct7(0) <= '0';
			funct3(2) <= '0';
			funct3(1) <= '0';
			funct3(0) <= '0';
			AluSrc <= '0'; 			
			RegWrite <= '1';
			MemToReg <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			Branch <= '0';
			Soma_PC <= '1';
			mode <= '0';
			Vecsize <= "11";
			AluOp <= "10";
		END IF;
		IF (opcode = "0110111") THEN		-- U-Type Instruction (lui - soma com imediato muito grande)
			funct7(6) <= '0';
			funct7(5) <= '0';
			funct7(4) <= '0';
			funct7(3) <= '0';
			funct7(2) <= '0';
			funct7(1) <= '0';
			funct7(0) <= '0';
			funct3(2) <= '0';
			funct3(1) <= '0';
			funct3(0) <= '0';
			AluSrc <= '1'; 			
			RegWrite <= '1';
			MemToReg <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			Branch <= '0';
			mode <= '0';
			Vecsize <= "11";
			AluOp <= "10";
		END IF;
		IF (opcode = "0010111") THEN		-- U-Type Instruction (auipc, soma do pc com o imediato e guarda no registrador)
			funct7(6) <= '0';
			funct7(5) <= '0';
			funct7(4) <= '0';
			funct7(3) <= '0';
			funct7(2) <= '0';
			funct7(1) <= '0';
			funct7(0) <= '0';
			funct3(2) <= '0';
			funct3(1) <= '0';
			funct3(0) <= '0';
			AluSrc <= '1'; 			
			RegWrite <= '1';
			MemToReg <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			Branch <= '0';
			Soma_PC <= '1';
			mode <= '0';
			Vecsize <= "11";
			AluOp <= "10";
		END IF;
		IF (opcode = "1100011") THEN		-- Sb-Type Instruction 
			funct7(6) <= '0';
			funct7(5) <= '0';
			funct7(4) <= '0';
			funct7(3) <= '0';
			funct7(2) <= '0';
			funct7(1) <= '0';
			funct7(0) <= '0';
			funct3(2) <= instruction (14);
			funct3(1) <= instruction (13);
			funct3(0) <= instruction (12);
			AluSrc <= '0'; 			
			RegWrite <= '0';
			MemToReg <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			Branch <= '1';
			mode <= '0';
			Vecsize <= "11";
			AluOp <= "01";
		END IF;
		IF (opcode = "1111100") 	THEN		-- R-Type Vetorial Instruction (4bits)
			funct7(6) <= instruction(31);
			funct7(5) <= instruction(30);
			funct7(4) <= instruction(29);
			funct7(3) <= instruction(28);
			funct7(2) <= instruction(27);
			funct7(1) <= instruction(26);
			funct7(0) <= instruction(25);
			funct3(2) <= instruction (14);
			funct3(1) <= instruction (13);
			funct3(0) <= instruction (12);
			AluSrc <= '0'; 			
			RegWrite <= '1';
			MemToReg <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			Branch <= '0';
			mode <= '1';
			Vecsize <= "00";
			AluOp <= "10";
		END IF;
		IF (opcode = "1111101")  THEN				-- R-Type Vetorial Instruction (8bits)
			funct7(6) <= instruction(31);
			funct7(5) <= instruction(30);
			funct7(4) <= instruction(29);
			funct7(3) <= instruction(28);
			funct7(2) <= instruction(27);
			funct7(1) <= instruction(26);
			funct7(0) <= instruction(25);
			funct3(2) <= instruction (14);
			funct3(1) <= instruction (13);
			funct3(0) <= instruction (12);
			AluSrc <= '0'; 			
			RegWrite <= '1';
			MemToReg <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			Branch <= '0';
			mode <= '1';
			Vecsize <= "01";
			AluOp <= "10";
		END IF;
		IF (opcode = "1111110")	THEN			-- R-Type Vetorial Instruction (16bits)
			funct7(6) <= instruction(31);
			funct7(5) <= instruction(30);
			funct7(4) <= instruction(29);
			funct7(3) <= instruction(28);
			funct7(2) <= instruction(27);
			funct7(1) <= instruction(26);
			funct7(0) <= instruction(25);
			funct3(2) <= instruction (14);
			funct3(1) <= instruction (13);
			funct3(0) <= instruction (12);
			AluSrc <= '0'; 			
			RegWrite <= '1';
			MemToReg <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			Branch <= '0';
			mode <= '1';
			Vecsize <= "10";
			AluOp <= "10";
		END IF;
		IF (opcode = "1111000") THEN		-- I-Type Vetorial Instruction (Soma e deslocamento)(4bits)
			funct7(6) <= '0';
			funct7(5) <= '0';
			funct7(4) <= '0';
			funct7(3) <= '0';
			funct7(2) <= '0';
			funct7(1) <= '0';
			funct7(0) <= '0';
			funct3(2) <= instruction (14);
			funct3(1) <= instruction (13);
			funct3(0) <= instruction (12);
			AluSrc <= '1'; 			
			RegWrite <= '1';
			MemToReg <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			Branch <= '0';
			mode <= '1';
			Vecsize <= "00";
			AluOp <= "10";
		END IF;
		IF (opcode = "1111001") THEN		-- I-Type Vetorial Instruction (Soma e deslocamento)(8bits)
			funct7(6) <= '0';
			funct7(5) <= '0';
			funct7(4) <= '0';
			funct7(3) <= '0';
			funct7(2) <= '0';
			funct7(1) <= '0';
			funct7(0) <= '0';
			funct3(2) <= instruction (14);
			funct3(1) <= instruction (13);
			funct3(0) <= instruction (12);
			AluSrc <= '1'; 			
			RegWrite <= '1';
			MemToReg <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			Branch <= '0';
			mode <= '1';
			Vecsize <= "01";
			AluOp <= "10";
		END IF;
		IF (opcode = "1111010") THEN		-- I-Type Vetorial Instruction (Soma e deslocamento)(16bits)
			funct7(6) <= '0';
			funct7(5) <= '0';
			funct7(4) <= '0';
			funct7(3) <= '0';
			funct7(2) <= '0';
			funct7(1) <= '0';
			funct7(0) <= '0';
			funct3(2) <= instruction (14);
			funct3(1) <= instruction (13);
			funct3(0) <= instruction (12);
			AluSrc <= '1'; 			
			RegWrite <= '1';
			MemToReg <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			Branch <= '0';
			mode <= '1';
			Vecsize <= "10";
			AluOp <= "10";
		END IF;
		IF (opcode = "1110000") THEN		-- U-Type Vetorial Instruction (4bits)(auipc)
			funct7(6) <= '0';
			funct7(5) <= '0';
			funct7(4) <= '0';
			funct7(3) <= '0';
			funct7(2) <= '0';
			funct7(1) <= '0';
			funct7(0) <= '0';
			funct3(2) <= '0';
			funct3(1) <= '0';
			funct3(0) <= '0';
			AluSrc <= '1'; 			
			RegWrite <= '1';
			MemToReg <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			Branch <= '0';
			Soma_PC <= '1';
			mode <= '1';
			Vecsize <= "00";
			AluOp <= "10";
		END IF;
		IF (opcode = "1110001") THEN		-- U-Type Vetorial Instruction (4bits)(auipc)
			funct7(6) <= '0';
			funct7(5) <= '0';
			funct7(4) <= '0';
			funct7(3) <= '0';
			funct7(2) <= '0';
			funct7(1) <= '0';
			funct7(0) <= '0';
			funct3(2) <= '0';
			funct3(1) <= '0';
			funct3(0) <= '0';
			AluSrc <= '1'; 			
			RegWrite <= '1';
			MemToReg <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			Branch <= '0';
			Soma_PC <= '1';
			mode <= '1';
			Vecsize <= "01";
			AluOp <= "10";
		END IF;
		IF (opcode = "1110010") THEN		-- U-Type Vetorial Instruction (4bits)(auipc)
			funct7(6) <= '0';
			funct7(5) <= '0';
			funct7(4) <= '0';
			funct7(3) <= '0';
			funct7(2) <= '0';
			funct7(1) <= '0';
			funct7(0) <= '0';
			funct3(2) <= '0';
			funct3(1) <= '0';
			funct3(0) <= '0';
			AluSrc <= '1'; 			
			RegWrite <= '1';
			MemToReg <= '0';
			MemRead <= '0';
			MemWrite <= '0';
			Branch <= '0';
			Soma_PC <= '1';
			mode <= '1';
			Vecsize <= "10";
			AluOp <= "10";
		END IF;
	end process;
	S_funct7 <= funct7;
	S_funct3 <= funct3;
	S_opcode <= opcode;
end TypeArchitecture;	
