extends Control


@onready var action_menu : Control = $"."
@onready var task_choice : Button = $Action_List/Task_Button
@onready var break_choice : Button = $Action_List/Break_Button
@onready var leave_choice : Button = $Action_List/Leave_Button

@export var current_task : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProgressionBus.connect("task_option_update", task_update)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func toggle_vis(object):
	if object.visible == false:
		object.visible = true
	
	else:
		object.visible = false

func task_update(task: String, state: String):
	toggle_vis(action_menu)
	task_choice.text = task
	current_task = state
	print("Updated to ", current_task)
#	print(task, " Received")


func _on_task_button_button_down() -> void:
	if current_task == "Working" or current_task == "Problem Solving" or current_task == "Brainstorming":
		ProgressionBus.emit_signal("action_initiated", current_task, true)
		toggle_vis(action_menu)
		print("Start Task")
		


func _on_break_button_button_down() -> void:
	ProgressionBus.emit_signal("action_initiated", "Break", true)
	toggle_vis(action_menu)
	print("Start Break")
	

func _on_leave_button_button_down() -> void:
	toggle_vis(action_menu)
