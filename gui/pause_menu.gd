extends Control

@onready var pause_menu : Control = $"."
@onready var options_menu : Control = $Options_Menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pause():
	if Input.is_action_just_pressed("Pause"):
		toggle_vis(pause_menu)
	


func _on_resume_button_pressed() -> void:
	get_tree()
	toggle_vis(pause_menu)
	if options_menu.visible == true:
		toggle_vis(options_menu)
	

func toggle_vis(object):
	if object.visible == false:
		object.visible = true
	
	else:
		object.visible = false
	

func _on_options_button_pressed() -> void:
	toggle_vis(options_menu)
	


func _on_quit_button_pressed() -> void:
	get_tree().quit
