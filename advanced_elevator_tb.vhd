library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity advanced_elevator_tb is
end advanced_elevator_tb;

architecture testbench of advanced_elevator_tb is
    signal  clk                             :   std_logic;
    signal  rst                             :   std_logic;
    signal  floorbutton1                    :   std_logic;
    signal  floorbutton2                    :   std_logic;
    signal  floorbutton3                    :   std_logic;
    signal  floorbutton4                    :   std_logic;
    signal  callrequest1                    :   std_logic;
    signal  callrequest2U                   :   std_logic;
    signal  callrequest2D                   :   std_logic;
    signal  callrequest3U                   :   std_logic;
    signal  callrequest3D                   :   std_logic;
    signal  callrequest4                    :   std_logic;
    signal  dooropenbutton                  :   std_logic;
    signal  doorclosebutton                 :   std_logic;
    signal  doorsensor                      :   std_logic;
    signal  door_open_out                   :   std_logic;
    signal  elevator_moving_direction_out   :   std_logic_vector(1 downto 0);
    signal  elevator_current_floor_out      :   unsigned(1 downto 0);
    constant period : time := 10 ns;

    
    component advanced_elevator_control is
        port(
            clk                             :   in  std_logic;
            rst                             :   in  std_logic;
            floorbutton1                    :   in  std_logic;
            floorbutton2                    :   in  std_logic;
            floorbutton3                    :   in  std_logic;
            floorbutton4                    :   in  std_logic;
            callrequest1                    :   in  std_logic;
            callrequest2U                   :   in  std_logic;
            callrequest2D                   :   in  std_logic;
            callrequest3U                   :   in  std_logic;
            callrequest3D                   :   in  std_logic;
            callrequest4                    :   in  std_logic;
            dooropenbutton                  :   in  std_logic;
            doorclosebutton                 :   in  std_logic;
            doorsensor                      :   in  std_logic;
            door_open_out                   :   out std_logic;
            elevator_moving_direction_out   :   out std_logic_vector(1 downto 0);
            elevator_current_floor_out      :   out unsigned(1 downto 0)
        );
    end component advanced_elevator_control;
