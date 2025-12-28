extends Node

var config = ConfigFile.new()
const game_path = "User://game-one.ini"

var load_path = config.load(game_path)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func save_dialogue_path():
	pass

func save_task_path():
	pass

func save_traits():
	pass

func save_skills():
	pass

func save_status():
	pass



func load_dialogue_path():
	pass

func load_task_path():
	pass

func load_traits():
	pass

func load_skills():
	pass

func load_status():
	pass
