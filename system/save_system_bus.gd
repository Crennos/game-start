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


func save_video_settings(key: String, value):
	config.set_value("audio", key, value)
	config.save(settings_path)

func load_video_settings():
	var video_settings = {}
	for key in config.get_section_keys("video"):
		video_settings[key] = config.get_value("video", key)
	return video_settings
	

func save_audio_settings(key: String, value):
	config.set_value("video", key, value)
	config.save(settings_path)
	

func load_audio_settings():
	var audio_settings = {}
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key)
	return audio_settings
	
