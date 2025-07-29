extends Control

@onready var main_menu : Control = $"."
@onready var options_menu : Control = $Options_Menu
@onready var demo_label : Label = $Demo_End


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProgressionBus.connect("end_demo", end_demo)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func end_demo():
	demo_label.visible = true

func _on_start_button_pressed() -> void:
	var game_start = preload("res://system/main.tscn")
	var start_game = game_start.instantiate()
	add_sibling(start_game)
	main_menu.queue_free()
	ProgressionBus.emit_signal("transition", "Scene One")
	


func toggle_vis(object):
	if object.visible == false:
		object.visible = true
	
	else:
		object.visible = false

func _on_options_button_pressed() -> void:
	toggle_vis(options_menu)
	



func _on_quit_button_pressed() -> void:
	get_tree().quit()
