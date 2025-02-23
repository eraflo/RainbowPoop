extends Node2D

var audioEffectDict = {}
var audioBusConfig: ConfigFile

@export var audioEffectSettings : Array[AudioEffectSettings] = []


func _ready() -> void:
	for audioEffectSetting in audioEffectSettings:
		audioEffectDict[audioEffectSetting.type] = audioEffectSetting
	
	loadAudioBusesData()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		saveAudioBusesData()

func createAudioAtLocation(location, type: AudioEffectSettings.AudioEffectType) -> void:
	if audioEffectDict.has(type):
		var audioEffectSetting = audioEffectDict[type]
		if audioEffectSetting.hasOpenLimit():
			audioEffectSetting.changeAudioCount(1)
			var audioInstance = AudioStreamPlayer2D.new()
			add_child(audioInstance)

			audioInstance.position = location
			audioInstance.bus = convertBusName(audioEffectSetting.busName)
			audioInstance.stream = audioEffectSetting.soundEffect
			audioInstance.volume_db = audioEffectSetting.volume
			audioInstance.pitch_scale = audioEffectSetting.pitchScale
			audioInstance.pitch_scale += randf_range(-audioEffectSetting.pitchRandomness, audioEffectSetting.pitchRandomness)
			audioInstance.finished.connect(audioEffectSetting.onAudioFinished)
			audioInstance.finished.connect(audioInstance.queue_free)

			audioInstance.play()
	else:
		push_error("AudioEffectSettings not found for type: " + str(type))

func createAudio(type: AudioEffectSettings.AudioEffectType) -> void:
	if audioEffectDict.has(type):
		var audioEffectSetting = audioEffectDict[type]
		if audioEffectSetting.hasOpenLimit():
			audioEffectSetting.changeAudioCount(1)
			var audioInstance = AudioStreamPlayer2D.new()
			add_child(audioInstance)

			audioInstance.bus = convertBusName(audioEffectSetting.busName)
			audioInstance.stream = audioEffectSetting.soundEffect
			audioInstance.volume_db = audioEffectSetting.volume
			audioInstance.pitch_scale = audioEffectSetting.pitchScale
			audioInstance.pitch_scale += randf_range(-audioEffectSetting.pitchRandomness, audioEffectSetting.pitchRandomness)
			audioInstance.finished.connect(audioEffectSetting.onAudioFinished)
			audioInstance.finished.connect(audioInstance.queue_free)

			audioInstance.play()
	else:
		push_error("AudioEffectSettings not found for type: " + str(type))

func convertBusName(busName: AudioEffectSettings.BusName) -> String:
	match busName:
		AudioEffectSettings.BusName.Master:
			return "Master"
		AudioEffectSettings.BusName.Music:
			return "Music"
		AudioEffectSettings.BusName.SFX:
			return "SFX"
		AudioEffectSettings.BusName.UI:
			return "UI"
	return "Master"

func loadAudioBusesData() -> void:
	for busName in AudioEffectSettings.BusName:
		var volume = Settings.loadValue("Audio", busName + "Volume")
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index(busName),
			volume
		)

func saveAudioBusesData() -> void:
	for busName in AudioEffectSettings.BusName:
		Settings.saveValue("Audio", busName + "Volume",
			AudioServer.get_bus_volume_db(
				AudioServer.get_bus_index(busName)
			)
		)
