extends TileMapLayer

@onready var apartment : TileMapLayer = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProgressionBus.connect("start_work", unload_scene)
#	ProgressionBus.connect("computer_screen", load_work_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func toggle_vis(object):
	if object.visible == false:
		object.visible = true
	
	else:
		object.visible = false

func load_work_scene():
	toggle_vis(apartment)

func unload_scene():
	apartment.queue_free()
