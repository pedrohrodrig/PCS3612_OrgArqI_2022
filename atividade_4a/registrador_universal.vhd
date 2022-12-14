--Registrador universal
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registrador_universal is
    generic (
        word_size: positive := 4
    );
    port (
        clock, clear, set, enable : in std_logic;
        control                   : in std_logic_vector(1 downto 0);
        serial_input              : in std_logic;
        parallel_input            : in std_logic_vector(word_size-1 downto 0);
        parallel_output           : out std_logic_vector(word_size-1 downto 0)
    );
end entity;

architecture funcionamento of registrador_universal is

    signal ea, pe: std_logic_vector(word_size-1 downto 0);

begin

    process(clock, clear, set, enable)
    begin
        if clear = '1' then
            ea <= (others => '0');
        elsif set = '1' then
            ea <= (others => '1');
        elsif rising_edge(clock) and enable = '1' then
            ea <= pe;
        end if;
    end process;

    -- proximo estado
    with control select 
        pe <=
            ea                                      when "00", -- nao faz nada
            serial_input & ea(word_size-1 downto 1) when "01", -- desloc direita
            ea(word_size-2 downto 0) & serial_input when "10", -- desloc esquerda
            parallel_input                          when others; -- ent paralela
    
    -- saida
    parallel_output <= ea;
end funcionamento ; 