library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegisterFile is
  port(
    ReadRegister_1           : in std_logic_vector(4 downto 0);    	-- Endereço do primeiro registrador a ser lido
    ReadRegister_2           : in std_logic_vector(4 downto 0);    	-- Endereço do segundo registrador a ser lido
    WriteRegister      	    : in std_logic_vector(4 downto 0);    	-- Endereço do registrador a ser escrito
    WriteData                : in  std_logic_vector(31 downto 0);     -- Dado a ser escrito
    RegWrite  			    : in  std_logic;     				-- Sinal de controle
    ReadData_1         	    : out  std_logic_vector(31 downto 0);    -- Dado do primeiro registrador lido
    ReadData_2       	    : out  std_logic_vector(31 downto 0);    -- Dado do segundo registrador lido
    CLK                 	    : in  std_logic                        	-- Sinal do CLOCK
    );
end RegisterFile;

architecture TypeArchitecture of RegisterFile is
  type RegisterFile is array(0 to 31) of std_logic_vector(31 downto 0);
  signal Registers : RegisterFile := 
   ("00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000",
    "00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000",
    "00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000",
    "00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000",
    "00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000",
    "00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000",
    "00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000",
    "00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000");

begin
  regFile : process (CLK) is
  begin
    if falling_edge(CLK) then
      if (Registers(to_integer(unsigned(ReadRegister_1))) = "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU") THEN -- Caso o valor do registrador esteja indefinido, a saída será "000..."
      	ReadData_1 <= (others => '0');  
      ELSE 
      	ReadData_1 <= registers(to_integer(unsigned(ReadRegister_1)));  -- Leitura do valor contido no registrador 1
      END IF;
      IF (Registers(to_integer(unsigned(ReadRegister_2))) = "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU") THEN -- Caso o valor do registrador esteja indefinido, a saída será "000..."
      	ReadData_2 <= (others => '0');  
      ELSE
      	ReadData_2 <= registers(to_integer(unsigned(ReadRegister_2)));  -- Leitura do valor contido no registrador 2 
      END IF;
    end if; 
    if rising_edge(CLK) then
      if RegWrite = '1' then
        Registers(to_integer(unsigned(WriteRegister))) <= WriteData;      -- Escrita do valor no registrador selecionado
      end if;
    end if;
  end process;
  
end TypeArchitecture;
