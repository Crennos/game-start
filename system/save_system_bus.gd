extends Node

var config = ConfigFile.new()
const settings_path = "User://settings.ini"
var load_path = config.load(settings_path)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !FileAccess.file_exists(settings_path):
		config.set_value("video", "resolution", 0)
		config.set_value("video", "window_mode", 0)
		
		config.set_value("audio", "master_volume", 0.0)
		config.set_value("audio", "music_volume", 0.0)
		config.set_value("audio", "sfx_volume", 0.0)
		
	else:
		config.load_path


func save_video_settings():
	pass
	

func load_video_settings(key):
	pass
	

func save_audio_settings():
	pass
	

func load_audio_settings(key):
	pass
	
