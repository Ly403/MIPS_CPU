library verilog;
use verilog.vl_types.all;
entity regfile is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        write           : in     vl_logic;
        write_addr      : in     vl_logic_vector(4 downto 0);
        write_data      : in     vl_logic_vector(31 downto 0);
        ra              : in     vl_logic;
        addra           : in     vl_logic_vector(4 downto 0);
        dataa           : out    vl_logic_vector(31 downto 0);
        rb              : in     vl_logic;
        addrb           : in     vl_logic_vector(4 downto 0);
        datab           : out    vl_logic_vector(31 downto 0)
    );
end regfile;
