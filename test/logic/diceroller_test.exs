ExUnit.start
defmodule Mkeon.DicerollerTest do
	use ExUnit.Case

	alias Mkeon.Diceroller
	
	test "solve_ob. returns more dices than supplied and that obcount is counted correctly" do
		dicevalue = 6
		inputDices = [1,2,6]
		{roll, obcount} = Diceroller.solve_ob(inputDices, dicevalue)
		assert length(roll) > length(inputDices)
		assert obcount >= 1
 	end

 	test "roll_dice/3. returns correct amount of dices" do
 		dicevalue = 6
 		res = Diceroller.roll_normaldice(6, dicevalue)
 		assert length(res) == 6
 	end
 	test "roll_dice obthrow. returns correct amount of dices" do
 		dicevalue = 6
 		{roll, _obcount} = Diceroller.roll_obdice(6 , dicevalue)
 		assert length(roll) >= 6
 	end
 	test "add_random_number/3. returns somewhat random numbers" do
 		res = Diceroller.add_random_number([], 1000, 100)
 		assert length(Enum.uniq(res)) > 1
 	end
 	test "add_random_number/3. adds new numbers to list" do
 		dicevalue = 6
 		testList = [1]
 		testList = Diceroller.add_random_number(testList, 2, dicevalue)
 		assert length(testList) == 3
 	end
end