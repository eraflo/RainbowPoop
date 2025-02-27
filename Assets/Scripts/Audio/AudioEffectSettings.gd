extends Resource

class_name AudioEffectSettings

enum AudioEffectType {
    ON_MAIN_MUSIC,
    ON_START_MENU_MUSIC,
    ON_RAINBOW_POOP_SPEAK,
    ON_FOOD_COLLECTED,
    ON_BAD_FOOD_COLLECTED,
    ON_TRAP_ACTIVATED,
    ON_RUN,
    ON_JUMP,
    ON_STUN,
    ON_UNHEALTHY_HEALTH_ENTERED,
    ON_HEALTHY_HEALTH_ENTERED,
    ON_LEVEL_STARTED,
    ON_LEVEL_FINISHED,
    ON_LOSE,
    ON_WIN,
    ON_SPECIAL_WIN,
    ON_BUTTON_CLICK
}

enum BusName {
    Master,
    Music,
    SFX,
    UI
}

@export_range(0, 10) var limit: int = 5
@export var busName: BusName
@export var type: AudioEffectType
@export var soundEffect : AudioStreamMP3
@export_range(-40, 20) var volume = 0
@export_range(0.0, 4.0, .01) var pitchScale = 1.0
@export_range(0.0, 1.0, .01) var pitchRandomness = 0.0

var audioCount = 0

func changeAudioCount(amount: int) -> void:
    audioCount = max(0, audioCount + amount)

func hasOpenLimit() -> bool:
    return audioCount < limit

func onAudioFinished() -> void:
    changeAudioCount(-1)
