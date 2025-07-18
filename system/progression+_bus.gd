extends Node

signal call
signal call2
signal added_task_progress
signal stat_add
signal stat_sub



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("call", add_stat) #add_stat.bind("calm", 1))
	connect("call2", sub_stat)
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

var cory_task_tracker = {
	"Task Started" : false,
	"Task Brainstorming": 0.0,
	"Task Progress": 0.0,
	"Taskv Stuck": false,
	"Task Problem Solve": 0.0,
	"Task Completed": false,
	
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
#	print(char, " gained +", value," ", stat)
	emit_signal("stat_add", char, stat)

func sub_stat(char: String, stat: String, value: int):
#	print(char, " lost -", value," ", stat)
	emit_signal("stat_sub", char, stat)

func task_progress(increment, delta):
	pass
