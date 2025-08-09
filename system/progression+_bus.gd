extends Node

#Scene Signals
signal transition
signal ready_scene
signal start_scene
signal store_scene
signal end_scene


#Start/Stop Signals
signal start_game
signal end_intro
signal game_start
signal task_start
signal task_pause
signal end_demo

#Task Signals
signal call
signal call2
signal added_task_progress
signal stress_modify
signal work_load_modify
signal familiarity_update
signal stat_add
signal stat_sub
signal update_stat_panel

#Action Signals
signal action_prompt
signal task_option_update
signal task_tracking_state

signal action_initiated
signal task_completed
signal complete_task_state
signal break_completed
#signal task_progress_logging


signal focus_input
signal focus_production
signal run_task
signal error_check
signal debug_task

signal start_work
signal computer_screen
signal stop_work
signal apartment_scene

@export var test_scene: DialogueResource

@export var scene_one: DialogueResource
@export var scene_two: DialogueResource
@export var scene_three: DialogueResource
@export var scene_four: DialogueResource
@export var scene_five: DialogueResource
@export var scene_six: DialogueResource
@export var scene_seven: DialogueResource
@export var scene_eight: DialogueResource


@export var ultimate_scene: DialogueResource

var scene_dict = {
	"Greeting": "Scene One",
	"First Morning": "Scene Two",
	"Day One": "Scene Three",
	"One Week Later": "Scene Four",
	"First Task": "Scene Five"
	
	
	
	
}

var scene_completion_dict = {
	"Test Scene": false,
	"Scene One": false,
	"Scene Two": false,
	"Scene Three": false,
	"Scene Four": false,
	"Scene Five": false,
	"Scene Six": false,
	"Scene Seven": false,
	"Scene Eight": false,
	"Ultimate Scene": false
}



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("call", add_stat) #add_stat.bind("calm", 1))
	connect("call2", sub_stat)
	connect("action_prompt", task_completion_check)
	connect("complete_task_state", complete_current_task)
	connect("start_scene", scene_change)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Handles all Scene Changes
func scene_change(scene: String):
	print(scene)
	if scene_completion_dict[scene] == false:
		match scene:
			"Test Scene":
				DialogueManager.show_dialogue_balloon(test_scene, "start")
			"Scene One":
#				print("Matched!")
				DialogueManager.show_dialogue_balloon(scene_one, "start")
			"Scene Two":
#				print("Matched!")
				DialogueManager.show_dialogue_balloon(scene_two, "start")
			"Scene Three":
#				print("Matched!")
				DialogueManager.show_dialogue_balloon(scene_three, "start")
			"Scene Four":
				DialogueManager.show_dialogue_balloon(scene_four, "start")
			"Scene Five":
				DialogueManager.show_dialogue_balloon(scene_five, "start")
			"Scene Six":
				DialogueManager.show_dialogue_balloon(scene_six, "start")
			"Scene Seven":
				DialogueManager.show_dialogue_balloon(scene_seven, "start")
			"Scene Eight":
				DialogueManager.show_dialogue_balloon(scene_eight, "start")
	
	else:
		pass


var cory_traits= {
	"Patience" = 0,
	"Perseverance" = 0,
	"Motivation" = 0,
	"Creativity" = 0,
	"Focus" = 0,
	"Insight" = 0,
	"Anxiety" = 0,
	"Lethargy" = 0,
	"Frailty" = 0,
	"Stress" = 0,
	"Strain" = 0,
	"Burnout" = 0,
	"Depression" = 0,
	"Heart" = 0,
	"Serenity" = 0,
	"Hope" = 0,
}

var cory_skills = {
	"Scripting" = 0,
	"Debugging" = 0,
	"Computer Logic" = 0,
	"Study" = 0,
	"Experience" = 0
}

var cory_condition = {
	"Anxiety": 10,
	"Frailty": 0,
	"Lethargy": 0,
	"Depression": 0
}

var cory_task_status = {
	"Task Started" : false,
	"Task Stuck": false,
	"Task Completed": false,
}

var cory_task_tracker = {
	"Brainstorming": 0.0,
	"Working": 0.0,
	"Problem Solving": 0.0,
	"Coding" : 0.0,
	"Testing": 0.0,
	"Efficiency": 0.0,
	"Learning": 0.0
}


var cory_task_list = {
	"Task One" : false,
	"Task Two" : false,
	"Task Three" : false,
	"Task Four" : false,
	"Task Five" : false
}

var lucy_condition = {
	"Anxiety": 10,
	"Frailty": 0,
	"Lethargy": 0,
	"Depression": 0
}

var lucy_task_tracker = {
	"Task Started" : false,
	"Task Brainstorming": 0.0,
	"Task Progress": 0.0,
	"Taskv Stuck": false,
	"Task Problem Solve": 0.0,
	"Task Completed": false,
	
}

var lucy_task_list = {
	"Task One" : false,
	"Task Two" : false,
	"Task Three" : false,
	"Task Four" : false,
	"Task Five" : false
}


func add_stat(char: String, stat: String, value: int):
	emit_signal("stat_add", char, stat)

func sub_stat(char: String, stat: String, value: int):
	emit_signal("stat_sub", char, stat)

#Handles accessing of available task
func task_completion_check(char: String):
	if char == "Cory":
		for task in cory_task_list:
			if cory_task_list[task] == false:
				var task_state = task_progress(char)
				emit_signal("task_option_update", task, task_state)
				print(task)
				return task
			else:
				continue
	
	elif char == "Lucy":
		for task in lucy_task_list:
			if lucy_task_list[task] == false:
				emit_signal("task_option_update", task)
				return task
			else:
				continue
	

#Handles checking of task progression state
func task_progress(char: String):
	var progress_meters : Array = ["Brainstorming", "Working", "Problem Solving"]
	var task_mark = 0
	
	if char == "Cory":
		for state in cory_task_status:
			var progress_check = progress_meters[task_mark]
			if cory_task_status[state] == false:
#				print("Task Progress: ",cory_task_tracker[progress_check])
				emit_signal("task_tracking_state", cory_task_tracker[progress_check])
#				print("Progress is ", progress_check)
				return progress_check
			else:
				task_mark += 1
	
	elif char == "Lucy":
		pass

func complete_current_task(char: String):
	if char == "Cory":
		for task in cory_task_status:
			if cory_task_status[task] == true:
				print("Next")
				continue
			else:
				cory_task_status[task] = true
				cory_task_tracker[task] = 0.0
				break
	
	if cory_task_status["Task Completed"] == true:
		for task in cory_task_list:
			if cory_task_list[task] == true:
				continue
			else:
				cory_task_list[task] = true
				print("Task One Complete")
				
				for state in cory_task_status:
					cory_task_status[state] = false
				
				for value in cory_task_tracker:
					cory_task_tracker[value] = 0.0
				break
