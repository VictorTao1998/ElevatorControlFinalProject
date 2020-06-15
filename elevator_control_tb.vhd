library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity elevator_tb is
end elevator_tb;

architecture testbench of elevator_tb is
    signal  clk                             :   std_logic;
    signal  rst                             :   std_logic;
    signal  floorbutton1                    :   std_logic;
    signal  floorbutton2                    :   std_logic;
    signal  callrequest1                    :   std_logic;
    signal  callrequest2                    :   std_logic;
    signal  dooropenbutton                  :   std_logic;
    signal  doorclosebutton                 :   std_logic;
    signal  doorsensor                      :   std_logic;
    signal  door_open_out                   :   std_logic;
    signal  elevator_moving_direction_out   :   std_logic_vector(1 downto 0);
    signal  elevator_current_floor_out      :   std_logic;
    constant period : time := 10 ns;

    
    component elevator_control is
        port(
        clk                             :   in  std_logic;
        rst                             :   in  std_logic;
        floorbutton1                    :   in  std_logic;
        floorbutton2                    :   in  std_logic;
        callrequest1                    :   in  std_logic;
        callrequest2                    :   in  std_logic;
        dooropenbutton                  :   in  std_logic;
        doorclosebutton                 :   in  std_logic;
        doorsensor                      :   in  std_logic;
        door_open_out                   :   out std_logic;
        elevator_moving_direction_out   :   out std_logic_vector(1 downto 0);
        elevator_current_floor_out      :   out std_logic
    );
    end component elevator_control;
begin
    elevator    :   elevator_control
    port map (
        clk                             =>   clk,
        rst                             =>   rst,
        floorbutton1                    =>   floorbutton1,
        floorbutton2                    =>   floorbutton2,
        callrequest1                    =>   callrequest1,
        callrequest2                    =>   callrequest2,
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
        floorbutton2    <= '1';         
        callrequest1    <= '0';     
        callrequest2    <= '0'; 
        dooropenbutton  <= '0';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until door_open_out = '1';
        floorbutton1    <= '0';
        floorbutton2    <= '0';         
        callrequest1    <= '0';     
        callrequest2    <= '0'; 
        dooropenbutton  <= '0';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until door_open_out = '0';
        floorbutton1    <= '0';
        floorbutton2    <= '0';         
        callrequest1    <= '1';     
        callrequest2    <= '0'; 
        dooropenbutton  <= '0';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until door_open_out = '1';
        floorbutton1    <= '0';
        floorbutton2    <= '0';         
        callrequest1    <= '0';     
        callrequest2    <= '0'; 
        dooropenbutton  <= '0';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until door_open_out = '0';
        floorbutton1    <= '0';
        floorbutton2    <= '1';         
        callrequest1    <= '0';     
        callrequest2    <= '0'; 
        dooropenbutton  <= '1';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until door_open_out = '1';
        floorbutton1    <= '0';
        floorbutton2    <= '1';         
        callrequest1    <= '0';     
        callrequest2    <= '0'; 
        dooropenbutton  <= '0';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until door_open_out = '1';
        floorbutton1    <= '0';
        floorbutton2    <= '0';         
        callrequest1    <= '0';     
        callrequest2    <= '0'; 
        dooropenbutton  <= '0';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until door_open_out = '0';
        floorbutton1    <= '0';
        floorbutton2    <= '0';         
        callrequest1    <= '0';     
        callrequest2    <= '1'; 
        dooropenbutton  <= '0';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until door_open_out = '1';
        floorbutton1    <= '0';
        floorbutton2    <= '0';         
        callrequest1    <= '0';     
        callrequest2    <= '0'; 
        dooropenbutton  <= '0';  
        doorclosebutton <= '0';   
        doorsensor      <= '1';
        wait for 200 ns;
        floorbutton1    <= '0';
        floorbutton2    <= '0';         
        callrequest1    <= '0';     
        callrequest2    <= '0'; 
        dooropenbutton  <= '0';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until door_open_out = '0';
        floorbutton1    <= '0';
        floorbutton2    <= '0';         
        callrequest1    <= '0';     
        callrequest2    <= '0'; 
        dooropenbutton  <= '1';  
        doorclosebutton <= '0';   
        doorsensor      <= '0';
        wait until door_open_out = '1';
        floorbutton1    <= '0';
        floorbutton2    <= '0';         
        callrequest1    <= '0';     
        callrequest2    <= '0'; 
        dooropenbutton  <= '0';  
        doorclosebutton <= '1';   
        doorsensor      <= '0';
        wait until door_open_out = '0';
    end process;
        
end testbench;