library ieee;
use ieee.std_logic_1164.all;

entity reg_16b is
	port (
			clk, reset : in std_logic;
			d : in std_logic_vector(15 downto 0);
			q : out std_logic_vector(15 downto 0)
		);
end entity;

architecture arch_reg of reg_16b is
begin
	process(clk, reset)
	begin
		if (reset = '1') then
			q <= (others => '0');
		elsif (rising_edge(clk)) then
			q <= d;
		end if;
	end process;
end architecture;