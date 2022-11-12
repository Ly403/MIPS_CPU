library verilog;
use verilog.vl_types.all;
entity divide_clk is
    port(
        clk             : in     vl_logic;
        stall           : in     vl_logic_vector(5 downto 0);
        clk1            : out    vl_logic;
        clk2            : out    vl_logic;
        clk3            : out    vl_logic;
        clk4            : out    vl_logic;
        clk5            : out    vl_logic
    );
end divide_clk;
