library verilog;
use verilog.vl_types.all;
entity ID_EX is
    port(
        rst             : in     vl_logic;
        clk             : in     vl_logic;
        id_alusel       : in     vl_logic_vector(2 downto 0);
        id_aluop        : in     vl_logic_vector(7 downto 0);
        id_rega         : in     vl_logic_vector(31 downto 0);
        id_regb         : in     vl_logic_vector(31 downto 0);
        id_wd           : in     vl_logic_vector(4 downto 0);
        id_wreg         : in     vl_logic;
        stall           : in     vl_logic_vector(5 downto 0);
        id_link_addr    : in     vl_logic_vector(31 downto 0);
        id_is_in_delay_slot: in     vl_logic;
        next_inst_in_delay_slot: in     vl_logic;
        id_inst         : in     vl_logic_vector(31 downto 0);
        flush           : in     vl_logic;
        id_current_inst_addr: in     vl_logic_vector(31 downto 0);
        id_excepttype   : in     vl_logic_vector(31 downto 0);
        ex_alusel       : out    vl_logic_vector(2 downto 0);
        ex_aluop        : out    vl_logic_vector(7 downto 0);
        ex_rega         : out    vl_logic_vector(31 downto 0);
        ex_regb         : out    vl_logic_vector(31 downto 0);
        ex_wd           : out    vl_logic_vector(4 downto 0);
        ex_wreg         : out    vl_logic;
        ex_link_addr    : out    vl_logic_vector(31 downto 0);
        ex_in_delay_slot: out    vl_logic;
        o_is_in_dalay_slot: out    vl_logic;
        ex_inst         : out    vl_logic_vector(31 downto 0);
        ex_current_inst_addr: out    vl_logic_vector(31 downto 0);
        ex_excepttype   : out    vl_logic_vector(31 downto 0)
    );
end ID_EX;
