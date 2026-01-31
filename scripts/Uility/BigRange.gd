class_name BigRange
extends Object

var start: Big = Big.new(0)
var current: Big = Big.new(0)
var end: Big = Big.new(0)
var increment: Big = Big.new(1)

func should_continue():
	return current.isLessThan(end)
@warning_ignore_start("SHADOWED_VARIABLE")
func _init(start: Big, end: Big, increment: Big = Big.new(1)):
	@warning_ignore_restore("SHADOWED_VARIABLE")
	self.start = start
	self.end = end
	self.increment = increment
	current = start
func _iter_init(_arg):
	current = start
	return should_continue()
func _iter_next(_iter: Array) -> bool:
	current = current.plus(1)
	return should_continue()
func _iter_get(_iter: Variant) -> Variant:
	return current
