extends Node

const AUDIO_PATH = "res://audio/"

var sounds := {
	"SlotChange.wav": load(AUDIO_PATH + "SlotChange.wav"),
	"Accurate.wav": load(AUDIO_PATH + "Accurate.wav"),
	"Inaccurate.wav": load(AUDIO_PATH + "Inaccurate.wav"),
	"Key.wav": load(AUDIO_PATH + "Key.wav")
}

onready var players := [$AudioStreamPlayer1, $AudioStreamPlayer2, 
						$AudioStreamPlayer3, $AudioStreamPlayer4]



func play(file_name: String, pitch: float = 1, volume: float = -10) -> void:
	if file_name in sounds.keys():
		for player in players:
			if not player.playing:
				player.stream = sounds[file_name]
				player.volume_db = volume
				player.pitch_scale = pitch
				player.playing = true
				return
	print("Too many sounds playing")
		



