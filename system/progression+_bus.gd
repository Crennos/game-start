extends Node

signal call
signal call2
signal added_trask_progress
signal stat_add
signal stat_sub


var ten : int = 10

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

var lucy_condition = {
	"Anxiety": 10,
	"Frailty": 0,
	"Lethargy": 0,
	"Depression": 0
}

func add_stat(char: String, stat: String, value: int):
	print(char, " gained +", value," ", stat)
	emit_signal("stat_add", char, stat)

func sub_stat(char: String, stat: String, value: int):
	print(char, " lost -", value," ", stat)
	emit_signal("stat_sub", char, stat)

func task_progress(increment, delta):
	pass
