extends GutTest

func test_calculate_next_cost_1_1():
	var result = GameState.calculate_next_costs(BigCat.BigNumber.from_int(100), BigCat.BigNumber.from_int(0), BigCat.BigNumber.from_int(1), BigCat.BigNumber.from_int(115))
	assert_true(result.is_equal_to(BigCat.BigNumber.from_int(100)), "%s != 100" % result.to_string())

func test_calculate_next_cost_2_1():
	var result = GameState.calculate_next_costs(BigCat.BigNumber.from_int(100), BigCat.BigNumber.from_int(1), BigCat.BigNumber.from_int(1), BigCat.BigNumber.from_int(115))
	assert_true(result.is_equal_to(BigCat.BigNumber.from_int(115)), "%s != 115" % result.to_string())
	
func test_calculate_next_cost_1_2():
	var result = GameState.calculate_next_costs(BigCat.BigNumber.from_int(100), BigCat.BigNumber.from_int(0), BigCat.BigNumber.from_int(2), BigCat.BigNumber.from_int(115))
	assert_true(result.is_equal_to(BigCat.BigNumber.from_int(215)), "%s != 215" % result.to_string())

func test_calculate_next_cost_10_1():
	var result = GameState.calculate_next_costs(BigCat.BigNumber.from_int(100), BigCat.BigNumber.from_int(9), BigCat.BigNumber.from_int(1), BigCat.BigNumber.from_int(115))
	assert_true(result.is_equal_to(BigCat.BigNumber.from_int(351)), "%s != 351" % result.to_string())
func test_calculate_next_cost_50_1():
	var result = GameState.calculate_next_costs(BigCat.BigNumber.from_int(100), BigCat.BigNumber.from_int(49), BigCat.BigNumber.from_int(1), BigCat.BigNumber.from_int(115))
	assert_true(result.is_equal_to(BigCat.BigNumber.from_int(94231)), "%s != 94231" % result.to_string())
