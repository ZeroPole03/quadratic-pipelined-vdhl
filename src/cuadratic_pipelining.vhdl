library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cuadratic_pipelining is
	port (
			clk, reset : in std_logic;
			x : in std_logic_vector(7 downto 0);
			y : out std_logic_vector(15 downto 0);
			a : in std_logic_vector(7 downto 0);
			b : in std_logic_vector(7 downto 0);
			c : in std_logic_vector(7 downto 0)
		);
end entity;


architecture behave of cuadratic_pipelining is
	--seniales de 8 bits
	signal xp1, xf1, xf2, xf3, cq, cq1, cq2, cq3, bq : std_logic_vector(7 downto 0);
	-- seniales de 16 bits 
	signal xp2, xp3, xp4, xp5, y_out : std_logic_vector(15 downto 0);
	-- seniales de 24 bits
	signal xp6, xp7 : std_logic_vector(23 downto 0);
	signal y_temp : signed(23 downto 0);

	-- Registro de 8 bits
	component reg_8b
		port (
			clk, reset : in std_logic;
			d : in std_logic_vector(7 downto 0);
			q : out std_logic_vector(7 downto 0)
		);
	end component;

	-- Registros de 16 bits
	component reg_16b
		port (
			clk, reset : in std_logic;
			d : in std_logic_vector(15 downto 0);
			q : out std_logic_vector(15 downto 0)
		);
	end component;

	-- Registros de 24 bits

	component reg_24b
		port (
			clk, reset : in std_logic;
			d : in std_logic_vector(23 downto 0);
			q : out std_logic_vector(23 downto 0)
		);
	end component;
begin
	-- Salida y entrada del producto de x * b
	xp1 <= x;
	xp2 <= std_logic_vector(signed(xp1) * signed(a));
	reg1 : reg_16b
	port map (
			clk => clk,
			reset => reset,
			d => xp2,
			q => xp3
	);

	-- Conexiones del feedforward de x;
	xf1 <= x;
	reg2 : reg_8b
	port map(
		d => xf1,
		clk => clk,
		reset => reset,
		q => xf2
	);
	-- conexiones al registro de b
	reg3 : reg_8b
	port map(
		d => b,
		clk => clk,
		reset => reset,
		q => bq
	);
	-- Conexiones de registros para la primera suma
	xp4 <= std_logic_vector(signed(xp3) + resize(signed(bq), 16));
	-- Registro que espera a la suma
	reg4 : reg_16b
	port map(
		clk => clk,
		reset => reset,
		d => xp4,
		q => xp5
	);

	-- segunda etapa de feedforward de x
	reg5 : reg_8b
	port map(
			clk => clk,
			reset => reset,
			d => xf2,
			q => xf3
	);

	-- Tercera etapa de registros y segundo operador de producto
	xp6 <= std_logic_vector(signed(xp5) * signed(xf3));
	reg6 : reg_24b
	port map(
			clk => clk,
			reset => reset, 
			d => xp6,
			q => xp7
	);

	-- conexiones a registros de c
	reg7 : reg_8b
	port map (
			clk => clk,
			reset => reset,
			d => c,
			q => cq
	);
	reg8 : reg_8b
	port map (
			clk => clk,
			reset => reset,
			d => cq,
			q => cq1
	);
	reg9 : reg_8b
	port map (
			clk => clk,
			reset => reset,
			d => cq1,
			q => cq2
	);
	reg10 : reg_8b
	port map (
			clk => clk,
			reset => reset,
			d => cq2,
			q => cq3
	);


	y_temp <= resize(signed(cq3), 24) + signed(xp7);
	--registro a la salida
	reg11 : reg_16b
	port map(
			clk => clk,
			reset => reset,
			d => std_logic_vector(y_temp(15 downto 0)),
			q => y_out
		);
	-- logica de salida
	y <= y_out;
end architecture;



