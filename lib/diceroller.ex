defmodule Mkeon.Diceroller do
	def seed do
		<< a :: 32, b :: 32, c :: 32 >> = :crypto.rand_bytes(12)
		:random.seed(a,b,c)
	end
	def add_random_number(list, 0, _dicevalue) do
		list
	end
	def add_random_number(list, count, dicevalue) do
		seed
		add_random_number([:random.uniform(dicevalue)] ++ list, count-1, dicevalue)
	end
	def roll_obdice(count, dicevalue) do
		solve_ob(add_random_number([], count, dicevalue), dicevalue)
	end
	def roll_normaldice(count, dicevalue) do
		add_random_number([], count, dicevalue)
	end
	def solve_ob(dices, dicevalue, obcount \\ 0) when dicevalue != 1 do
		case Enum.any?(dices, fn(x) -> x === dicevalue end) do
			true ->
				solve_ob(add_random_number(dices -- [dicevalue], 2, dicevalue), dicevalue, obcount+1)
			false ->
				{dices, obcount}
		end	
	end
end