extends GutTest

func test_calculate_next_cost_1_1():
	var result = GameState.calculate_next_costs(Big.new(100), Big.new(0), Big.new(1), Big.new(115))
	assert_true(result.is_equal_to(Big.new(100)), "%s != 100" % result.to_string())

func test_calculate_next_cost_2_1():
	var result = GameState.calculate_next_costs(Big.new(100), Big.new(1), Big.new(1), Big.new(115))
	assert_true(result.is_equal_to(Big.new(115)), "%s != 115" % result.to_string())
	
func test_calculate_next_cost_1_2():
	var result = GameState.calculate_next_costs(Big.new(100), Big.new(0), Big.new(2), Big.new(115))
	assert_true(result.is_equal_to(Big.new(215)), "%s != 215" % result.to_string())

func test_calculate_next_cost_10_1():
	var result = GameState.calculate_next_costs(Big.new(100), Big.new(9), Big.new(1), Big.new(115))
	assert_true(result.is_equal_to(Big.new(351)), "%s != 351" % result.to_string())
func test_calculate_next_cost_50_1():
	var result = GameState.calculate_next_costs(Big.new(100), Big.new(49), Big.new(1), Big.new(115))
	assert_true(result.is_equal_to(Big.new(94231)), "%s != 94231" % result.to_string())
