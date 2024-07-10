LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY EXMEM IS
  PORT (
    CLK             : IN std_logic;                             -- Entrada do sinal de clock            
    Branch_in       : IN std_logic;                             -- Entrada do sinal de controle que define quando ocorre Branch
    MemWrite_in     : IN std_logic;                             -- Entrada do sinal de controle que define quando a Memória será escrita
    MemRead_in      : IN std_logic;                             -- Entrada do sinal de controle que define quando a Memória será lida
    RegWrite_in     : IN std_logic;                             -- Entrada do sinal de controle que define quando o registrador será escrito
    MemToReg_in     : IN std_logic;                             -- Entrada do sinal de controle que define quando um dado será passado da memória para o registrador
    New_PC_in       : IN std_logic_vector(31 DOWNTO 0);         -- Soma do PC com imediato (jal) ou reg com imediato substituindo PC (jalr)
    Zero_in         : IN std_logic;                             -- Quando o resultado da ALU foi zero (serve para Branch)
    ALUresult_in    : IN std_logic_vector(31 DOWNTO 0);         -- Entrada do resultado da operação da ALU
    read2_in        : IN std_logic_vector(31 DOWNTO 0);         -- Entrada do valor lido do read data 2
    Rd_in           : IN std_logic_vector(4 DOWNTO 0);          -- Entrada da instrução atual buscada na memória de instruções
    Jalr_ou_Jal_in	: IN std_logic;					    -- Entrada que indica se é Jalr ou Jal	
  
    Branch_out      : out std_logic;                            -- Saída do sinal de controle que define quando ocorre Branch 
    MemWrite_out    : out std_logic;                            -- Saída do sinal de controle que define quando a Memória será escrita
    MemRead_out     : out std_logic;                            -- Saída do sinal de controle que define quando a Memória será lida
    RegWrite_out    : out std_logic;                            -- Saída do sinal de controle que define quando o registrador será escrito
    MemToReg_out    : out std_logic;                            -- Saída do sinal de controle que define quando um dado será passado da memória para o registrador
    New_PC_out       : out std_logic_vector(31 DOWNTO 0);        -- Soma do PC com imediato (jal) ou reg com imediato substituindo PC (jalr)
    Zero_out        : out std_logic;                            -- Quando o resultado da ALU foi zero (serve para Branch)
    ALUresult_out   : out std_logic_vector(31 DOWNTO 0);        -- Saída do resultado da operação da ALU
    read2_out       : out std_logic_vector(31 DOWNTO 0);        -- Saída do valor lido do read data 2
    Rd_out          : out std_logic_vector(4 DOWNTO 0);          -- Saída da instrução atual buscada na memória de instruções
    Jalr_ou_Jal_out	: out std_logic					    -- Saída que indica se é Jalr ou Jal
    );
END EXMEM;


ARCHITECTURE TypeArchitecture OF EXMEM IS

SIGNAL exmem_sig : std_logic_vector(107 DOWNTO 0);  -- Registrador de 192 bits para armazenar os valores do EXMEM

BEGIN

    PROCESS (CLK)
    BEGIN
        IF (rising_edge(CLK)) THEN                   -- Detecta a borda de subida do sinal de clock
            exmem_sig(0)    <= Branch_in;          
            exmem_sig(1)    <= MemWrite_in;          
            exmem_sig(2)   <= MemRead_in;      
            exmem_sig(3)   <= RegWrite_in;
            exmem_sig(4)   <= MemToReg_in;  
            exmem_sig(36 downto 5)    <= New_PC_in;       
            exmem_sig(37)           <= Zero_in;   
            exmem_sig(69 downto 38)    <= ALUresult_in;   
            exmem_sig(101 downto 70)    <= read2_in;   
            exmem_sig(106 downto 102)    <= Rd_in;   
            exmem_sig(107) <= Jalr_ou_Jal_in;
        END IF;
        IF (falling_edge(CLK)) THEN                 -- Detecta a borda de descida do sinal de clock
            Branch_out    <= exmem_sig(0);       
            MemWrite_out  <= exmem_sig(1);     
            MemRead_out  <= exmem_sig(2);      
            RegWrite_out <= exmem_sig(3);    
            MemToReg_out <= exmem_sig(4);
            New_PC_out <= exmem_sig(36 downto 5);
            Zero_out <= exmem_sig(37);
            ALUresult_out <= exmem_sig(69 downto 38);
            read2_out <= exmem_sig(101 downto 70);
            Rd_out <= exmem_sig(106 downto 102);
            Jalr_ou_Jal_out <= exmem_sig(107);
        END IF;
    END PROCESS;

    
END TypeArchitecture;
