library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity advanced_elevator_control is
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
        callrequest3D                    :   in  std_logic;
        callrequest4                    :   in  std_logic;
        dooropenbutton                  :   in  std_logic;
        doorclosebutton                 :   in  std_logic;
        doorsensor                      :   in  std_logic;
        door_open_out                   :   out std_logic;
        elevator_moving_direction_out   :   out std_logic_vector(1 downto 0);
        elevator_current_floor_out      :   out unsigned(1 downto 0)
    );
end advanced_elevator_control;

--state_type

--A: staying at floor 1
--B: staying at floor 2
--C: staying at floor 3
--D: staying at floor 4

--E: going up from 1 to 2
--F: going up from 2 to 3
--G: going up from 3 to 4

--H: going down from 4 to 3
--I: going down from 3 to 2
--J: going down from 2 to 1

--K: opening the door
--L: door staying open
--M: closing the door

architecture advanced_controller of advanced_elevator_control is
    type state_type is (A,B,C,D,E,F,G,H,I,J,K,L,M);
    signal door_open                    :   std_logic;
    signal elevator_moving_direction    :   std_logic_vector(1 downto 0);
    signal elevator_current_floor       :   unsigned(1 downto 0);
    signal counter                      :   integer;
    signal ctrst                        :   std_logic;
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

    next_state_proc : process (clk, state, rst, ctrst, floorbutton1, floorbutton2, floorbutton3, floorbutton4, 
                                callrequest1, callrequest2U, callrequest2D, callrequest3U, callrequest3D, 
                                callrequest4, dooropenbutton, doorclosebutton, doorsensor)
    begin
        if (rst = '1') then
            next_state <= A;
        else 
            case state is
                when A =>
                    if (floorbutton1 = '1' or callrequest1 = '1' or dooropenbutton = '1') then
                        next_state <= K;
                    elsif   (floorbutton2 = '1' or callrequest2U = '1' or callrequest2D = '1' or
                            floorbutton3 = '1' or callrequest3U = '1' or callrequest3D = '1' or
                            floorbutton4 = '1' or callrequest4 = '1') then
                        next_state <= E;
                    else
                        next_state <= A;
                    end if;
                when B =>
                    if (floorbutton2 = '1' or (elevator_moving_direction = "01" and callrequest2U = '1') or 
                        (elevator_moving_direction = "11" and callrequest2D = '1') or dooropenbutton = '1') then
                        next_state <= K;
                    elsif   (elevator_moving_direction = "01" and 
                            (floorbutton3 = '1' or callrequest3U = '1' or callrequest3D = '1' or
                            floorbutton4 = '1' or callrequest4 = '1')) then
                        next_state <= F;
                    elsif   (elevator_moving_direction = "11" and 
                            (floorbutton1 = '1' or callrequest1 = '1')) then
                        next_state <= J;
                    else
                        next_state <= B;
                    end if;
                when C =>
                    if (floorbutton3 = '1' or (elevator_moving_direction = "01" and callrequest3U = '1') or 
                        (elevator_moving_direction = "11" and callrequest3D = '1') or dooropenbutton = '1') then
                        next_state <= K;
                    elsif   (elevator_moving_direction = "01" and 
                            (floorbutton4 = '1' or callrequest4 = '1')) then
                        next_state <= G;
                    elsif   (elevator_moving_direction = "11" and 
                            (floorbutton1 = '1' or callrequest1 = '1' or
                            floorbutton2 = '1' or callrequest2U = '1' or callrequest2D = '1')) then
                        next_state <= I;
                    else
                        next_state <= C;
                    end if;
                when D =>
                    if (floorbutton4 = '1' or callrequest4 = '1' or dooropenbutton = '1') then
                        next_state <= K;
                    elsif   (floorbutton1 = '1' or callrequest1 = '1' or
                            floorbutton2 = '1' or callrequest2U = '1' or callrequest2D = '1' or
                            floorbutton3 = '1' or callrequest3U = '1' or callrequest3D = '1') then
                        next_state <= H;
                    else
                        next_state <= D;
                    end if;
                when E =>
                    if (done = '1') then
                        next_state <= B;
                    else
                        next_state <= E;
                    end if;
                when F =>
                    if (done = '1') then
                        next_state <= C;
                    else
                        next_state <= F;
                    end if;
                when G =>
                    if (done = '1') then
                        next_state <= D;
                    else
                        next_state <= G;
                    end if;
                when H =>
                    if (done = '1') then
                        next_state <= C;
                    else
                        next_state <= H;
                    end if;
                when I =>
                    if (done = '1') then
                        next_state <= B;
                    else
                        next_state <= I;
                    end if;
                when J =>
                    if (done = '1') then
                        next_state <= A;
                    else
                        next_state <= J;
                    end if;
                when K =>
                    if (done = '1') then
                        next_state <= L;
                    else
                        next_state <= K;
                    end if;
                when L =>
                    if ((doorsensor = '0' and done = '1' and dooropenbutton = '0') or (doorsensor = '0' and doorclosebutton = '1')) then
                        next_state <= M;
                    else
                        next_state <= L;
                    end if;
                when M =>
                    if (done = '1') then
                        case elevator_current_floor is
                            when "00" =>
                                next_state <= A;
                            when "01" =>
                                next_state <= B;
                            when "10" =>
                                next_state <= C;
                            when "11" =>
                                next_state <= D;
                            when others =>
                                next_state <= A;
                        end case;
                    elsif (dooropenbutton = '1' or doorsensor = '1') then
                        next_state <= K;
                    else
                        next_state <= M;
                    end if;
            end case;
        end if;
    end process;

    output_proc : process(state)
    begin
        case state is
            when A =>
                door_open                   <= '0';    
                elevator_current_floor      <= "00";
            when B =>
                door_open                   <= '0';   
                elevator_current_floor      <= "01";
            when C =>
                door_open                   <= '0';   
                elevator_current_floor      <= "10";
            when D =>
                door_open                   <= '0';  
                elevator_current_floor      <= "11";
            when E =>
                door_open                   <= '0';  
                elevator_current_floor      <= "00";
            when F =>
                door_open                   <= '0';   
                elevator_current_floor      <= "01";
            when G =>
                door_open                   <= '0';   
                elevator_current_floor      <= "10";
            when H =>
                door_open                   <= '0';  
                elevator_current_floor      <= "11";
            when I =>
                door_open                   <= '0';  
                elevator_current_floor      <= "10";
            when J =>
                door_open                   <= '0';   
                elevator_current_floor      <= "01";
            when K =>
                door_open                   <= '0';    
                elevator_current_floor      <= elevator_current_floor;
            when L =>
                door_open                   <= '1';   
                elevator_current_floor      <= elevator_current_floor;
            when M =>
                door_open                   <= '1';  
                elevator_current_floor      <= elevator_current_floor;
        end case;
    end process;

    moving_direction : process(rst, elevator_current_floor, floorbutton1, callrequest1,
                                floorbutton2, callrequest2U, callrequest2D, floorbutton3, 
                                callrequest3U, callrequest3D, floorbutton4, callrequest4)
    begin
        if (rst = '1') then
            elevator_moving_direction <= "01";
        else
            case elevator_current_floor is
                when "00" =>
                    elevator_moving_direction <= "01";
                when "01" =>
                    if ((floorbutton1 = '1' or callrequest1 = '1') and
                        (floorbutton3 = '0' and callrequest3U = '0' and callrequest3D = '0' and
                         floorbutton4 = '0' and callrequest4 = '0')) then
                        elevator_moving_direction <= "11";
                    elsif ((floorbutton1 = '0' and callrequest1 = '0') and
                            (floorbutton3 = '1' or callrequest3U = '1' or callrequest3D = '1' or 
                            floorbutton4 = '1' or callrequest4 = '1')) then
                        elevator_moving_direction <= "01";
                    else
                        elevator_moving_direction <= elevator_moving_direction;
                    end if;
                when "10" =>
                    if ((floorbutton1 = '1' or callrequest1 = '1' or
                        floorbutton2 = '1' or callrequest2U = '1' or callrequest2D = '1') and
                        (floorbutton4 = '0' and callrequest4 = '0')) then
                        elevator_moving_direction <= "11";
                    elsif ((floorbutton1 = '0' and callrequest1 = '0' and
                            floorbutton2 = '0' and callrequest2U = '0' and callrequest2D = '0') and
                            (floorbutton4 = '1' or callrequest4 = '1')) then
                        elevator_moving_direction <= "01";
                    else
                        elevator_moving_direction <= elevator_moving_direction;
                    end if;
                when "11" =>
                    elevator_moving_direction <= "11";
                when others =>
                    elevator_moving_direction <= elevator_moving_direction;
            end case;
        end if;
    end process;

    counter_engine : process(clk, rst, ctrst,  counter)
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
end advanced_controller;