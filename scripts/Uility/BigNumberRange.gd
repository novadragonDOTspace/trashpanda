class_name BigNumberRange
extends Object

var start: BigCat.BigNumber = BigCat.BigNumber.ZERO
var current: BigCat.BigNumber = BigCat.BigNumber.ZERO
var end: BigCat.BigNumber = BigCat.BigNumber.ZERO
var increment: BigCat.BigNumber = BigCat.BigNumber.ONE

static func big_number_range(start: BigCat.BigNumber, end: BigCat.BigNumber, increment: BigCat.BigNumber = BigCat.BigNumber.ONE) -> BigNumberRange:
	return BigNumberRange.new(start, end, increment)
func should_continue():
	return current.is_less_than(end)
func _init(start: BigCat.BigNumber, end: BigCat.BigNumber, increment: BigCat.BigNumber = BigCat.BigNumber.ONE):
	self.start = start
	self.end = end
	self.increment = increment
	current = start
func _iter_init(arg):
	current = start
	return should_continue()
func _iter_next(iter: Array) -> bool:
	current = current.add_int(1)
	return should_continue()
func _iter_get(iter: Variant) -> Variant:
	return current
