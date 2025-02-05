
class_name PlayerStat extends Resource

const MIN_FLOAT = -1.79769e308

## The base value of the stat (value without modifiers ; do not modify directly or use it)
@export var base_value: float

## The final value of the stat (value to use)
var value: float:
	get:
		if _is_dirty or _last_base_value != base_value:
			_last_base_value = base_value
			_value = _calculate_final_value()
			_is_dirty = false
		return _value

# ---- Don't modify these variables directly ----
var _modifiers: Array = []
var _is_dirty: bool = true
var _value: float = 0.0 # Cache the final value
var _last_base_value: float = MIN_FLOAT # The last base value used

## Add a new modifier
func add_modifier(modifier: StatModifier):
	_is_dirty = true
	_modifiers.append(modifier)
	_modifiers.sort_custom(_compare_modifier_order)

## Remove a specific modifier
func remove_modifier(modifier: StatModifier) -> bool:
	for i in range(_modifiers.size() - 1, -1, -1):
		if(_modifiers[i] == modifier):
			_is_dirty = true
			_modifiers.remove_at(i)
			return true
	return false


## Remove all modifiers that have the same source
func remove_all_modifiers_from_source(source: Object):
	for i in range(_modifiers.size() - 1, -1, -1):
		if(_modifiers[i].source == source):
			_is_dirty = true
			_modifiers.remove_at(i)

## Calculate the final value
func _calculate_final_value():
	var final_value = base_value
	var sum_percent_add = 0.0

	for i in range(_modifiers.size()):
		var mod = _modifiers[i]

		if(mod.type == StatModifier.StatModType.Flat):
			final_value += mod.value
		elif(mod.type == StatModifier.StatModType.PercentAdd):
			sum_percent_add += mod.value

			# If next modifier is not a percent add, then apply the sum to the final value
			if(i + 1 >= _modifiers.size() or _modifiers[i + 1].type != StatModifier.StatModType.PercentAdd):
				final_value *= 1 + sum_percent_add
				sum_percent_add = 0.0

		elif(mod.type == StatModifier.StatModType.PercentMult):
			final_value *= 1 + mod.value

	return round(final_value)

## Compare the order of the modifiers
func _compare_modifier_order(a: StatModifier, b: StatModifier) -> int:
	if(a.order < b.order):
		return -1
	elif(a.order > b.order):
		return 1
	return 0
