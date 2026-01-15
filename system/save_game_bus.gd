extends Node

var config = ConfigFile.new()
const game_path = "User://game.ini"
var load_path = config.load(game_path)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !FileAccess.file_exists(game_path):
		#Dialogue Scene List
		config.set_value("Scene", "Intro", false)
		config.set_value("Scene", "Intro Morning", false)
		config.set_value("Scene", "Intro Noon", false)
		config.set_value("Scene", "Intro Afternoon", false)
		config.set_value("Scene", "Day One Start", false)
		
		#Task List and Status
		config.set_value("Task", "Task One Completion", false)
		config.set_value("Task", "Task Bar", 0.0)
		config.set_value("Task", "Coding Bar", 0.0)
		config.set_value("Task", "Testing Bar", 0.0)
		config.set_value("Task", "Debugging Bar", 0.0)
#		config.set_value("Task", "Debug Max", 0.0)
		config.set_value("Task", "Learning Bar", 0.0)
		config.set_value("Task", "Breakpoint Bar", 0.0)
		config.set_value("Task", "Hidden Bugs", [])
		config.set_value("Task", "Test Thresh", 0)
		config.set_value("Task", "Found Bugs", [])
		config.set_value("Task", "Bug Health", 0.0)
		config.set_value("Task", "Break Bugs", [])
		config.set_value("Task", "Break Count", 0)
		
		#Corey Status
		config.set_value("Status", "Work Load", 0.0)
		config.set_value("Status", "Over Load", 0.0)
		config.set_value("Status", "Familiarity", 0.0)
		config.set_value("Status", "Burnout", 0.0)
		
		#Corey Traits
		config.set_value("Trait", "Patience", 0)
		config.set_value("Trait", "Perseverance", 0)
		config.set_value("Trait", "Motivation", 0)
		config.set_value("Trait", "Creativity", 0)
		config.set_value("Trait", "Focus", 0)
		config.set_value("Trait", "Insight", 0)
		config.set_value("Trait", "Anxiety", 0)
		config.set_value("Trait", "Lethargy", 0)
		config.set_value("Trait", "Frailty", 0)
		config.set_value("Trait", "Stress", 0)
		config.set_value("Trait", "Strain", 0)
		config.set_value("Trait", "Burnout", 0)
		config.set_value("Trait", "Depression", 0)
		config.set_value("Trait", "Heart", 0)
		config.set_value("Trait", "Serenity", 0)
		config.set_value("Trait", "Hope", 0)
		
		#Corey Skills
		config.set_value("Skill", "Scripting", 0)
		config.set_value("Skill", "Debugging", 0)
		config.set_value("Skill", "Computer Logic", 0)
		config.set_value("Skill", "Study", 0)
		config.set_value("Skill", "Experience", 0)
		
	
	else:
		config.load_path
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func save_dialogue_path(key: String, value):
	config.set_value("Scene", key, value)
	config.save(game_path)

func save_task_path(key: String, value):
	config.set_value("Task", key, value)
	config.save(game_path)

func save_traits(key: String, value):
	config.set_value("Trait", key, value)
	config.save(game_path)

func save_skills(key: String, value):
	config.set_value("Skill", key, value)
	config.save(game_path)

func save_status(key: String, value):
	config.set_value("Status", key, value)
	config.save(game_path)


func load_dialogue_path():
	var dialogue_tree = {}
	for key in config.get_section_keys("Scene"):
		dialogue_tree[key] = config.get_value("Scene", key)
	return dialogue_tree

func load_task_path():
	var task_tree = {}
	for key in config.get_section_keys("Task"):
		task_tree[key] = config.get_value("Task", key)
	return task_tree

func load_traits():
	var trait_tree = {}
	for key in config.get_section_keys("Trait"):
		trait_tree[key] = config.get_value("Train", key)
	return trait_tree

func load_skills():
	var skill_tree = {}
	for key in config.get_section_keys("Skill"):
		skill_tree[key] = config.get_value("Skill", key)
	return skill_tree

func load_status():
	var status_tree = {}
	for key in config.get_section_keys("Status"):
		status_tree[key] = config.get_value("Status", key)
	return status_tree
