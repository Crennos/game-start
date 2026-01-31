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
	save_cory_state()
	save_story_state()
	save_task_state()
	


func save_story_state():
	var scene = ["Test Scene", "Scene One", "Scene Two", "Scene Three", 
	"Scene Four", "Scene Five", "Scene Six", "Scene Seven", "Scene Eight", "Ultimate Scene"]
	var scene_path = len(scene)
	var scene_check = ProgressionBus.scene_completion_dict
	
	for path in scene_path:
		var scene_key = scene[path]
		SaveGameBus.save_dialogue_path(scene_key, scene_check[scene_key])

func save_cory_state():
	var trait_check = ProgressionBus.cory_traits
	var skill_check = ProgressionBus.cory_skills
	
	for item in trait_check:
		print(item)
		SaveGameBus.save_traits(item, trait_check[item])

	
	for skill in skill_check:

		SaveGameBus.save_skills(skill, skill_check[skill])



func save_task_state():
	pass
	


func _on_load_game_pressed() -> void:
	var scene_check = ProgressionBus.scene_completion_dict
	var trait_check = ProgressionBus.cory_traits
	var skill_check = ProgressionBus.cory_skills
	var load_scene = SaveGameBus.load_dialogue_path()
	var load_trait = SaveGameBus.load_traits()
	var load_skill = SaveGameBus.load_skills()
	var scene_path = len(scene_check)
	var trait_path = len(trait_check)
	var skill_path = len(skill_check)
	
	for scene in scene_check:
		ProgressionBus.scene_completion_dict[scene] = load_scene[scene]

	
	for item in trait_check:

		ProgressionBus.cory_traits[item] = load_trait[item]

	
	for skill in skill_check:

		ProgressionBus.cory_skills[skill] = load_skill[skill]

	


func _on_options_pressed() -> void:
	toggle_vis(options_menu)
	toggle_vis(menu_container)


func _on_quit_pressed() -> void:
	get_tree().quit()
