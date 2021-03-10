library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity greyscale_norm_v1_0 is
  generic (
    -- Parameters of Axi Slave Bus Interface S_AXI_CTRL
    C_S_AXI_CTRL_DATA_WIDTH    : integer := 32;
    C_S_AXI_CTRL_ADDR_WIDTH    : integer := 8;

    -- Parameters of Axi Slave Bus Interface S_AXIS_VIDEO
    C_S_AXIS_VIDEO_TDATA_WIDTH : integer := 32;

    -- Parameters of Axi Master Bus Interface M_AXIS_VIDEO
    C_M_AXIS_VIDEO_TDATA_WIDTH : integer := 32
    );
  port (
--    -- Ports of Axi Slave Bus Interface S_AXI_CTRL
--    s_axi_ctrl_aclk     : in  std_logic;
--    s_axi_ctrl_aresetn  : in  std_logic;
--    s_axi_ctrl_awaddr   : in  std_logic_vector(C_S_AXI_CTRL_ADDR_WIDTH-1 downto 0);
--    s_axi_ctrl_awprot   : in  std_logic_vector(2 downto 0);
--    s_axi_ctrl_awvalid  : in  std_logic;
--    s_axi_ctrl_awready  : out std_logic;
--    s_axi_ctrl_wdata    : in  std_logic_vector(C_S_AXI_CTRL_DATA_WIDTH-1 downto 0);
--    s_axi_ctrl_wstrb    : in  std_logic_vector((C_S_AXI_CTRL_DATA_WIDTH/8)-1 downto 0);
--    s_axi_ctrl_wvalid   : in  std_logic;
--    s_axi_ctrl_wready   : out std_logic;
--    s_axi_ctrl_bresp    : out std_logic_vector(1 downto 0);
--    s_axi_ctrl_bvalid   : out std_logic;
--    s_axi_ctrl_bready   : in  std_logic;
--    s_axi_ctrl_araddr   : in  std_logic_vector(C_S_AXI_CTRL_ADDR_WIDTH-1 downto 0);
--    s_axi_ctrl_arprot   : in  std_logic_vector(2 downto 0);
--    s_axi_ctrl_arvalid  : in  std_logic;
--    s_axi_ctrl_arready  : out std_logic;
--    s_axi_ctrl_rdata    : out std_logic_vector(C_S_AXI_CTRL_DATA_WIDTH-1 downto 0);
--    s_axi_ctrl_rresp    : out std_logic_vector(1 downto 0);
--    s_axi_ctrl_rvalid   : out std_logic;
--    s_axi_ctrl_rready   : in  std_logic;

    -- Ports of Axi Slave Bus Interface S_AXIS_VIDEO
    s_axis_video_aclk    : in  std_logic;
    s_axis_video_aresetn : in  std_logic;
    s_axis_video_tready  : out std_logic;
    s_axis_video_tdata   : in  std_logic_vector(C_S_AXIS_VIDEO_TDATA_WIDTH-1 downto 0);
    s_axis_video_tstrb   : in  std_logic_vector((C_S_AXIS_VIDEO_TDATA_WIDTH/8)-1 downto 0);
    s_axis_video_tlast   : in  std_logic;
    s_axis_video_tvalid  : in  std_logic;
    s_axis_video_tuser   : in  std_logic_vector(0 downto 0);

    -- Ports of Axi Master Bus Interface M_AXIS_VIDEO
    m_axis_video_aclk    : in  std_logic;
    m_axis_video_aresetn : in  std_logic;
    m_axis_video_tvalid  : out std_logic;
    m_axis_video_tdata   : out std_logic_vector(C_M_AXIS_VIDEO_TDATA_WIDTH-1 downto 0);
    m_axis_video_tstrb   : out std_logic_vector((C_M_AXIS_VIDEO_TDATA_WIDTH/8)-1 downto 0);
    m_axis_video_tlast   : out std_logic;
    m_axis_video_tready  : in  std_logic;
    m_axis_video_tuser   : out  std_logic_vector(0 downto 0)
    );
end greyscale_norm_v1_0;

architecture arch_imp of greyscale_norm_v1_0 is

  signal tdata_r_0 : std_logic_vector(C_M_AXIS_VIDEO_TDATA_WIDTH-1 downto 0);
  signal valid_r_0 : std_logic;
  signal tstrb_r_0 : std_logic_vector((C_M_AXIS_VIDEO_TDATA_WIDTH/8)-1 downto 0);
  signal tlast_r_0 : std_logic;
  signal tuser_r_0 : std_logic_vector(0 downto 0);

  signal tdata_r_1 : std_logic_vector(C_M_AXIS_VIDEO_TDATA_WIDTH-1 downto 0);
  signal valid_r_1 : std_logic;
  signal tstrb_r_1 : std_logic_vector((C_M_AXIS_VIDEO_TDATA_WIDTH/8)-1 downto 0);
  signal tlast_r_1 : std_logic;
  signal tuser_r_1 : std_logic_vector(0 downto 0);

