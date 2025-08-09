extends Control

@onready var task_progress_bar : TextureProgressBar = $Task_Progress_Bar
@onready var coding_bar : TextureProgressBar = $HBoxContainer/VBoxContainer/Coding_Bar
@onready var testing_bar : TextureProgressBar = $HBoxContainer/VBoxContainer/Testing_Bar
@onready var efficiency_bar : TextureProgressBar = $HBoxContainer/VBoxContainer/Efficiency_Bar
@onready var learning_bar : TextureProgressBar = $HBoxContainer/VBoxContainer/Learning_Bar
@onready var selector : Sprite2D = $HBoxContainer/VBoxContainer3/Selector_Sprite
@onready var progress_timer : Timer = $Progress_Timer


@export var first_task : DialogueResource

@export var current_task : String
@export var progress : float = 0
@export var true_complete: bool
@export var bug_tally : int
@export var break_point_chance : float
@export var break_points : int

@export var broken_progress : float

@export var task_processing : bool
@export var task_active : bool
@export var coding : bool
@export var testing : bool
@export var efficiency : bool
@export var learning : bool
@export var completion : bool

const default_tick = 1.0
const code_pos = Vector2(0,5)
const test_pos = Vector2(0, 21)
const eff_pos = Vector2(0, 37)
const learn_pos = Vector2(0,53)

#var selector_pos = selector.position
var current_pos = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProgressionBus.connect("focus_production", production_growth)
	ProgressionBus.connect("added_task_progress", task_bar_raise)
	ProgressionBus.connect("task_start", start)
	ProgressionBus.connect("task_pause", pause)
	selector.global_position = Vector2(0,5)
#	production_growth(false)
	focus(true)
	selector.global_position = code_pos

func pause():
	task_processing = false
	task_active = false
	

func start():
	task_processing = true
	task_active = true
#	production_growth(true)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	detect_input(task_active)
	focus(task_active)
#	progress_check()


#Handles Input for Selecting Task Focus and Task Pause
func detect_input(active: bool):
	var task_bars : Array = [code_pos,
	test_pos,
	eff_pos,
	learn_pos
	]
	
#	print(task_bars[0])
	
	if active == true:
	
		if Input.is_action_just_pressed("ui_up"):
			current_pos -= 1
			if current_pos < 0:
				current_pos = 3
#			print(current_pos)
			selector.position = task_bars[current_pos]
#			print("Selector at ", selector.position)
			
		
		if Input.is_action_just_pressed("ui_down"):
			current_pos += 1
			if current_pos > 3:
				current_pos = 0
#			print(current_pos)
			selector.position = task_bars[current_pos]
#			print("Selector at ", selector.position)
	
#		if Input.is_action_just_pressed("task pause"):
#			if task_processing == true:
#				task_processing = false
#				ProgressionBus.emit_signal("action_prompt", "Cory")
#				production_growth(task_processing)
#			else:
#				task_processing = true
#				production_growth(task_processing)
			
		if Input.is_action_just_pressed("action"):
			if coding_bar.value == 100:
				ProgressionBus.emit_signal("production_complete")
	
	else:
		pass

func initiate():
	pass

func set_task_value(value: float):
	task_progress_bar.value = value
	


func task_bar_raise(task: String, prog: float, skills: Array):
	production_growth(true, skills)
	
	if coding == true:
		current_task = task
		task_progress_bar.value += prog
#		print(task, " + ", prog)
	else:
		pass



#func task_completion_check():
#	if task_bar.value >= 100 and demo_end.visible == false:
#		true_complete = true
#		toggle_vis(demo_end)
#		print("End Start")
#		demo_timer.start()


func toggle_vis(object):
	if object.visible == false:
		object.visible = true
	
	else:
		object.visible = false


#Handles Focus Progress for Calculations and Progress
func focus(active: bool):
	#Switch this to match?
	if task_active == false:
		selector.position = code_pos
	
	if active == true:
		if selector.position == code_pos:
			coding = true
#			print(coding)
		else:
			coding = false
		
		if selector.position == test_pos:
			testing = true
#			print(testing)
		else:
			testing = false
			
		if selector.position == eff_pos:
			efficiency = true
