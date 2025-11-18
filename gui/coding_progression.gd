extends Control

@onready var task_progress_bar : TextureProgressBar = $Task_Progress_Bar
@onready var coding_bar : TextureProgressBar = $HBoxContainer/VBoxContainer/Coding_Bar
@onready var testing_bar : TextureProgressBar = $HBoxContainer/VBoxContainer/Testing_Bar
@onready var efficiency_bar : TextureProgressBar = $HBoxContainer/VBoxContainer/Efficiency_Bar
@onready var learning_bar : TextureProgressBar = $HBoxContainer/VBoxContainer/Learning_Bar
@onready var break_point_bar : TextureProgressBar = $Breakpoint_Progress_Bar
@onready var selector : Sprite2D = $HBoxContainer/VBoxContainer3/Selector_Sprite
@onready var critical_testing_bar : TextureProgressBar = $Critical_Testing_Bar
@onready var critical_debugging_bar : TextureProgressBar = $Critical_Debugging_Bar
@onready var critical_learning_bar : TextureProgressBar = $Criticial_Learning_Bar
@onready var progress_timer : Timer = $Progress_Timer
@onready var break_timer : Timer = $Break_Timer


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
@export var break_point_active : bool
@export var completion : bool

const default_tick = 1.0
var logic_mod : int = ProgressionBus.cory_skills["Computer Logic"]
var debug_mod : int = ProgressionBus.cory_skills["Debugging"]
var exp_mod : int = ProgressionBus.cory_skills["Experience"]
const code_pos = Vector2(0,5)
const test_pos = Vector2(0, 21)
const eff_pos = Vector2(0, 37)
const learn_pos = Vector2(0,53)

#Cursor Position
var current_pos = 0

#Task Difficulty/Bug Generation
var difficutly_level : int = 10
var bug_chance : int
var break_point_challenges = []
var break_point_traits = {
	"Rebound" : 0,
	"Puzzle" : 0.0,
	"Complexity" : 0.0,
	"Weight" : 0
}

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
	bug_check(5, 2, 3)
	break_point_init()
#	stability_check(2.2, 3.3, 4.4)

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
	
	
	if task_processing == true and break_point_active == false: #Begins processes for work bar calculations
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
			break_point_init()
		
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
		
		coding_bar.value += coding_tick
		testing_bar.value += testing_tick
		efficiency_bar.value += efficiency_tick
		learning_bar.value += learning_tick
		ProgressionBus.emit_signal("work_load_modify", work_load_mod)
		ProgressionBus.emit_signal("stress_modify", stress_mod)
		ProgressionBus.emit_signal("familiarity_update", familiarity_tick)
	
	else:
		pass
		
	
	bug_check(code_prog, test_prog, eff_prog) #Checks stability of code against bugs

#Handles Breakpoint Challenge Progression
func challenge_progress(active: bool):
	var break_bar = break_point_bar.value
	var test_value = critical_testing_bar.value
	var learn_value = critical_learning_bar.value
	var test_tick : float = 1.0
	var eff_tick : float = 1.0
	var learn_tick : float = 1.0
	var test_mod : float = 0.0
	var learn_mod : float = 1.0 + ((learn_value / 2) * 0.1)
	
	
	if testing == true:
		break_task("Testing", test_tick)
		
	
	elif efficiency == true:
		eff_tick += (test_mod * learn_mod)
		print("Debug: ", eff_tick)
		break_task("Debugging", eff_tick)
		
	
	elif learning == true:
		break_task("Learning", learn_tick)
		
	
	break_point_bar.value -= eff_tick + (critical_debugging_bar.value * 0.1)

func break_task(task: String, value: float):
	var test_cap = critical_testing_bar.max_value
	var debug_cap = critical_debugging_bar.max_value
	var learn_cap = critical_learning_bar.max_value
	print("Task: ", task)
	print("Value: ", value)
	
	match task:
		"Testing":
			critical_testing_bar.value += value
			var test_bar = critical_testing_bar.value
			print("Test: ", test_bar)
			if test_cap == test_bar and debug_cap == test_bar / 2:
				critical_debugging_bar.max_value += debug_cap
				print("Debug Cap: ", debug_cap)
		"Debugging":
			critical_debugging_bar.value += value
			var debug_bar = critical_debugging_bar.value
			print("Debug: ", debug_bar)
			if debug_bar == learn_cap and learn_cap == test_cap:
				critical_learning_bar.max_value += learn_cap
		"Learning":
			critical_learning_bar.value += value
			var learn_bar = critical_learning_bar.value
			print("Learn: ", learn_bar)
			if learn_cap == learn_bar and learn_cap == (test_cap * 2):
				critical_testing_bar.max_value += test_cap
				print("Test Cap: ", test_cap)
		
	

func break_impact():
	var experience = ProgressionBus.cory_skills["Experience"]
	
	var rebound = break_point_traits["Rebound"]
	var puzzle = break_point_traits["Puzzle"]
	var weight = break_point_traits["Weight"] - experience
	
	if testing == true:
		critical_debugging_bar.value -= puzzle
		critical_learning_bar.value -= puzzle
		
	elif efficiency == true:
		critical_learning_bar.value -= puzzle
		critical_testing_bar.value -= puzzle
		
	elif learning == true:
		critical_debugging_bar.value -= puzzle
		critical_testing_bar.value -= puzzle
	
	break_point_bar.value += rebound
	
	ProgressionBus.emit_signal("work_load_modify", weight)
	ProgressionBus.emit_signal("stress_modify", weight)