--  -----------------------------------------------------
--  -- Components
--  -----------------------------------------------------
--  -- component declaration
--  component greyscale_norm_v1_0_S_AXI_CTRL is
--    generic (
--      C_S_AXI_DATA_WIDTH : integer := 32;
--      C_S_AXI_ADDR_WIDTH : integer := 8
--      );
--    port (
--      S_AXI_ACLK    : in  std_logic;
--      S_AXI_ARESETN : in  std_logic;
--      S_AXI_AWADDR  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
--      S_AXI_AWPROT  : in  std_logic_vector(2 downto 0);
--      S_AXI_AWVALID : in  std_logic;
--      S_AXI_AWREADY : out std_logic;
--      S_AXI_WDATA   : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
--      S_AXI_WSTRB   : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
--      S_AXI_WVALID  : in  std_logic;
--      S_AXI_WREADY  : out std_logic;
--      S_AXI_BRESP   : out std_logic_vector(1 downto 0);
--      S_AXI_BVALID  : out std_logic;
--      S_AXI_BREADY  : in  std_logic;
--      S_AXI_ARADDR  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
--      S_AXI_ARPROT  : in  std_logic_vector(2 downto 0);
--      S_AXI_ARVALID : in  std_logic;
--      S_AXI_ARREADY : out std_logic;
--      S_AXI_RDATA   : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
--      S_AXI_RRESP   : out std_logic_vector(1 downto 0);
--      S_AXI_RVALID  : out std_logic;
--      S_AXI_RREADY  : in  std_logic
--      );
--  end component greyscale_norm_v1_0_S_AXI_CTRL;


  function normalize_pixel(data : std_logic_vector) return std_logic_vector is
    variable retval_v : std_logic_vector(31 downto 0) := (others => '0');

    variable red_v    : unsigned(11 downto 0) := (others => '0');
    variable green_v  : unsigned(11 downto 0) := (others => '0');
    variable blue_v   : unsigned(11 downto 0) := (others => '0');

    variable avg_v    : unsigned(11 downto 0) := (others => '0');

  begin
    
    red_v(9 downto 0)   := unsigned(data(29 downto 20));
    green_v(9 downto 0) := unsigned(data(19 downto 10));
    blue_v(9 downto 0)  := unsigned(data( 9 downto  0));

    -- Sum parts
    avg_v   := red_v + green_v + blue_v;

    -- Divide by 3 (find average)
    avg_v   := avg_v / 3;

    -- Get rid of bottom two bits to normalize to 8 bits
    -- retval_v(7 downto 0) := std_logic_vector(avg_v(11 downto 4));
    retval_v(7 downto 0) := std_logic_vector(avg_v(7 downto 0));

    return std_logic_vector(retval_v);

  end function;

begin

  s_axis_video_tready <= '1'; -- Always ready
  m_axis_video_tdata  <= tdata_r_1;
  m_axis_video_tstrb  <= tstrb_r_1;
  m_axis_video_tlast  <= tlast_r_1;
  m_axis_video_tvalid <= valid_r_1;
  m_axis_video_tuser  <= tuser_r_1;

  -- Shift in data and perform normalization
  input_proc: process(s_axis_video_aclk)
  begin
    if rising_edge(s_axis_video_aclk) then
      if s_axis_video_aresetn = '0' then
        tdata_r_0 <= (others => '0');
        valid_r_0 <= '0';
        tlast_r_0 <= '0';
        tstrb_r_0 <= (others => '0');
        tuser_r_0 <= (others => '0');

        tdata_r_1 <= (others => '0');
        valid_r_1 <= '0';
        tlast_r_1 <= '0';
        tstrb_r_1 <= (others => '0');
        tuser_r_1 <= (others => '0');

      else
        tdata_r_0 <= s_axis_video_tdata;
        valid_r_0 <= s_axis_video_tvalid;
        tlast_r_0 <= s_axis_video_tlast;
        tstrb_r_0 <= s_axis_video_tstrb;
        tuser_r_0 <= s_axis_video_tuser;

        tdata_r_1 <= normalize_pixel(tdata_r_0);
        valid_r_1 <= valid_r_0;
        tlast_r_1 <= tlast_r_0;
        tstrb_r_1 <= tstrb_r_0;
        tuser_r_1 <= tuser_r_0;

      end if;
    end if;
  end process;


--  -----------------------------------------------------
--  -- Components
--  -----------------------------------------------------
--  -- Instantiation of Axi Bus Interface S_AXI_CTRL
--  greyscale_norm_v1_0_S_AXI_CTRL_inst : greyscale_norm_v1_0_S_AXI_CTRL
--    generic map (
--      C_S_AXI_DATA_WIDTH	=> C_S_AXI_CTRL_DATA_WIDTH,
--      C_S_AXI_ADDR_WIDTH	=> C_S_AXI_CTRL_ADDR_WIDTH
--      )
--    port map (
--      S_AXI_ACLK	=> s_axi_ctrl_aclk,
--      S_AXI_ARESETN	=> s_axi_ctrl_aresetn,
--      S_AXI_AWADDR	=> s_axi_ctrl_awaddr,
--      S_AXI_AWPROT	=> s_axi_ctrl_awprot,
--      S_AXI_AWVALID	=> s_axi_ctrl_awvalid,
--      S_AXI_AWREADY	=> s_axi_ctrl_awready,
--      S_AXI_WDATA	=> s_axi_ctrl_wdata,
--      S_AXI_WSTRB	=> s_axi_ctrl_wstrb,
--      S_AXI_WVALID	=> s_axi_ctrl_wvalid,
--      S_AXI_WREADY	=> s_axi_ctrl_wready,
--      S_AXI_BRESP	=> s_axi_ctrl_bresp,
--      S_AXI_BVALID	=> s_axi_ctrl_bvalid,
--      S_AXI_BREADY	=> s_axi_ctrl_bready,
--      S_AXI_ARADDR	=> s_axi_ctrl_araddr,
--      S_AXI_ARPROT	=> s_axi_ctrl_arprot,
--      S_AXI_ARVALID	=> s_axi_ctrl_arvalid,
--      S_AXI_ARREADY	=> s_axi_ctrl_arready,
--      S_AXI_RDATA	=> s_axi_ctrl_rdata,
--      S_AXI_RRESP	=> s_axi_ctrl_rresp,
--      S_AXI_RVALID	=> s_axi_ctrl_rvalid,
--      S_AXI_RREADY	=> s_axi_ctrl_rready
--      );

end arch_imp;
