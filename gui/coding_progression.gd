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

#Labels
@onready var code_prog_label : Label = $Code_Bar_Prog
@onready var test_prog_label : Label = $Test_Bar_Prog
@onready var eff_prog_label : Label = $Eff_Bar_Prog
@onready var learn_prog_label : Label = $Learn_Bar_Prog
@onready var task_prog_label : Label = $Task_Bar_Prog
@onready var break_prog_label : Label = $Break_Bar_Prog
@onready var code_text_tick : Label =$Code_Tick_Text
@onready var test_text_tick : Label =$Test_Tick_Text
@onready var eff_text_tick : Label = $Eff_Tick_Text
@onready var learn_text_tick : Label = $Learn_Tick_Text
@onready var bugs_text : Label = $Bug_Count_Text
@onready var simple_bugs_text : Label = $Simple_Bugs_Text
@onready var standard_bugs_text : Label = $Standard_Bugs_Text
@onready var complex_bugs_text : Label = $Complex_Bugs_Text

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
@export var debugging : bool

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
var difficulty_level : int = 1
var bug_chance : int
var bug_simple_count : int
var bug_standard_count : int
var bug_complex_count : int
var bug_eff_limit : float = 100
var break_point_challenges = []
var bug_log = {
	"Hidden Bugs" : [],
	"Test Thresh" : 0,
	"Found Bugs" : [],
	"Bug Health" : 0,
	"Break Bugs" : [],
	"Break Count" : 0
	}
var effi_marks = {
	"Temp" : 0,
	"Perm" : 0
}
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
	label_handler(0,0,0,0)
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
	break_point_complete()
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

func label_handler(code: float, test: float, eff : float, learn: float):
	var code_bar : float
	var code_cap : float
	var eff_bar : float
	var eff_cap : float
	var test_bar : float
	var test_cap : float
	var learn_bar : float
	var learn_cap : float
	var task_bar : float = 0
	var task_cap : float = 0
	var break_bar : float = 0
	var break_cap : float = 0
	var tick_dict = {
		"Type" : ["Code", "Test", "Eff", "Learn"],
		"Tick" : [code, test, eff, learn]
	}
#	print(tick_dict)
	
	if task_active == true and break_point_active == false:
		code_bar = coding_bar.value
		code_cap = coding_bar.max_value
		eff_bar = efficiency_bar.value
		eff_cap = efficiency_bar.max_value
		test_bar = testing_bar.value
		test_cap = testing_bar.max_value
		learn_bar = learning_bar.value
		learn_cap = learning_bar.max_value
		task_bar = task_progress_bar.value
		task_cap = task_progress_bar.max_value
	
	elif break_point_active == true:
		eff_bar = critical_debugging_bar.value
		eff_cap = critical_debugging_bar.max_value
		test_bar = critical_testing_bar.value
		test_cap = critical_testing_bar.max_value
		learn_bar = critical_learning_bar.value
		learn_cap = critical_learning_bar.max_value
		break_bar = break_point_bar.value
		break_cap = break_point_bar.max_value
	
	for tick in range(4):
		var tick_text : String
		
		if tick_dict["Tick"][tick] == 0:
			tick_text = ""
			
		elif tick_dict["Tick"][tick] > 0:
			tick_text = "+ " + str(tick_dict["Tick"][tick])
			
		elif tick_dict["Tick"][tick] < 0:
			tick_text = str(tick_dict["Tick"][tick])
			
		
		match tick_dict["Type"][tick]:
			"Code":
				if tick_text == "":
					code_text_tick.visible = false
				else:
					code_text_tick.visible = true
					code_text_tick.text = tick_text
			"Test":
				if tick_text == "":
					code_text_tick.visible = false
				else:
					test_text_tick.visible = true
					test_text_tick.text = tick_text
			"Eff":
				if tick_text == "":
					code_text_tick.visible = false
				else:
					eff_text_tick.visible = true
					eff_text_tick.text = tick_text
			"Learn":
				if tick_text == "":
					code_text_tick.visible = false
				else:
					learn_text_tick.visible = true
					learn_text_tick.text = tick_text
	
	code_prog_label.text = str(code_bar) + "/" + str(code_cap)
	test_prog_label.text = str(test_bar) + "/" + str(test_cap)
	eff_prog_label.text = str(eff_bar) + "/" + str(eff_cap)
	learn_prog_label.text = str(learn_bar) + "/" + str(learn_cap)
	task_prog_label.text = str(task_bar) + "/" + str(task_cap)
	break_prog_label.text = str(break_bar) + "/" + str(break_cap)
	simple_bugs_text.text = "Simple: " + str(bug_simple_count)
	standard_bugs_text.text = "Standard: " + str(bug_standard_count)
	complex_bugs_text.text = "Complex " + str(bug_complex_count)
	

