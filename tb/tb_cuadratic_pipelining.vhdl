library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb_cuadratic_pipelining is
end entity;

architecture behave of tb_cuadratic_pipelining is

  component cuadratic_pipelining
    port (
      clk   : in  std_logic;
      reset : in  std_logic;
      x     : in  std_logic_vector(7 downto 0);
      a     : in  std_logic_vector(7 downto 0);
      b     : in  std_logic_vector(7 downto 0);
      c     : in  std_logic_vector(7 downto 0);
      y     : out std_logic_vector(15 downto 0)
    );
  end component;

  signal clk   : std_logic := '0';
  signal reset : std_logic := '1';
  signal x, a, b, c : std_logic_vector(7 downto 0) := (others => '0');
  signal y        : std_logic_vector(15 downto 0);

  constant CLK_PERIOD : time := 20 ns;
  constant LATENCY : integer := 5;

  file file_out : text open write_mode is "salida_y.txt";

begin

  clk_process : process
  begin
    while true loop
      clk <= '0'; wait for CLK_PERIOD/2;
      clk <= '1'; wait for CLK_PERIOD/2;
    end loop;
  end process;

  uut: cuadratic_pipelining
    port map (
      clk   => clk,
      reset => reset,
      x     => x,
      a     => a,
      b     => b,
      c     => c,
      y     => y
    );

  stim_proc : process
    variable xv, av, bv, cv : signed(7 downto 0);
    variable y_expected     : signed(15 downto 0);
    variable valor_y        : integer;
    variable linea          : line;
  begin
    wait for 40 ns;
    reset <= '0';

    -- Coeficientes de ejemplo: a=1, b=0, c=0 => y = x^2
    av := to_signed(2, 8);
    bv := to_signed(3, 8);
    cv := to_signed(1, 8);

    a <= std_logic_vector(av);
    b <= std_logic_vector(bv);
    c <= std_logic_vector(cv);

    -- Rango de x desde -8 hasta +8
    for xi in -8 to 8 loop
      xv := to_signed(xi, 8);
      x <= std_logic_vector(xv);

      wait for LATENCY * CLK_PERIOD;

      valor_y := to_integer(signed(y));

      -- Escribir en archivo: x y
      write(linea, integer'image(xi));
      write(linea, string'(" "));
      write(linea, integer'image(valor_y));
      writeline(file_out, linea);

      -- Mensaje en consola
      report "x=" & integer'image(xi) & " y=" & integer'image(valor_y);
    end loop;

    report "Simulación terminada correctamente" severity note;
    wait;
  end process;

end architecture;














