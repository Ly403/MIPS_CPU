library verilog;
use verilog.vl_types.all;
entity PC is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        stall           : in     vl_logic_vector(5 downto 0);
        branch_flag     : in     vl_logic;
        branch_address  : in     vl_logic_vector(31 downto 0);
        flush           : in     vl_logic;
        new_pc          : in     vl_logic_vector(31 downto 0);
        pc              : out    vl_logic_vector(31 downto 0);
        cs              : out    vl_logic
    );
end PC;
