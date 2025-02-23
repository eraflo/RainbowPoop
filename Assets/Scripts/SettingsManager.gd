extends Node

class_name SettingsManager

var userSettings: ConfigFile


func _ready():
    userSettings = ConfigFile.new()
    userSettings.load("user://settings.cfg")

    if userSettings == null:
        userSettings = ConfigFile.new()
        userSettings.save("user://settings.cfg")

    if userSettings.has_section("Audio"):
        print("Audio Section Exists")
    else:
        userSettings.set_value("Audio", "MasterVolume", 0.0)
        userSettings.set_value("Audio", "MusicVolume", 0.0)
        userSettings.set_value("Audio", "SFXVolume", 0.0)
        userSettings.set_value("Audio", "UIVolume", 0.0)
        userSettings.save("user://settings.cfg")
    

func saveValue(section: String, key: String, value: float) -> void:
    userSettings.set_value(section, key, value)
    userSettings.save("user://settings.cfg")

func loadValue(section: String, key: String) -> float:
    return userSettings.get_value(section, key)