#What was this for again?
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
			bug_check(code_prog, test_prog, eff_prog) #Checks stability of code against bugs
		
		elif testing == true:
			coding_tick = 0
			testing_tick = test
			efficiency_tick = efficient * 0.2
			learning_tick = learn * 0.2
			work_load_mod = 0.1
			stress_mod = 0.2
			familiarity_tick = 0.2
			break_point_init()
			bug_finder()
		
		elif efficiency == true and debugging == false:
#			clampf(efficiency_bar.value, 0.0, bug_eff_limit)
			clampf(efficiency_bar.max_value, 25, bug_eff_limit)
			coding_tick = 0
			testing_tick = test * 0.2
			efficiency_tick = efficiency
			learning_tick = learn * 0.2
			work_load_mod = 0.5
			stress_mod = 0.5
			familiarity_tick = 0.3
			bug_health_check(efficiency_bar.value)
			
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
		label_handler(coding_tick, testing_tick, efficiency_tick, learning_tick)
		ProgressionBus.emit_signal("work_load_modify", work_load_mod)
		ProgressionBus.emit_signal("stress_modify", stress_mod)
		ProgressionBus.emit_signal("familiarity_update", familiarity_tick)
	
	else:
		pass
	

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
	
	if break_point_active == true:
		if testing == true:
			break_task("Testing", test_tick)
			
		
		elif efficiency == true:
			eff_tick += (test_mod * learn_mod)
#			print("Debug: ", eff_tick)
			break_task("Debugging", eff_tick)
			
		
		elif learning == true:
			break_task("Learning", learn_tick)
			
		
		break_point_bar.value -= eff_tick + (critical_debugging_bar.value * 0.1)

#Handles Calculations for Breakpoint Progress Ticks
func break_task(task: String, value: float):
	var test_cap = critical_testing_bar.max_value
	var debug_cap = critical_debugging_bar.max_value
	var learn_cap = critical_learning_bar.max_value
#	print("Task: ", task)
#	print("Value: ", value)
	
	match task:
		"Testing":
			critical_testing_bar.value += value
			var test_bar = critical_testing_bar.value
#			print("Test: ", test_bar)
			if test_cap == test_bar and debug_cap == test_bar / 2:
				critical_debugging_bar.max_value += debug_cap
#				print("Debug Cap: ", debug_cap)
		"Debugging":
			critical_debugging_bar.value += value
			var debug_bar = critical_debugging_bar.value
#			print("Debug: ", debug_bar)
			if debug_bar == learn_cap and learn_cap == test_cap:
				critical_learning_bar.max_value += learn_cap
		"Learning":
			critical_learning_bar.value += value
			var learn_bar = critical_learning_bar.value
#			print("Learn: ", learn_bar)
			if learn_cap == learn_bar and learn_cap == (test_cap * 2):
				critical_testing_bar.max_value += test_cap
#				print("Test Cap: ", test_cap)
		
	

#Handles Regression from Breakpoint on Progress Bars
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
	var bug_base = difficulty_level * 5
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


#Handles Calculations on when a Bug is generated
func bug_gen(bug_chance: float):
	var bug_thresh = 100 - bug_chance
	var bug_roll = randi_range(1, 100)
	
	if bug_roll >= bug_thresh:
		bug_diff()
		
	else:
		pass

#Handles Generative Difficulty of each spawned Bug
func bug_diff():
	var difficulty : String
	var current_test : float = testing_bar.value
	var test_thresh : float
	var bug_simple = 0.0
	var bug_standard = 50.0
	var bug_complex = 80.0
	var bug_roll = randf_range(0.0, 100.0)
	
	
	if bug_roll >= bug_simple and bug_roll < bug_standard:
		difficulty = "Simple"
		break_check()
		if break_check() == true:
			bug_log["Break Bugs"].append(difficulty)
			bug_log["Break Count"] += 1
			print(bug_log["Break Bugs"])
			print("Break Count + ", bug_log["Break Count"])
			
		else:
			bug_log["Hidden Bugs"].append(difficulty)
			print(bug_log)
			print("Simple Bugs: ", bug_simple_count + 1)
		
			bug_marker(5)
	
	elif bug_roll >= bug_standard and bug_roll < bug_complex:
		difficulty = "Standard"
		break_check()
		if break_check() == true:
			bug_log["Break Bugs"].append(difficulty)
			bug_log["Break Count"] += 1
			print(bug_log["Break Bugs"])
			print("Break Count + ", bug_log["Break Count"])
		
		else: 
			bug_log["Hidden Bugs"].append(difficulty)
			print(bug_log)
			print("Standard Bugs: ", bug_standard_count + 1)
			bug_marker(3)
	
	elif bug_roll >= bug_complex:
		difficulty = "Complex"
		break_check()
		if break_check() == true:
			bug_log["Break Bugs"].append(difficulty)
			bug_log["Break Count"] += 1
			print(bug_log["Break Bugs"])
			print("Break Count + ", bug_log["Break Count"])
			
		else:
			bug_log["Hidden Bugs"].append(difficulty)
			print(bug_log)
			print("Complex Bugs: ", bug_complex_count + 1)
			bug_marker(5)
	

