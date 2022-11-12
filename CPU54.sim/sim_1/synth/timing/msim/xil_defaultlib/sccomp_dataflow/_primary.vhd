library verilog;
use verilog.vl_types.all;
entity sccomp_dataflow is
    port(
        clk_in          : in     vl_logic;
        reset           : in     vl_logic;
        inst            : out    vl_logic_vector(31 downto 0);
        pc              : out    vl_logic_vector(31 downto 0)
    );
end sccomp_dataflow;
