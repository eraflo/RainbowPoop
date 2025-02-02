
class_name StatModifier extends Resource

enum StatModType {
    Flat = 100,
    PercentAdd = 200,
    PercentMult = 300
}

var value: float = 0.0
var type: StatModType = StatModType.Flat
var order: int = 0
var source: Object

func _init(_value: float, _type: StatModType, _order: int = int(_type), _source: Object = null):
    self.value = _value
    self.type = _type
    self.order = _order
    self.source = _source