#Handles Marking of Current and Next Test Thresholds
func bug_marker(mark : int):
	var current_test = testing_bar.value
	
	if bug_log["Test Thresh"] == 0:
		bug_log["Test Thresh"] = mark + current_test
		print("Test Thresh ", bug_log["Test Thresh"])
	
	
	else:
		print("Test Thresh Already Exists")
		pass

#Handles the Testing's Detection of Hidden Bugs
func bug_finder():
	var hidden_bugs = bug_log["Hidden Bugs"]
	
	if hidden_bugs.is_empty() == false:
		var current_test = testing_bar.value
		var bug_level = bug_log["Hidden Bugs"][0]
		var test_mark = bug_log["Test Thresh"]
		
		if current_test >= test_mark:
			match bug_log["Hidden Bugs"][0]:
				"Simple":
					print("Found 1: ", bug_level, " Bug")
					bug_log["Hidden Bugs"].erase(bug_level)
					print(bug_log, " Bug No Longer Hidden")
					bug_log["Found Bugs"].append(bug_level)
					print(bug_log["Found Bugs"][-1], " Now Discovered")
					bug_log["Test Thresh"] = 0
					bug_simple_count += 1
					bug_trigger("Simple")
					bug_marker(5)
				"Standard":
					print("Found 1: ", bug_level, " Bug")
					bug_log["Hidden Bugs"].erase(bug_level)
					print(bug_log, " Bug No Longer Hidden")
					bug_log["Found Bugs"].append(bug_level)
					print(bug_log["Found Bugs"][-1], " Now Discovered")
					bug_log["Test Thresh"] = 0
					bug_standard_count += 1
					bug_trigger("Standard")
					bug_marker(3)
				"Complex":
					print("Found 1: ", bug_level, " Bug")
					bug_log["Hidden Bugs"].erase(bug_level)
					print(bug_log, " Bug No Longer Hidden")
					bug_log["Found Bugs"].append(bug_level)
					print(bug_log["Found Bugs"][-1], " Now Discovered")
					bug_log["Test Thresh"] = 0
					bug_complex_count += 1
					bug_trigger("Complex")
					bug_marker(5)
		
		else:
			pass
	else:
		pass

#Handles Logging of Bugs
func bug_trigger(difficulty: String):
	match difficulty:
		"Simple":
			print("Simple Trigger")
			coding_bar.value -= 2
			learning_bar.max_value -= 3
			efficiency_bar.max_value -= 1
			task_progress_bar.value -= 1
		"Standard":
			print("Standard Trigger")
			coding_bar.value -= 5
			learning_bar.max_value -= 5
			efficiency_bar.max_value -= 3
			task_progress_bar.value -= 3
		"Complex":
			print("Complex Trigger")
			coding_bar.value -= 8
			learning_bar.max_value -= 10
			efficiency_bar.max_value -= 5
			task_progress_bar.value -= 5
	
	var max_eff = efficiency_bar.max_value
	print("Eff Limit: ", max_eff)

#Handles Checking of Bug Health vs Efficiency Prog
func bug_health_check(efficiency : float):
	var bug_health : int
	var eff_prog = efficiency_bar.value
	var temp_eff : float
	var perm_eff : float
	
	if bug_log["Found Bugs"].is_empty() == false:
		var target_bug = bug_log["Found Bugs"][0]
		
		if bug_log["Bug Health"] == 0:
			match bug_log["Found Bugs"][0]:
				"Simple":
					bug_health = 5
					perm_eff = bug_health * 0.4
					temp_eff = bug_health * 0.8
					effi_marks["Temp"] = temp_eff
					effi_marks["Perm"] = perm_eff
					print("Temp: ", temp_eff)
				"Standard":
					bug_health = 10
					perm_eff = bug_health * 0.6
					temp_eff = bug_health * 0.6
					effi_marks["Temp"] = temp_eff
					effi_marks["Perm"] = perm_eff
					print("Temp: ", temp_eff)
				"Complex":
					bug_health = 25
					perm_eff = bug_health * 0.8
					temp_eff = bug_health * 0.4
					effi_marks["Temp"] = temp_eff
					effi_marks["Perm"] = perm_eff
					print("Temp: ", temp_eff)
				
			bug_log["Bug Health"] = bug_health + eff_prog
			print("Bug Health: ", bug_log["Bug Health"])
	
		bug_kill(bug_health, target_bug)
	
	else:
		pass

