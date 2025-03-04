extends Node2D

var audioEffectDict = {}
var audioBusConfig: ConfigFile

var audioStreamPool: Array[AudioStreamPlayer] = []
var spatialAudioStreamPool: Array[AudioStreamPlayer2D] = []

@export var audioEffectSettings : Array[AudioEffectSettings] = []


func _ready() -> void:
	for audioEffectSetting in audioEffectSettings:
		if not audioEffectDict.has(audioEffectSetting.type):
			audioEffectDict[audioEffectSetting.type] = []
		audioEffectDict[audioEffectSetting.type].append(audioEffectSetting)
	
	loadAudioBusesData()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_APPLICATION_PAUSED:
		saveAudioBusesData()

func getNumberOfAudioForType(type: AudioEffectSettings.AudioEffectType) -> int:
	if audioEffectDict.has(type):
		var audioEffectSettingList = audioEffectDict[type]
		return len(audioEffectSettingList)
	return 0

func createAudioAtLocation(location, type: AudioEffectSettings.AudioEffectType, index: int = 0) -> AudioStreamPlayer2D:
	if audioEffectDict.has(type):
		var audioEffectSettingList = audioEffectDict[type]

		if index < 0 or index >= len(audioEffectSettingList):
			push_error("Index out of range for type: " + str(type))
			return

		var audioEffectSetting = audioEffectSettingList[index]

		if audioEffectSetting.hasOpenLimit():
			audioEffectSetting.changeAudioCount(1)
			var audioInstance = _getAudioStreamPlayer2D()

			audioInstance.add_to_group(str(type))

			audioInstance.finished.connect(func(): _returnAudioStreamPlayer2D(audioInstance))

			audioInstance.position = location
			audioInstance.bus = convertBusName(audioEffectSetting.busName)
			audioInstance.stream = audioEffectSetting.soundEffect
			audioInstance.volume_db = audioEffectSetting.volume
			audioInstance.pitch_scale = audioEffectSetting.pitchScale
			audioInstance.pitch_scale += randf_range(-audioEffectSetting.pitchRandomness, audioEffectSetting.pitchRandomness)
			audioInstance.finished.connect(audioEffectSetting.onAudioFinished)

			audioInstance.play()
			return audioInstance
	else:
		push_error("AudioEffectSettings not found for type: " + str(type))
		return null
	
	return null

func createAudio(type: AudioEffectSettings.AudioEffectType, index: int = 0) -> AudioStreamPlayer:
	if audioEffectDict.has(type):
		var audioEffectSettingList = audioEffectDict[type]

		if index < 0 or index >= len(audioEffectSettingList):
			push_error("Index out of range for type: " + str(type))
			return

		var audioEffectSetting = audioEffectSettingList[index]

		if audioEffectSetting.hasOpenLimit():
			audioEffectSetting.changeAudioCount(1)
			var audioInstance = _getAudioStreamPlayer()

			audioInstance.add_to_group(str(type))

			audioInstance.finished.connect(func(): _returnAudioStreamPlayer(audioInstance))

			audioInstance.bus = convertBusName(audioEffectSetting.busName)
			audioInstance.stream = audioEffectSetting.soundEffect
			audioInstance.volume_db = audioEffectSetting.volume
			audioInstance.pitch_scale = audioEffectSetting.pitchScale
			audioInstance.pitch_scale += randf_range(-audioEffectSetting.pitchRandomness, audioEffectSetting.pitchRandomness)
			audioInstance.finished.connect(audioEffectSetting.onAudioFinished)

			audioInstance.play()
			return audioInstance
	else:
		push_error("AudioEffectSettings not found for type: " + str(type))
		return null
	
	return null

func stopAudio(type: AudioEffectSettings.AudioEffectType) -> void:
	if audioEffectDict.has(type):
		var audioEffectSettingList = audioEffectDict[type]
		for audioEffectSetting in audioEffectSettingList:
			for audioInstance in get_tree().get_nodes_in_group(str(type)):
				audioInstance.stop()
				audioEffectSetting.onAudioFinished()

func stopAllAudio() -> void:
	for audioEffectSettings in audioEffectDict.values():
		for audioEffectSetting in audioEffectSettings:
			if isAudioPlayed(audioEffectSetting.type):
				stopAudio(audioEffectSetting.type)

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

func isAudioPlayed(type: AudioEffectSettings.AudioEffectType) -> bool:
	if audioEffectDict.has(type):
		var audioEffectSettingList = audioEffectDict[type]
		for audioEffectSetting in audioEffectSettingList:
			for audioInstance in get_tree().get_nodes_in_group(str(type)):
				if audioInstance.playing:
					return true
	return false

# For Spatial Audio
func _getAudioStreamPlayer2D() -> AudioStreamPlayer2D:
	if len(spatialAudioStreamPool) > 0:
		return spatialAudioStreamPool.pop_back()
	else:
		var newAudioStreamPlayer2D = AudioStreamPlayer2D.new()
		add_child(newAudioStreamPlayer2D)
		return newAudioStreamPlayer2D


# For Spatial Audio
func _returnAudioStreamPlayer2D(audioStreamPlayer2D: AudioStreamPlayer2D) -> void:
	if audioStreamPlayer2D in spatialAudioStreamPool:
		push_error("AudioStreamPlayer2D already in pool")
	else:
		audioStreamPlayer2D.stop()
		audioStreamPlayer2D.bus = ""
		audioStreamPlayer2D.stream = null
		audioStreamPlayer2D.volume_db = 0
		audioStreamPlayer2D.pitch_scale = 1.0
		
		for connection in audioStreamPlayer2D.finished.get_connections():
			audioStreamPlayer2D.finished.disconnect(connection.callable)
		
		
		spatialAudioStreamPool.append(audioStreamPlayer2D)

# For Non-Spatial Audio
func _getAudioStreamPlayer() -> AudioStreamPlayer:
	if len(audioStreamPool) > 0:
		return audioStreamPool.pop_back()
	else:
		var newAudioStreamPlayer = AudioStreamPlayer.new()
		add_child(newAudioStreamPlayer)
		return newAudioStreamPlayer

# For Non-Spatial Audio
func _returnAudioStreamPlayer(audioStreamPlayer: AudioStreamPlayer) -> void:
	if audioStreamPlayer in audioStreamPool:
		push_error("AudioStreamPlayer already in pool")
	else:
		audioStreamPlayer.stop()
		audioStreamPlayer.bus = ""
		audioStreamPlayer.stream = null
		audioStreamPlayer.volume_db = 0
		audioStreamPlayer.pitch_scale = 1.0
		
		for connection in audioStreamPlayer.finished.get_connections():
			audioStreamPlayer.finished.disconnect(connection.callable)
		
		audioStreamPool.append(audioStreamPlayer)
