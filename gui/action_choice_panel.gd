extends Control


@onready var task_choice : Button = $Action_List/Task_Button
@onready var break_choice : Button = $Action_List/Break_Button
@onready var leave_choice : Button = $Action_List/Leave_Button



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProgressionBus.connect("task_option_update", task_update)
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func task_update(task: String):
	task_choice.text = task
	print(task, " Received")
