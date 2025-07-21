extends Sprite2D


@onready var work_screen : Sprite2D = $"."

func _ready() -> void:
	ProgressionBus.connect("stop_work", unload_scene)
	


func toggle_vis(object):
	if object.visible == false:
		object.visible = true
	
	else:
		object.visible = false

func load_apartment():
	toggle_vis(work_screen)

func unload_scene():
	work_screen.queue_free()
