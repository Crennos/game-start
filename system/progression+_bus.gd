extends Node

signal call
signal call2
signal added_task_progress
signal stat_add
signal stat_sub

signal action_prompt
signal task_option_update
signal task_tracking_state

signal task_initiated
signal task_completed
signal task_progress_logging

signal break_initiated
signal break_completed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("call", add_stat) #add_stat.bind("calm", 1))
	connect("call2", sub_stat)
	connect("action_prompt", task_completion_check)
#	connect()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


var cory_condition = {
	"Anxiety": 10,
	"Frailty": 0,
	"Lethargy": 0,
	"Depression": 0
}

var cory_task_status = {
	"Task Started" : false,
	"Taskv Stuck": false,
	"Task Completed": false,
}

var cory_task_tracker = {
	"Task Brainstorming": 25.0,
	"Task Progress": 2.0,
	"Task Problem Solve": 4.0
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
#				print(task)
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
	var progress_meters : Array = ["Task Brainstorming", "Task Progress", "Task Problem Solve"]
	var task_mark = 0
	
	if char == "Cory":
		for state in cory_task_status:
			var progress_check = progress_meters[task_mark]
			if cory_task_status[state] == false:
#				print("Task Progress: ",cory_task_tracker[progress_check])
				emit_signal("task_tracking_state", cory_task_tracker[progress_check])
				print("Progress is ", progress_check)
				return progress_check
			else:
				task_mark += 1
	
	elif char == "Lucy":
		pass


#func task_progress(increment, delta):
#	pass
