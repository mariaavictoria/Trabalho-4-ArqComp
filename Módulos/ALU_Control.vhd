library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_Control is
    port(
        Funct7    		: IN std_logic_vector(6 downto 0);    	 -- Entrada do funct7
        Funct3    		: IN std_logic_vector(2 downto 0);    	 -- Entrada do funct3
        Opcode    		: IN std_logic_vector(6 downto 0);   	 -- Entrada do opcode
        AluOp   		: IN std_logic_vector(1 downto 0);       -- Entrada de códigos de operação da ALU (2 bits)
        ALU_Controle 	: OUT std_logic_vector(3 downto 0);      -- Saída do controle da ALU (4 bits)
        Beq_Bne		: OUT std_logic					 -- Sinal de controle para verificação de Beq ou Bne
        );
end ALU_Control;

architecture TypeArchitecture of ALU_Control is
begin

	ALU_Controle <= "0010" when AluOp = "00" else 	-- Operação de Load
			 	 "0110" when AluOp = "01" else 	-- Operação de Branch
			 	 "0010" when Funct7 = "0000000" and Funct3 = "000" else 	-- Operação de Soma
			 	 "0110" when Funct7 = "0100000" and Funct3 = "000" else 	-- Operação de Subtração
			 	 "0011" when Funct7 = "0000000" and Funct3 = "001" else 	-- Operação de Shift Left
			 	 "0101" when Funct7 = "0000000" and Funct3 = "100" else 	-- Operação XOR
			 	 "0111" when Funct7 = "0000000" and Funct3 = "101" else 	-- Operação de Shift Right
			 	 "0001" when Funct7 = "0000000" and Funct3 = "110" else 	-- Operação OR
			 	 "0000" when Funct7 = "0000000" and Funct3 = "111"; 		-- Operação AND
	Beq_Bne <= '1' when opcode="1100011" and Funct3="000" else '0';			-- '1' quando a instrução for Beq
	 
end TypeArchitecture;
