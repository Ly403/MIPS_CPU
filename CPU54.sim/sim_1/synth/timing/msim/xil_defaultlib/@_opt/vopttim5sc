library verilog;
use verilog.vl_types.all;
entity DIV is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        signed_div      : in     vl_logic;
        opdata1         : in     vl_logic_vector(31 downto 0);
        opdata2         : in     vl_logic_vector(31 downto 0);
        start           : in     vl_logic;
        annul           : in     vl_logic;
        result          : out    vl_logic_vector(63 downto 0);
        ready           : out    vl_logic
    );
end DIV;
