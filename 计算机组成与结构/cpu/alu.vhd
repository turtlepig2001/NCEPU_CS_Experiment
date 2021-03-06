----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:46:47 06/30/2020 
-- Design Name: 
-- Module Name:    alu - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
    Port ( clk : in  STD_LOGIC;
           aluOp : in  STD_LOGIC_VECTOR (2 downto 0);
           dinA : in  STD_LOGIC_VECTOR (15 downto 0);
           dinB : in  STD_LOGIC_VECTOR (15 downto 0);
           dout : out  STD_LOGIC_VECTOR (15 downto 0));
end alu;

architecture Behavioral of alu is

begin
	process(clk)
	begin
		if (rising_edge(clk)) then
			if(aluOp = "001") then
				dout <= dinA + dinB;
			elsif(aluOp = "010") then
				dout <= dinA - dinB;
			elsif(aluOp = "011") then
				dout <= dinA or dinB;
			elsif(aluOp = "100") then
				dout <= not dinA;
			else
				null;
			end if;
		end if;
	end process;

end Behavioral;