#			print(efficiency)
		else:
			efficiency = false
			
		if selector.position == learn_pos:
			learning = true
#			print(learning)

		else:
			learning = false
	else:
		pass

#Handles Progress Bar Ticks
func production_growth(active: bool, skills: Array):
	task_processing = active
	var coding_tick : float = 0.0
	var testing_tick : float = 0.0
	var efficiency_tick : float = 0
	var learning_tick : float = 0.0
	var work_load_mod : float = 0
	var stress_mod : float = 0
	var familiarity_tick : float = 0
	var code_prog = coding_bar.value
	var test_prog = testing_bar.value
	var eff_prog = efficiency_bar.value
	var learn_prog = learning_bar.value
	
	
	if task_processing == true: #Begins processes for work bar calculations
		var code = skills[0]
		var test = skills[1]
		var efficient = skills[2]
		var learn = skills[3]
#		progress_timer.start()
		
		if coding == true:
			coding_tick = code
			testing_tick =  test * -0.2
			efficiency_tick = efficient * -0.3
			learning_tick = learn * 0.2
			work_load_mod = 0.2
			stress_mod = 0.3
			familiarity_tick = 0.1
		
		elif testing == true:
			coding_tick = 0
			testing_tick = test
			efficiency_tick = efficient * 0.2
			learning_tick = learn * 0.2
			work_load_mod = 0.1
			stress_mod = 0.2
			familiarity_tick = 0.2
		
		elif efficiency == true:
			coding_tick = 0
			testing_tick = test * 0.2
			efficiency_tick = efficiency
			learning_tick = learn * 0.2
			work_load_mod = 0.5
			stress_mod = 0.5
			familiarity_tick = 0.3
			
		elif learning == true:
			coding_tick = 0
			testing_tick = 0
			efficiency_tick = 0
			learning_tick = learn
			work_load_mod = 0.2
			stress_mod = 0.5
			familiarity_tick = 0.5
	
	else:
		pass
#		progress_timer.stop()
	
	coding_bar.value += coding_tick
#	print("Is it on: ", code_prog)
	testing_bar.value += testing_tick
	efficiency_bar.value += efficiency_tick
	learning_bar.value += learning_tick
	
	ProgressionBus.emit_signal("work_load_modify", work_load_mod)
	ProgressionBus.emit_signal("stress_modify", stress_mod)
	ProgressionBus.emit_signal("familiarity_update", familiarity_tick)
	stability_check(code_prog, test_prog, eff_prog) #Checks stability of code against bugs

func stability_check(coding: float, testing: float, efficiency: float):
	const code_interval = 10
	var test_code_diff = (coding - testing) * -0.1
	var eff_code_diff = (coding - efficiency) * -0.1
	var error_chance = 0.0
	var testing_mod = 0.0
	var efficiency_mod = 0.0
	
	testing_mod += test_code_diff + 1
	efficiency_mod += eff_code_diff + 1
	
	
	error_chance += (testing_mod + efficiency_mod) * -1
#	print("Error Chance: ",error_chance, " %")
	
	ProgressionBus.emit_signal("error_check", error_chance)


func bug_check(error: float):
	var bugs = -1
#	break_point_chance = error
	
	if error >= 1:
		for bug in error:
			bugs += 1
			error -= 1
		
	
#	bug_tally = bugs
#	print("Bugs: ", bugs)
#	print("Breakpoint Chance: ", break_point_chance)


func run_check():
#	var error_threshold = 100 - break_point_chance
	
	for run in 100:
		var bug_run = randi_range(1, 100)
#		if bug_run >= error_threshold:
#			print("Bug Found: ",bug_run)
#			bug_tally += 1
		
#		else:
#			print("No Bug: ",bug_run)
#			continue
		
#	print("Bugs ", bug_tally)
#	broken_progress += bug_tally

func progress_check():
	if coding_bar.value == 100 and completion == false:
		completion = true
#		ProgressionBus.emit_signal("production_complete")


func _on_progress_timer_timeout() -> void:
	pass
#	production_growth(task_active)
#	print("Timer Timer")
