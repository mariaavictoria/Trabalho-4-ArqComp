LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY MEMWB IS
  PORT (
    CLK             : IN std_logic;                             -- Entrada do sinal de clock            
    RegWrite_in     : IN std_logic;                             -- Entrada do sinal de controle que define quando o registrador será escrito
    MemToReg_in     : IN std_logic;                             -- Entrada do sinal de controle que define quando um dado será passado da memória para o registrador
    Mem_data_in     : IN std_logic_vector(31 DOWNTO 0);         -- Entrada do valor lido na memória
    ALUresult_in    : IN std_logic_vector(31 DOWNTO 0);         -- Entrada do resultado da operação da ALU
    Rd_in           : IN std_logic_vector(4 DOWNTO 0);          -- Entrada da instrução atual buscada na memória de instruções
  
    RegWrite_out    : out std_logic;                            -- Saída do sinal de controle que define quando o registrador será escrito
    MemToReg_out    : out std_logic;                            -- Saída do sinal de controle que define quando um dado será passado da memória para o registrador
    Mem_data_out    : out std_logic_vector(31 DOWNTO 0);        -- Saída do valor lido na memória
    ALUresult_out   : out std_logic_vector(31 DOWNTO 0);        -- Saída do resultado da operação da ALU
    Rd_out          : out std_logic_vector(4 DOWNTO 0)          -- Saída da instrução atual buscada na memória de instruções
    );
END MEMWB;


ARCHITECTURE TypeArchitecture OF MEMWB IS

SIGNAL memwb_sig : std_logic_vector(70 DOWNTO 0);  -- Registrador de 70 bits para armazenar os valores do memwb

BEGIN

    PROCESS (CLK)
    BEGIN
        IF (rising_edge(CLK)) THEN                   -- Detecta a borda de subida do sinal de clock     
            memwb_sig(0)   <= RegWrite_in;
            memwb_sig(1)   <= MemToReg_in;  
            memwb_sig(33 downto 2)  <= Mem_data_in ;       
            memwb_sig(65 downto 34)  <= ALUresult_in;   
            memwb_sig(70 downto 66)  <= Rd_in;   
        END IF;
        IF (falling_edge(CLK)) THEN                 -- Detecta a borda de descida do sinal de clock
            RegWrite_out <= memwb_sig(0);    
            MemToReg_out <= memwb_sig(1);
            Mem_data_out <= memwb_sig(33 downto 2);
            ALUresult_out <= memwb_sig(65 downto 34);
            Rd_out <= memwb_sig(70 downto 66);
        END IF;
    END PROCESS;

    
END TypeArchitecture;
