extends TextureProgressBar

@onready var task_progress_bar : TextureProgressBar = $"."
@export var progress : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	task_progress_bar.value += progress
