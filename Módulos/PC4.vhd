library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;


ENTITY PC4 IS
  PORT (
    CLK      : IN  std_logic;                    		-- Entrada do Clock
    RESET    : IN  std_logic;                    		-- Entrada de Reset
    PC_in    : IN  std_logic_vector(31 DOWNTO 0); 	-- Entrada do endereço atual
    WriteEnable   : IN std_logic;               		-- Entrada de Habilitação de escrita no PC
    PC_out   : OUT std_logic_vector(31 DOWNTO 0)  	-- Saída do próximo endereço
    );
END PC4;

ARCHITECTURE TypeArchitecture OF PC4 IS

BEGIN

	PROCESS (CLK, RESET, WriteEnable)
	BEGIN
		IF (rising_edge(CLK)) THEN                      				-- Detecção do Clock
			if (PC_in = "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU") then   	-- Verificação de endereço indefinido
				PC_out <= (others => '0');               			-- Caso indefinido, início no primeiro endereço
			elsif (WriteEnable = '0') then              				-- WriteEnable desabilitado
				PC_out <= PC_in;								-- Manutenção do endereço atual
			elsif (WriteEnable = '1') then						-- WriteEnable habilitado
				PC_out <= PC_in + '1';							-- Atualização do endereço
			end if;
		END IF;
		IF (RESET = '1') THEN                           				-- Detecção de Reset
			PC_out <= (others => '0');                   			-- Retorno ao primeiro endereço
		END IF;
	END PROCESS;

END TypeArchitecture;