#	ProgressionBus.emit_signal("familiarity_update", familiarity_tick) #Revisit this one later

#Handles Calculation of the Probability of a Bug being generated
func bug_check(coding: float, testing: float, efficiency: float):
	var bug_base = difficutly_level * 5
	var bug_tick : float = 1.0
	var bug_chance : float
	var code_prog = int(coding)
	var test_prog = int(testing)
	var eff_prog = int(efficiency)
	
	var test_diff = code_prog - test_prog
	var eff_diff = code_prog - eff_prog
	
	if test_diff >= 1:
		bug_chance += (bug_tick * test_diff) + bug_base
#		print("Bug: ",bug_chance)
	
	
	bug_gen(bug_chance)
	bug_gen(bug_chance)
	bug_gen(bug_chance)
	bug_gen(bug_chance)
	bug_gen(bug_chance)

#Handles Calculations on when a Bug is generated
func bug_gen(bug_chance: float):
	var bugs = 1
	var bug_thresh = 100 - bug_chance
	var bug_roll = randi_range(1, 100)
	
	if bug_roll >= bug_thresh:
		bugs += 1
		break_check()
		
#	print("Thresh: ", bug_thresh)
#	print("Roll: ", bug_roll)
	
	bug_tally += bugs
#	print("Bugs: ", bug_tally)
	
	

#Handles the Probability of a Bug becoming a Breakpoint
func break_check():
	const break_min : float = 5.0
	var breakpoint_base : float = 90.0
	var difficulty_base : float = 5.0
	var break_chance : float
	
	
	break_chance += (breakpoint_base + difficulty_base) - (logic_mod + debug_mod + exp_mod)
	clampf(break_chance, 5, 100)
#	print("Breakpoint Chance: ", break_chance) #Why do we have this and break_point_chance????
	
	break_gen(break_chance)

#Handles the Generation of a Breakpoingt
func break_gen(chance: float):
	var break_point = 0
	var break_roll = randf_range(1, 100)
	var break_thresh = 100 - chance
	
	if break_roll >= break_thresh:
		break_point += 1
		break_points += break_point
		break_point_diff()
	
	
#	print("Breakpoint: ", break_points)

#Handles random generation of Breakpoint Difficulty and appends to Challenge List
func break_point_diff():
	var null_thresh = 0.0
	var standard = 70.0
	var complex = 90.0
	var difficulty = randf_range(1, 100)
	
	if difficulty < standard:
		break_point_challenges.append("Simple")
#		print("Breakpoint: Simple")
	
	elif difficulty >= standard and difficulty < complex:
		break_point_challenges.append("Standard")
#		print("Breakpoint: Standard")
	
	elif difficulty >= complex:
		break_point_challenges.append("Complex")
#		print("Breakpoint: Complex")
	
	if difficulty <= null_thresh and break_point_challenges[0] == "Simple":
		break_points -= 1
#		print("Breakpoint: Nullified")
	
	
	print(break_point_challenges)


#Handles Initialization Trigger of Breakpoint Progress Phase
func break_point_init(): #May add a bool para here
	var current_break = break_point_challenges[0]
	
	if break_points >= 1:
		break_point_active = true
		toggle_vis(task_progress_bar)
		toggle_vis(break_point_bar)
		task_stage_vis()
		break_timer.start()
		
	
	else:
		break_point_active = false
		toggle_vis(task_progress_bar)
		toggle_vis(break_point_bar)
		task_stage_vis()
	
	print("Challenge: ", current_break)
	break_point_config(current_break)

#Handles Visibility of Task Progression Bars 
func task_stage_vis():
	toggle_vis(coding_bar)
	toggle_vis(testing_bar)
	toggle_vis(efficiency_bar)
	toggle_vis(learning_bar)
	toggle_vis(critical_testing_bar)
	toggle_vis(critical_debugging_bar)
	toggle_vis(critical_learning_bar)

#Handles Configuration of Breakpoint Traits/Values based on Challenge Array entry
func break_point_config(challenge: String):
	var rebound : float = 0.0
	var puzzle : int = 0
	var complexity : float = 0.0
	var weight : float = 0.0
	print(challenge, "Begin")
	
	match challenge:
		"Simple":
			rebound = 50
			puzzle = 1
			complexity = 100
			weight = 3
			
		
		"Standard":
			rebound = 30
			puzzle = 2
			complexity = 150
			weight = 5
		
		"Complex":
			rebound = 15
			puzzle = 3
			complexity = 200
			weight = 10
			
	
	break_point_traits["Rebound"] = rebound
	break_point_traits["Puzzle"] = puzzle
	break_point_traits["Complexity"] = complexity
	break_point_traits["Weight"] = weight
	

#func run_check():
#	var error_threshold = 100 - break_point_chance
#	
#	for run in 100:
#		var bug_run = randi_range(1, 100)
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
	if break_point_active == true:
		challenge_progress(true)
	pass
#	production_growth(task_active)
#	print("Timer Timer")


func _on_break_timer_timeout() -> void:
	break_impact()
	pass # Replace with function body.
