extends Node


@onready var main : Node = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProgressionBus.connect("computer_screen", load_work_scene)
	ProgressionBus.connect("apartment_scene", load_apartment)
	ProgressionBus.connect("end_demo", end_demo)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func end_demo():
	var main_menu = preload("res://gui/main_menu.tscn")
	var return_menu = main_menu.instantiate()
	add_sibling(return_menu)
	main.queue_free()
	

func load_work_scene():
	var work_scene = preload("res://gui/work_screen.tscn")
	var start_work = work_scene.instantiate()
	add_child(start_work)
	ProgressionBus.emit_signal("start_work")
	

func load_apartment():
	var apartment_scene = preload("res://levels/apartment_room.tscn")
	var stop_work = apartment_scene.instantiate()
	add_child(stop_work)
	ProgressionBus.emit_signal("stop_work")
