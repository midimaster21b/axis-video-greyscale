library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity greyscale_norm is
  generic (
    AXIS_VIDEO_DATA_WIDTH_G : integer := 32
    );
  port (
    -- Ports of Axi Slave Bus Interface S_AXIS_VIDEO
    s_axis_video_aclk    : in  std_logic;
    s_axis_video_aresetn : in  std_logic;
    s_axis_video_tready  : out std_logic;
    s_axis_video_tdata   : in  std_logic_vector(AXIS_VIDEO_DATA_WIDTH_G-1 downto 0);
    s_axis_video_tstrb   : in  std_logic_vector((AXIS_VIDEO_DATA_WIDTH_G/8)-1 downto 0);
    s_axis_video_tlast   : in  std_logic;
    s_axis_video_tvalid  : in  std_logic;
    s_axis_video_tuser   : in  std_logic_vector(0 downto 0);

    -- Ports of Axi Master Bus Interface M_AXIS_VIDEO
    m_axis_video_aclk    : in  std_logic;
    m_axis_video_aresetn : in  std_logic;
    m_axis_video_tvalid  : out std_logic;
    m_axis_video_tdata   : out std_logic_vector(AXIS_VIDEO_DATA_WIDTH_G-1 downto 0);
    m_axis_video_tstrb   : out std_logic_vector((AXIS_VIDEO_DATA_WIDTH_G/8)-1 downto 0);
    m_axis_video_tlast   : out std_logic;
    m_axis_video_tready  : in  std_logic;
    m_axis_video_tuser   : out  std_logic_vector(0 downto 0)
    );
end greyscale_norm;

architecture rtl of greyscale_norm is

  signal tdata_r_0 : std_logic_vector(AXIS_VIDEO_DATA_WIDTH_G-1 downto 0);
  signal valid_r_0 : std_logic;
  signal tstrb_r_0 : std_logic_vector((AXIS_VIDEO_DATA_WIDTH_G/8)-1 downto 0);
  signal tlast_r_0 : std_logic;
  signal tuser_r_0 : std_logic_vector(0 downto 0);

  signal tdata_r_1 : std_logic_vector(AXIS_VIDEO_DATA_WIDTH_G-1 downto 0);
  signal valid_r_1 : std_logic;
  signal tstrb_r_1 : std_logic_vector((AXIS_VIDEO_DATA_WIDTH_G/8)-1 downto 0);
  signal tlast_r_1 : std_logic;
  signal tuser_r_1 : std_logic_vector(0 downto 0);


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
end rtl;