begin
    elevator    :   advanced_elevator_control
    port map (
        clk                             =>   clk,
        rst                             =>   rst,
        floorbutton1                    =>   floorbutton1,
        floorbutton2                    =>   floorbutton2,
        floorbutton3                    =>   floorbutton3,
        floorbutton4                    =>   floorbutton4,
        callrequest1                    =>   callrequest1,
        callrequest2U                   =>   callrequest2U,
        callrequest2D                   =>   callrequest2D,
        callrequest3U                   =>   callrequest3U,
        callrequest3D                   =>   callrequest3D,
        callrequest4                    =>   callrequest4,
        dooropenbutton                  =>   dooropenbutton,
        doorclosebutton                 =>   doorclosebutton,
        doorsensor                      =>   doorsensor,
        door_open_out                   =>   door_open_out,
        elevator_moving_direction_out   =>   elevator_moving_direction_out,
        elevator_current_floor_out      =>   elevator_current_floor_out
    );

    clock_process : process
    begin
        clk <= '0';
        wait for period/2;
        clk <= '1';
        wait for period/2;
    end process;

    test_process  : process
    begin
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        floorbutton1    <= '0';
        floorbutton2    <= '0';
        floorbutton3    <= '0';
        floorbutton4    <= '1';         
        callrequest1    <= '0';     
        callrequest2U   <= '0';
        callrequest2D   <= '0'; 
        callrequest3U   <= '0'; 
        callrequest3D   <= '0';
        callrequest4    <= '0';
        dooropenbutton  <= '0';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until door_open_out = '1';
        floorbutton1    <= '0';
        floorbutton2    <= '0';
        floorbutton3    <= '0';
        floorbutton4    <= '0';         
        callrequest1    <= '0';     
        callrequest2U   <= '0';
        callrequest2D   <= '0'; 
        callrequest3U   <= '0'; 
        callrequest3D   <= '0';
        callrequest4    <= '0';
        dooropenbutton  <= '0';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until door_open_out = '0';
        floorbutton1    <= '1';
        floorbutton2    <= '0';
        floorbutton3    <= '0';
        floorbutton4    <= '0';         
        callrequest1    <= '0';     
        callrequest2U   <= '0';
        callrequest2D   <= '0'; 
        callrequest3U   <= '0'; 
        callrequest3D   <= '0';
        callrequest4    <= '0';
        dooropenbutton  <= '0';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until elevator_current_floor_out = "01";
        floorbutton1    <= '1';
        floorbutton2    <= '0';
        floorbutton3    <= '0';
        floorbutton4    <= '0';         
        callrequest1    <= '0';     
        callrequest2U   <= '0';
        callrequest2D   <= '0'; 
        callrequest3U   <= '0'; 
        callrequest3D   <= '0';
        callrequest4    <= '1';
        dooropenbutton  <= '0';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until door_open_out = '1';
        floorbutton1    <= '0';
        floorbutton2    <= '0';
        floorbutton3    <= '0';
        floorbutton4    <= '0';         
        callrequest1    <= '0';     
        callrequest2U   <= '0';
        callrequest2D   <= '0'; 
        callrequest3U   <= '0'; 
        callrequest3D   <= '0';
        callrequest4    <= '1';
        dooropenbutton  <= '0';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until door_open_out = '0';
        floorbutton1    <= '0';
        floorbutton2    <= '0';
        floorbutton3    <= '0';
        floorbutton4    <= '0';         
        callrequest1    <= '0';     
        callrequest2U   <= '0';
        callrequest2D   <= '0'; 
        callrequest3U   <= '0'; 
        callrequest3D   <= '0';
        callrequest4    <= '1';
        dooropenbutton  <= '0';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until door_open_out = '1';
        floorbutton1    <= '0';
        floorbutton2    <= '0';
        floorbutton3    <= '0';
        floorbutton4    <= '0';         
        callrequest1    <= '0';     
        callrequest2U   <= '0';
        callrequest2D   <= '0'; 
        callrequest3U   <= '0'; 
        callrequest3D   <= '0';
        callrequest4    <= '0';
        dooropenbutton  <= '0';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until door_open_out = '0';
        floorbutton1    <= '0';
        floorbutton2    <= '0';
        floorbutton3    <= '0';
        floorbutton4    <= '0';   
        callrequest1    <= '0';     
        callrequest2U   <= '0';
        callrequest2D   <= '0'; 
        callrequest3U   <= '0'; 
        callrequest3D   <= '0';
        callrequest4    <= '0';
        dooropenbutton  <= '1';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until door_open_out = '1';
        floorbutton1    <= '0';
        floorbutton2    <= '0';
        floorbutton3    <= '0';
        floorbutton4    <= '0';         
        callrequest1    <= '0';     
        callrequest2U   <= '0';
        callrequest2D   <= '0'; 
        callrequest3U   <= '0'; 
        callrequest3D   <= '0';
        callrequest4    <= '0';
        dooropenbutton  <= '0';  
        doorclosebutton <= '0';   
        doorsensor      <= '1';
        wait for 200 ns;
        floorbutton1    <= '0';
        floorbutton2    <= '0';
        floorbutton3    <= '0';
        floorbutton4    <= '0';         
        callrequest1    <= '0';     
        callrequest2U   <= '0';
        callrequest2D   <= '0'; 
        callrequest3U   <= '0'; 
        callrequest3D   <= '0';
        callrequest4    <= '0';
        dooropenbutton  <= '0';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until door_open_out = '0';
        floorbutton1    <= '1';
        floorbutton2    <= '0';
        floorbutton3    <= '0';
        floorbutton4    <= '0';         
        callrequest1    <= '0';     
        callrequest2U   <= '0';
        callrequest2D   <= '0'; 
        callrequest3U   <= '0'; 
        callrequest3D   <= '0';
        callrequest4    <= '0';
        dooropenbutton  <= '0';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until elevator_current_floor_out = "10";
        floorbutton1    <= '1';
        floorbutton2    <= '0';
        floorbutton3    <= '0';
        floorbutton4    <= '0';         
        callrequest1    <= '0';     
        callrequest2U   <= '0';
        callrequest2D   <= '1'; 
        callrequest3U   <= '0'; 
        callrequest3D   <= '0';
        callrequest4    <= '0';
        dooropenbutton  <= '0';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until door_open_out = '1';
        floorbutton1    <= '1';
        floorbutton2    <= '0';
        floorbutton3    <= '0';
        floorbutton4    <= '0';         
        callrequest1    <= '0';     
        callrequest2U   <= '0';
        callrequest2D   <= '0'; 
        callrequest3U   <= '0'; 
        callrequest3D   <= '0';
        callrequest4    <= '0';
        dooropenbutton  <= '0';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until door_open_out = '1';
        floorbutton1    <= '0';
        floorbutton2    <= '0';
        floorbutton3    <= '0';
        floorbutton4    <= '0';         
        callrequest1    <= '0';     
        callrequest2U   <= '0';
        callrequest2D   <= '0'; 
        callrequest3U   <= '0'; 
        callrequest3D   <= '0';
        callrequest4    <= '0';
        dooropenbutton  <= '0';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until door_open_out = '0';
        floorbutton1    <= '0';
        floorbutton2    <= '0';
        floorbutton3    <= '0';
        floorbutton4    <= '1';         
        callrequest1    <= '0';     
        callrequest2U   <= '0';
        callrequest2D   <= '0'; 
        callrequest3U   <= '0'; 
        callrequest3D   <= '0';
        callrequest4    <= '0';
        dooropenbutton  <= '0';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until elevator_current_floor_out = "01";
        floorbutton1    <= '0';
        floorbutton2    <= '0';
        floorbutton3    <= '0';
        floorbutton4    <= '1';         
        callrequest1    <= '0';     
        callrequest2U   <= '0';
        callrequest2D   <= '0'; 
        callrequest3U   <= '0'; 
        callrequest3D   <= '1';
        callrequest4    <= '0';
        dooropenbutton  <= '0';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until door_open_out = '1';
        floorbutton1    <= '0';
        floorbutton2    <= '0';
        floorbutton3    <= '0';
        floorbutton4    <= '0';         
        callrequest1    <= '0';     
        callrequest2U   <= '0';
        callrequest2D   <= '0'; 
        callrequest3U   <= '0'; 
        callrequest3D   <= '1';
        callrequest4    <= '0';
        dooropenbutton  <= '0';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until door_open_out = '1';
        floorbutton1    <= '0';
        floorbutton2    <= '0';
        floorbutton3    <= '0';
        floorbutton4    <= '0';         
        callrequest1    <= '0';     
        callrequest2U   <= '0';
        callrequest2D   <= '0'; 
        callrequest3U   <= '0'; 
        callrequest3D   <= '0';
        callrequest4    <= '0';
        dooropenbutton  <= '0';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until door_open_out = '0';
    end process;
        
end testbench;