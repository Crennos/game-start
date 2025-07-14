extends Node

signal call

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("call", add_stat) #add_stat.bind("calm", 1))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_stat(stat: String, value: int):
	print("+", value," ", stat)
