extends Control

#Primary Objects
@onready var game_menu : Control = $"."
@onready var options_menu : Control = $Options_Menu
@onready var menu_container : MarginContainer = $Menu_Container


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	vis_check()
	detect_input()


func detect_input():
	if Input.is_action_just_pressed("Pause"):
		toggle_vis(game_menu)
		

func toggle_vis(object: Object):
	if object.visible == true:
		object.visible = false
	else:
		object.visible = true

func vis_check():
	if options_menu.visible == false:
		menu_container.visible = true

func _on_continue_pressed() -> void:
	toggle_vis(game_menu)


func _on_save_game_pressed() -> void:
	pass # Replace with function body.


func _on_load_game_pressed() -> void:
	pass # Replace with function body.


func _on_options_pressed() -> void:
	toggle_vis(options_menu)
	toggle_vis(menu_container)


func _on_quit_pressed() -> void:
	get_tree().quit()