#Handles Deletion of Bug and its Effects
func bug_kill(bug_health : int, target : String):
	var eff_prog = efficiency_bar.value
	var bug_level = bug_log["Found Bugs"][0]
	
	if eff_prog >= bug_log["Bug Health"]:
		bug_log["Bug Health"] = 0
		 
		match target:
			"Simple":
				bug_simple_count -= 1
				print(bug_level, " Bug Erased")
				bug_log["Found Bugs"].erase(bug_level)
				print("New Bug List: ", bug_log["Found Bugs"])
			"Standard":
				bug_standard_count -= 1
				print(bug_level, " Bug Erased")
				bug_log["Found Bugs"].erase(bug_level)
				print("New Bug List: ", bug_log["Found Bugs"])
			"Complex":
				bug_complex_count -= 1
				print(bug_level, " Bug Erased")
				bug_log["Found Bugs"].erase(bug_level)
				print("New Bug List: ", bug_log["Found Bugs"])
		
		efficiency_bar.value -= effi_marks["Temp"]
		efficiency_bar.max_value += effi_marks["Perm"]
		
	else:
		pass


#Handles the Probability of a Bug becoming a Breakpoint
func break_check():
	const break_min : float = 95.0
	var breakpoint_base : float = 5.0
	var difficulty_base : float = 5.0
	var break_chance : float
	var break_point = 0
	var break_roll = randf_range(1, 100)
	var break_thresh = 100
	
	break_chance += (breakpoint_base + difficulty_base) - (logic_mod + debug_mod + exp_mod)
	print("BC ", break_chance)
	clampf(break_chance, 5, 100)
	break_thresh = 100 - (break_chance + break_min)
	print("BT ", break_thresh)
	print("Run Check")
	
	if break_roll >= break_thresh:
		print("True")
		return true
	
	else:
		print("False")
		return false

#Handles Initialization Trigger of Breakpoint Progress Phase
func break_point_init(): 
	var origin_bug : String
	var break_count = bug_log["Break Count"]
	
	print("Breakpoint Tally: ", break_points)
	if break_count >= 1 and break_point_active == false:
		origin_bug = bug_log["Break Bugs"][-1]
		break_point_active = true
		toggle_vis(task_progress_bar)
		toggle_vis(break_point_bar)
		task_stage_vis()
		break_timer.start()
		


	elif break_count == 0 and break_point_active == true:
		break_point_active = false
		toggle_vis(task_progress_bar)
		toggle_vis(break_point_bar)
		task_stage_vis()
	
	print("Challenge: ", origin_bug)
	break_point_config(origin_bug)

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
			rebound = 1
			puzzle = 1
			complexity = 100
			weight = 3
			
		
		"Standard":
			rebound = 2
			puzzle = 2
			complexity = 150
			weight = 5
		
		"Complex":
			rebound = 3
			puzzle = 3
			complexity = 200
			weight = 10
			
	
	break_point_traits["Rebound"] = rebound
	break_point_traits["Puzzle"] = puzzle
	break_point_traits["Complexity"] = complexity
	break_point_traits["Weight"] = weight
	

#Handles Resetting Breakpoint Bars
func break_reset():
	break_point_bar.value = 100.0
	critical_debugging_bar.value = 0.0
	critical_testing_bar.value = 0.0
	critical_learning_bar.value = 0.0

#Handles Completion of Breakpoint Challenge
func break_point_complete():
	if break_point_bar.value == 0.0 and break_point_active == true:
		break_point_active = false
		bug_log["Break Count"]-= 1
		break_reset()
		break_timer.stop()
		task_stage_vis()
		toggle_vis(break_point_bar)
		toggle_vis(task_progress_bar)
		print("Breakpoint Finished")
	

#Handles Taskbar Progression Check for Completion
func progress_check():
	if coding_bar.value == 100 and completion == false:
		completion = true
#		ProgressionBus.emit_signal("production_complete")


func _on_progress_timer_timeout() -> void:
	if break_point_active == true:
		challenge_progress(true)
	else:
		pass
#	production_growth(task_active)
#	print("Timer Timer")


func _on_break_timer_timeout() -> void:
	break_impact()
	pass # Replace with function body.
