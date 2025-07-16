extends TextureProgressBar

@onready var task_progress_bar : TextureProgressBar = $"."
@onready var CoryChar : CharacterBody2D = $".."

@export var progress : float = 0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProgressionBus.connect("added_trask_progress", task_bar_raise)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	task_progress_bar.value += progress


func task_bar_raise(task: String, prog: float):
	print(task, " +1 ", prog)
	pass
