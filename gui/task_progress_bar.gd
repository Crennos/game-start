extends TextureProgressBar


@onready var task_bar : TextureProgressBar = $"."
@onready var prog_label : Label = $Prog_Label
@onready var label_timer : Timer = $Label_Timer
@onready var final_check : VBoxContainer = $Finalize_Tab
@onready var demo_end : Label = $Demo_End
@onready var demo_timer: Timer = $Demo_Timer

@export var first_task : DialogueResource

@export var current_task : String
@export var progress : float = 0
@export var true_complete: bool
@export var bug_tally : int
@export var break_point_chance : float
@export var break_points : int

@export var broken_progress : float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProgressionBus.connect("added_task_progress", task_bar_raise)
	ProgressionBus.connect("task_tracking_state", set_task_value)
	ProgressionBus.connect("production_complete", run_prompt)
	ProgressionBus.connect("error_check", bug_check)
	ProgressionBus.connect("run_task", run_check)
	ProgressionBus.connect("first_boot", first_boot)
	ProgressionBus.connect("boot_ready", boot_ready)
	ProgressionBus.connect("focus_boost", focus_tick)
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	task_completion_check()
#	task_progress_bar.value += progress


func first_boot():
	true_complete = true
	DialogueManager.show_dialogue_balloon(task_bar.first_task, "start")

func boot_ready():
	true_complete = false

func toggle_vis(object):
	if object.visible == false:
		object.visible = true
	
	else:
		object.visible = false

func run_prompt():
	toggle_vis(final_check)

func set_task_value(value: float):
	task_bar.value = value

func task_bar_raise(task: String, prog: float):
	if true_complete == false:
		if label_timer.is_stopped():
			label_timer.start()
		toggle_vis(prog_label)
		current_task = task
		task_bar.value += prog
		prog_label.text = str(prog)
		print(task, " + ", prog)
	


func task_completion_check():
	if task_bar.value >= 100 and demo_end.visible == false:
		true_complete = true
		toggle_vis(demo_end)
		print("End Start")
		demo_timer.start()

func focus_tick(code: float):
	if true_complete == false:
		task_bar.value += code
	else:
		pass

func bug_check(error: float):
	var bugs = -1
	break_point_chance = error
	
	if error >= 1:
		for bug in error:
			bugs += 1
			error -= 1
		
	
	bug_tally = bugs
	print("Bugs: ", bugs)
	print("Breakpoint Chance: ", break_point_chance)

func run_check():
	var error_threshold = 100 - break_point_chance
	
	for run in 100:
		var bug_run = randi_range(1, 100)
		if bug_run >= error_threshold:
			print("Bug Found: ",bug_run)
			bug_tally += 1
		
		else:
			print("No Bug: ",bug_run)
			continue
		
	print("Bugs ", bug_tally)
	broken_progress += bug_tally

func _on_label_timer_timeout() -> void:
	toggle_vis(prog_label)


func _on_run_button_button_down() -> void:
	run_check()


func _on_debug_button_button_down() -> void:
	pass # Replace with function body.


func _on_exit_button_button_down() -> void:
	ProgressionBus.emit_signal("stop_work")


func _on_demo_timer_timeout() -> void:
	print("Quit")
	print("Quit")
	print("Quit")
	print("Quit")
	ProgressionBus.emit_signal("end_demo")
