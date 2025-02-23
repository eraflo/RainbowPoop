extends Slider

@export var busName: AudioEffectSettings.BusName = AudioEffectSettings.BusName.Master

var busIndex: int = 0

func _ready() -> void:
	busIndex = AudioServer.get_bus_index(AudioManager.convertBusName(busName))
	value_changed.connect(_onVolumeChanged)

	value = db_to_linear(
		AudioServer.get_bus_volume_db(busIndex)
	)

func _onVolumeChanged(value: float) -> void:
	AudioServer.set_bus_volume_db(
		busIndex,
		linear_to_db(value)
	)
