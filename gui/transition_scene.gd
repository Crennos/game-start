extends AnimatedSprite2D

@onready var transition : AnimatedSprite2D = $"."
@onready var first : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProgressionBus.connect("transition", fade_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Starts Transition Sweep
func fade_scene(new_scene: String):
	transition.visible = true
	ProgressionBus.emit_signal("ready_scene", new_scene)
	var tween = get_tree().create_tween()
	tween.tween_property(transition, "position", Vector2(368, -24), 3)
	tween.finished.connect(reset)
	
	

#Resets After Transition
func reset():
	transition.visible = false
	transition.position = Vector2(80, -24)
	if first == false:
		first_tran()
		first = true


func first_tran():
	ProgressionBus.emit_signal("start_game")
