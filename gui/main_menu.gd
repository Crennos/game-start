extends Control

@onready var main_menu : Control = $"."
@onready var options_menu : Control = $Options_Menu
@onready var demo_label : Label = $Demo_End
@onready var continue_button : Button = $VBoxContainer/Continue_Button

const CONTINUE_PATH = SaveGameBus.CONTINUE_PATH

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	continue_button
	continue_check()
	ProgressionBus.connect("end_demo", end_demo)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Checks if Continue is Enabled/Visible
func continue_check():
	if !FileAccess.file_exists(CONTINUE_PATH):
		print("No Exist")
		continue_button.visible = false
	else:
		continue_button.visible = visible
		print("Exists")

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


func _on_continue_button_pressed() -> void:
	SaveGameBus.load_continue_path()
	var game_start = preload("res://system/main.tscn")
	var start_game = game_start.instantiate()
	add_sibling(start_game)
	var scene_check = ProgressionBus.scene_completion_dict
	var trait_check = ProgressionBus.cory_traits
	var skill_check = ProgressionBus.cory_skills
	var task_check = ProgressionBus.cory_task_progress
	var load_scene = SaveGameBus.load_dialogue_path()
	var load_trait = SaveGameBus.load_traits()
	var load_skill = SaveGameBus.load_skills()
	
	for scene in scene_check:
		ProgressionBus.scene_completion_dict[scene] = load_scene[scene]
	
	for item in trait_check:
		ProgressionBus.cory_traits[item] = load_trait[item]
	
	for skill in skill_check:
		ProgressionBus.cory_skills[skill] = load_skill[skill]
	
	ProgressionBus.emit_signal("start_game")
	main_menu.queue_free()
