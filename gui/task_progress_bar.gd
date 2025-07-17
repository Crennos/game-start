extends TextureProgressBar


@onready var task_bar : TextureProgressBar = $"."

@export var progress : float = 0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProgressionBus.connect("added_trask_progress", task_bar_raise)
	
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
#	task_progress_bar.value += progress


func task_bar_raise(task: String, prog: float):
	task_bar.value += prog
	print(task, " + ", prog)
	
