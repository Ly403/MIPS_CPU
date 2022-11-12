library verilog;
use verilog.vl_types.all;
entity seg7x16 is
    port(
        Q               : out    vl_logic_vector(6 downto 0);
        o_sel_OBUF      : out    vl_logic_vector(7 downto 0);
        D               : in     vl_logic_vector(31 downto 0);
        clk_in_IBUF_BUFG: in     vl_logic;
        rst_IBUF        : in     vl_logic
    );
end seg7x16;
