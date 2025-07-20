extends TextureProgressBar


@onready var task_bar : TextureProgressBar = $"."
@onready var prog_label : Label = $Prog_Label
@onready var label_timer : Timer = $Label_Timer
@onready var final_check : VBoxContainer = $Finalize_Tab

@export var current_task : String
@export var progress : float = 0
@export var true_complete: bool
@export var bug_tally : int
@export var break_points : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProgressionBus.connect("added_task_progress", task_bar_raise)
	ProgressionBus.connect("task_tracking_state", set_task_value)
	ProgressionBus.connect("error_check", bug_check)
	ProgressionBus.connect("run_task", run_check)
	true_complete = false
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	task_completion_check()
#	task_progress_bar.value += progress

func toggle_vis(object):
	if object.visible == false:
		object.visible = true
	
	else:
		object.visible = false

func set_task_value(value: float):
	task_bar.value = value

func task_bar_raise(task: String, prog: float):
	if label_timer.is_stopped():
		label_timer.start()
	toggle_vis(prog_label)
	current_task = task
	task_bar.value += prog
	prog_label.text = str(prog)
	print(task, " + ", prog)
	

func task_completion_check():
	if task_bar.value == 100 and task_bar.visible == true:
		toggle_vis(final_check)
		
		
		
#		toggle_vis(task_bar)
#		ProgressionBus.emit_signal("task_completed", current_task, false)
#		ProgressionBus.emit_signal("complete_task_state", "Cory")
#		print("Task Complete")
	

func bug_check(error: float):
	var bugs = -1
	
	if error > 1:
		for bug in error:
			bugs += 1
			error -= 1
		
	
	bug_tally = bugs
	print("Bugs: ", bugs)

func run_check():
	var error_threshold = break_points
	
	pass

func _on_label_timer_timeout() -> void:
	toggle_vis(prog_label)


func _on_run_button_button_down() -> void:
	pass # Replace with function body.


func _on_debug_button_button_down() -> void:
	pass # Replace with function body.


func _on_exit_button_button_down() -> void:
	pass # Replace with function body.
