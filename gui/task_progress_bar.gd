extends TextureProgressBar


@onready var task_bar : TextureProgressBar = $"."

@export var progress : float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProgressionBus.connect("added_task_progress", task_bar_raise)
	ProgressionBus.connect("task_tracking_state", set_task_value)
	
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
#	task_progress_bar.value += progress

func toggle_vis(object):
	if object.visible == false:
		object.visible = true
	
	else:
		object.visible = false

func set_task_value(value: float):
	task_bar.value = value

func task_bar_raise(task: String, prog: float):
	task_bar.value += prog
#	print(task, " + ", prog)
	
