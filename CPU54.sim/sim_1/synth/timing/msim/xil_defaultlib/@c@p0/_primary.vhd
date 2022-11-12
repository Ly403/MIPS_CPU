library verilog;
use verilog.vl_types.all;
entity CP0 is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        we              : in     vl_logic;
        waddr           : in     vl_logic_vector(4 downto 0);
        raddr           : in     vl_logic_vector(4 downto 0);
        data            : in     vl_logic_vector(31 downto 0);
        int             : in     vl_logic_vector(5 downto 0);
        excepttype      : in     vl_logic_vector(31 downto 0);
        current_inst_addr: in     vl_logic_vector(31 downto 0);
        is_in_delay_slot: in     vl_logic;
        o_data          : out    vl_logic_vector(31 downto 0);
        o_count         : out    vl_logic_vector(31 downto 0);
        o_compare       : out    vl_logic_vector(31 downto 0);
        o_status        : out    vl_logic_vector(31 downto 0);
        o_cause         : out    vl_logic_vector(31 downto 0);
        o_epc           : out    vl_logic_vector(31 downto 0);
        o_config        : out    vl_logic_vector(31 downto 0);
        o_prid          : out    vl_logic_vector(31 downto 0);
        o_badVAddr      : out    vl_logic_vector(31 downto 0);
        o_timer_int     : out    vl_logic
    );
end CP0;
