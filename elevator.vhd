library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity elevator_control is
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
end elevator_control;

--state_type
--A: staying at floor 1
--B: going up from 1 to 2
--C: staying at floor 2
--D: going down from 2 to 1
--E: opening the door
--F: door staying open
--G: closing the door

architecture controller of elevator_control is 
    type state_type is (A,B,C,D,E,F,G);
    signal door_open                    :   std_logic;
    signal elevator_moving_direction    :   std_logic_vector(1 downto 0);
    signal elevator_current_floor       :   std_logic;
    signal counter                      :   integer;
    signal ctrst                        :   std_logic;
    --signal start                        :   std_logic;
    signal done                         :   std_logic;
    signal state                        :   state_type;
    signal next_state                   :   state_type;
    constant timer                      :   integer := 10;
begin
    SYNC_PROC : process (clk, rst)
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                state <= A;
            else
                state <= next_state;
            end if;
        end if;
    end process;

    next_state_engine : process(clk, state, rst, ctrst, floorbutton1, floorbutton2, callrequest1, callrequest2, dooropenbutton, doorclosebutton, doorsensor)
    begin
        if (rst = '1') then
            next_state <= A;
        else 
            case state is
                when A =>
                    if (floorbutton1 = '1' or callrequest1 = '1' or dooropenbutton = '1') then
                        next_state <= E;
                    elsif (floorbutton2 = '1' or callrequest2 = '1') then
                        next_state <= B;
                    else
                        next_state <= A;
                    end if;
                when B =>
                    if (done = '1') then
                        next_state <= C;
                    else
                        next_state <= B;
                    end if;
                when C =>
                    if (floorbutton2 = '1' or callrequest2 = '1' or dooropenbutton = '1') then
                        next_state <= E;
                    elsif (floorbutton1 = '1' or callrequest1 = '1') then
                        next_state <= D;
                    else
                        next_state <= C;
                    end if; 
                when D =>
                    if (done = '1') then
                        next_state <= A;
                    else
                        next_state <= D;
                    end if;                   
                when E =>
                    if (done = '1') then
                        next_state <= F;
                    else
                        next_state <= E;
                    end if;
                when F =>
                    if ((doorsensor = '0' and done = '1' and dooropenbutton = '0') or (doorsensor = '0' and doorclosebutton = '1')) then
                        next_state <= G;
                    else
                        next_state <= F;
                    end if;
                when G =>
                    if (done = '1') then
                        if (elevator_current_floor = '0') then
                            next_state <= A;
                        else
                            next_state <= C;
                        end if;
                    elsif (dooropenbutton = '1' or doorsensor = '1') then
                        next_state <= E;
                    else
                        next_state <= G;
                    end if;
            end case;
        end if;
    end process;

    output_proc : process(state)
    begin
        case state is
            when A =>
                door_open                   <= '0';  
                elevator_moving_direction   <= "00";  
                elevator_current_floor      <= '0';
            when B =>
                door_open                   <= '0';  
                elevator_moving_direction   <= "01";  
                elevator_current_floor      <= '0';
            when C =>
                door_open                   <= '0';  
                elevator_moving_direction   <= "00";  
                elevator_current_floor      <= '1';
            when D =>
                door_open                   <= '0';  
                elevator_moving_direction   <= "11";  
                elevator_current_floor      <= '1';
            when E =>
                door_open                   <= '0';  
                elevator_moving_direction   <= "00";
                elevator_current_floor      <= elevator_current_floor;
            when F =>
                door_open                   <= '1';  
                elevator_moving_direction   <= "00";  
                elevator_current_floor      <= elevator_current_floor;
            when G =>
                door_open                   <= '1';  
                elevator_moving_direction   <= "00";  
                elevator_current_floor      <= elevator_current_floor;
        end case;
    end process;

    counter_engine : process(clk, rst, ctrst, counter)
    begin
        if (rst = '1' or ctrst = '1') then
            counter <= 0;
        elsif rising_edge(clk) then
            counter <= counter + 1;
        end if;
        if (counter >= timer) then
            done <= '1';
        else
            done <= '0';
        end if;
    end process;

    rst_proc : process
    begin
        ctrst <= '1';
        wait for 1 ns;
        ctrst <= '0';
        wait on state;
    end process;

    door_open_out <= door_open;
    elevator_moving_direction_out <= elevator_moving_direction;
    elevator_current_floor_out <= elevator_current_floor;

end controller;
        
    