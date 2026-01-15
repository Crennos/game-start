extends Control

#Nodes
@onready var task_progress_bar : TextureProgressBar = $Task_Progress_Bar
@onready var coding_bar : TextureProgressBar = $HBoxContainer/VBoxContainer/Coding_Bar
@onready var testing_bar : TextureProgressBar = $HBoxContainer/VBoxContainer/Testing_Bar
@onready var debugging_bar : TextureProgressBar = $HBoxContainer/VBoxContainer/Efficiency_Bar
@onready var learning_bar : TextureProgressBar = $HBoxContainer/VBoxContainer/Learning_Bar
@onready var break_point_bar : TextureProgressBar = $Breakpoint_Progress_Bar
@onready var selector : Sprite2D = $HBoxContainer/VBoxContainer3/Selector_Sprite
@onready var select_ghost : Sprite2D = $HBoxContainer/VBoxContainer3/Selector_Ghost
@onready var critical_testing_bar : TextureProgressBar = $Critical_Testing_Bar
@onready var critical_debugging_bar : TextureProgressBar = $Critical_Debugging_Bar
@onready var critical_learning_bar : TextureProgressBar = $Criticial_Learning_Bar

#Timers
@onready var progress_timer : Timer = $Progress_Timer
@onready var break_timer : Timer = $Break_Timer
@onready var blink_timer : Timer = $Blink_Timer
@onready var announce_timer : Timer = $Announce_Timer
@onready var ghost_timer : Timer = $Ghost_Timer

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
@onready var announce_text : Label = $Announce_Label
@onready var result_text : Label = $Result_Label
@onready var source_test : Label = $Source_Label

#Task Specific Dialogue Scenes
@export var first_task : DialogueResource
@export var second_task : DialogueResource
@export var third_task : DialogueResource
@export var fourth_task : DialogueResource

#Task Introduction Scenes
@export var bug_intro : DialogueResource
@export var break_intro : DialogueResource
@export var complete_intro : DialogueResource

@export var current_task : String
@export var progress : float = 0
@export var true_complete: bool
@export var bug_tally : int
@export var break_point_chance : float
@export var break_points : int

@export var broken_progress : float

#Task Checks
@export var task_processing : bool
@export var pause_active : bool
@export var task_active : bool
@export var coding : bool
@export var testing : bool
@export var efficiency : bool
@export var learning : bool
@export var break_point_active : bool
@export var completion : bool
@export var debugging : bool

#Task Var's
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
var bug_breaker : int
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
#	break_point_bar.value = 100.0
	pause_active = true
	load_progress()
	break_point_bar.value = 100.0
	save_progress()
#	production_growth(false)
	selector.position = code_pos
	bug_check(5, 2, 3)
	label_handler(0,0,0,0)
#	result_roller("Simple")
#	stability_check(2.2, 3.3, 4.4)

#Loads Task State
func load_progress():
	var load = SaveGameBus.load_task_path()
	task_progress_bar.value = load["Task Bar"]
	coding_bar.value = load["Coding Bar"]
	testing_bar.value = load["Testing Bar"]
	debugging_bar.value = load["Debugging Bar"]
	learning_bar.value = load["Learning Bar"]
	break_point_bar.value = load["Breakpoint Bar"]
	bug_log["Hidden Bugs"] = load["Hidden Bugs"]
	bug_log["Test Thresh"] = load["Test Thresh"]
	bug_log["Found Bugs"] = load["Found Bugs"]
	bug_log["Bug Health"] = load["Bug Health"]
	bug_log["Break Bugs"] = load["Break Bugs"]
	bug_log["Break Count"] = load["Break Count"]
	
	#print("Hidden Bugs: ", bug_log["Hidden Bugs"])
	#print("Test Thresh: ", bug_log["Test Thresh"])
	#print("Found Bugs", bug_log["Found Bugs"])
	#print("Bug Health", bug_log["Bug Health"])
	#print("Break Bugs", bug_log["Break Bugs"])
	#print("Break Count", bug_log["Break Count"])
	#print("Task: ", task_progress_bar.value)
	#print("Code: ", coding_bar.value)
	#print("Test: ", testing_bar.value)
	#print("Eff: ", debugging_bar.value)
	#print("Learn: ", learning_bar.value)
	#print("Break: ", break_point_bar.value)
	

#Saves Task State
func save_progress():
	SaveGameBus.save_task_path("Task Bar", task_progress_bar.value)
	SaveGameBus.save_task_path("Coding Bar", coding_bar.value)
	SaveGameBus.save_task_path("Testing Bar", testing_bar.value)
	SaveGameBus.save_task_path("Debugging Bar", debugging_bar.value)
	SaveGameBus.save_task_path("Learning Bar", learning_bar.value)
	SaveGameBus.save_task_path("Breakpoint Bar", break_point_bar.value)
	SaveGameBus.save_task_path("Hidden Bugs", bug_log["Hidden Bugs"])
	SaveGameBus.save_task_path("Test Thresh", bug_log["Test Thresh"])
	SaveGameBus.save_task_path("Found Bugs", bug_log["Found Bugs"])
	SaveGameBus.save_task_path("Bug Health", bug_log["Bug Health"])
	SaveGameBus.save_task_path("Break Bugs", bug_log["Break Bugs"])
	SaveGameBus.save_task_path("Break Count", bug_log["Break Count"])
	
	

#Triggers from Task Pause Signal
func pause():
	task_processing = false
	task_active = false
	pause_active = true

#Triggers from Task Start Signal
func start():
	task_processing = true
	task_active = true
	pause_active = false
#	production_growth(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	detect_input(task_active)
	break_point_complete()
	save_progress()
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
	
		if Input.is_action_just_pressed("Select"):
			if selector.position == code_pos:
				coding = true
				testing = false
				efficiency = false
				learning = false
				ghost_select(code_pos)
			elif selector.position == test_pos:
				testing = true
				coding = false
				efficiency = false
				learning = false
				ghost_select(test_pos)
			elif selector.position == eff_pos:
				efficiency = true
				coding = false
				testing = false
				learning = false
				ghost_select(eff_pos)
			elif selector.position == learn_pos:
				learning = true
				coding = false
				efficiency = false
				learning = false
				ghost_select(learn_pos)
		
		if Input.is_action_just_pressed("task pause"):
			if pause_active == false:
				pause_active = true
				ProgressionBus.emit_signal("action_prompt", "Cory")
				print("Pause: ", pause_active)
				
			else:
				pause_active = false
				ProgressionBus.emit_signal("action_prompt", "Cory")
				print("Pause: ", pause_active)
			
		if Input.is_action_just_pressed("action"):
			if coding_bar.value == 100:
				ProgressionBus.emit_signal("production_complete")
	
	else:
		pass

#Controls Ghost Selector Pos and Vis
func ghost_select(current_pos : Vector2):
	select_ghost.position = current_pos
	select_ghost.visible = true
	ghost_timer.start()

#Controls Label Text Displays
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
		code_bar = snapped(coding_bar.value, 0.1)
		code_cap = coding_bar.max_value
		eff_bar = snapped(debugging_bar.value, 0.1)
		eff_cap = debugging_bar.max_value
		test_bar = snapped(testing_bar.value, 0.1)
		test_cap = testing_bar.max_value
		learn_bar = snapped(learning_bar.value, 0.1)
		learn_cap = learning_bar.max_value
		code_prog_label.visible = true
		task_prog_label.visible = true
		break_prog_label.visible = false
		task_bar = snapped(task_progress_bar.value, 0.1)
		task_cap = task_progress_bar.max_value
		
		task_color_swap("Task")
	
	elif break_point_active == true:
		eff_bar = snapped(critical_debugging_bar.value, 0.1)
		eff_cap = critical_debugging_bar.max_value
		test_bar = snapped(critical_testing_bar.value, 0.1)
		test_cap = critical_testing_bar.max_value
		learn_bar = snapped(critical_learning_bar.value, 0.1)
		learn_cap = critical_learning_bar.max_value
		code_prog_label.visible = false
		task_prog_label.visible = false
		break_prog_label.visible = true
		break_bar = snapped(break_point_bar.value, 0.1)
		break_cap = break_point_bar.max_value
		
		task_color_swap("Break")
	
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
					test_text_tick.visible = false
				else:
					test_text_tick.visible = true
					test_text_tick.text = tick_text
			"Eff":
				if tick_text == "":
					eff_text_tick.visible = false
				else:
					eff_text_tick.visible = true
					eff_text_tick.text = tick_text
			"Learn":
				if tick_text == "":
					learn_text_tick.visible = false
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
	

#Triggers Announcement Event Text
func announce(event: String, level: String):
	
	if announce_timer.is_stopped() == true:
		match event:
			"Bug Found":
	#			print(event)
				announce_text.text = level + " " + event
			"Bug Fixed":
	#			print(event)
				announce_text.text = level + " " + event
			"Break Start":
				print(event)
				announce_text.text = level + " " + event
			"Break Fixed":
				print(event)
				announce_text.text = level + " " + event
		
		if task_processing == true and pause_active == false:
			announce_timer.start()
			print("Pause Announce")
			pause_active = true

#Handles Label Color Swapping
func task_color_swap(task : String):
	var green = Color(0.0, 0.90, 0.0, 1)
	var orange = Color(0.79, 0.34, 0.2, 1)
	var turqoise = Color(0.28, 0.49, 0.99, 1.00)
	var dark_blue = Color(0.00, 0.21, 0.98, 1.00)
	
	match task:
		"Task":
			#print("Color Task")
			eff_prog_label.set("theme_override_colors/font_color", orange)
			test_prog_label.add_theme_color_override("font_color", dark_blue)
			eff_text_tick.set("theme_override_colors/font_color", orange)
			test_text_tick.add_theme_color_override("font_color", dark_blue)
		"Break":
			#print("Color Break")
			eff_prog_label.set("theme_override_colors/font_color", turqoise)
			test_prog_label.add_theme_color_override("font_color", green)
			eff_text_tick.set("theme_override_colors/font_color", turqoise)
			test_text_tick.add_theme_color_override("font_color", green)
			
	

#Handles Text Blinking
func text_blinker():
	var code_vis = code_text_tick.visible
	var test_vis = test_text_tick.visible
	var eff_vis = eff_text_tick.visible
	var learn_vis = learn_text_tick.visible
	
	var vis_list = [code_vis, test_vis, eff_vis, learn_vis]
#	print("Vis Check 1: ", vis_list)
	
	for i in range(4):
		if vis_list[i] == true:
			vis_list[i] = false
			
			match i:
				0:
					code_text_tick.visible = vis_list[i]
				1:
					test_text_tick.visible = vis_list[i]
				2:
					eff_text_tick.visible = vis_list[i]
				3:
					learn_text_tick.visible = vis_list[i]
		else:
			pass
	
#	print("Vis Check 2: ", vis_list)


#Handles First Time Interactions
func initiate():
	pass


func set_task_value(value: float):
	task_progress_bar.value = value
	

#Triggers from Task Bar Singal
func task_bar_raise(task: String, prog: float, skills: Array):
	production_growth(true, skills)
	var code = coding_bar.value
	
	if coding == true and code != 100.0 and pause_active == false:
		current_task = task
		task_progress_bar.value += prog
#		print(task, " + ", prog)
	else:
		pass


#Toggles Vis
func toggle_vis(object):
	if object.visible == false:
		object.visible = true
	
	else:
		object.visible = false


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
	var eff_prog = debugging_bar.value
	var learn_prog = learning_bar.value
	
	
	if task_processing == true and break_point_active == false and pause_active == false: #Begins processes for work bar calculations
		var code = skills[0]
		var test = skills[1]
		var efficient = skills[2]
		var learn = skills[3]
#		progress_timer.start()
		
		if coding == true:
			coding_tick = code
			testing_tick =  test * -0.2
			efficiency_tick = efficient * -0.1
			learning_tick = learn * 0.1
			work_load_mod = 0.2
			stress_mod = 0.3
			familiarity_tick = 0.1
			bug_check(code_prog, test_prog, eff_prog) #Checks stability of code against bugs
		
		elif testing == true:
			coding_tick = 0
			testing_tick = test
			efficiency_tick = 0
			learning_tick = learn * 0.1
			work_load_mod = 0.1
			stress_mod = 0.2
			familiarity_tick = 0.1
			break_point_init()
			bug_finder()
		
		elif efficiency == true and debugging == false:
#			clampf(debugging_bar.value, 0.0, bug_eff_limit)
			clampf(debugging_bar.max_value, 25, bug_eff_limit)
			coding_tick = 0
			testing_tick = 0
			efficiency_tick = efficiency
			learning_tick = learn * 0.2
			work_load_mod = 0.5
			stress_mod = 0.5
			familiarity_tick = 0.3
			bug_health_check(debugging_bar.value)
			
		elif learning == true:
			coding_tick = 0
			testing_tick = 0
			efficiency_tick = 0
			learning_tick = learn
			work_load_mod = 0.2
			stress_mod = 0.5
			familiarity_tick = 0.5
		
		blink_timer.start()
		coding_bar.value += coding_tick
		testing_bar.value += testing_tick
		debugging_bar.value += efficiency_tick
		learning_bar.value += learning_tick
		label_handler(coding_tick, testing_tick, efficiency_tick, learning_tick)
		ProgressionBus.emit_signal("work_load_modify", work_load_mod)
		ProgressionBus.emit_signal("stress_modify", stress_mod)
		ProgressionBus.emit_signal("familiarity_update", familiarity_tick)
	
	else:
		pass
	

#Would be Production Growth Substitute
func growth_ticker(task : String):
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
	
	if break_point_active == true and pause_active == false:
		if testing == true:
			break_task("Testing", test_tick)
			label_handler(0, test_tick, 0, 0)
		
		elif efficiency == true:
			eff_tick += (test_mod * learn_mod)
#			print("Debug: ", eff_tick)
			break_task("Debugging", eff_tick)
			label_handler(0, 0, eff_tick, 0)
		
		elif learning == true:
			break_task("Learning", learn_tick)
			label_handler(0, 0, 0, learn_tick)
		
		break_point_bar.value -= eff_tick + (critical_debugging_bar.value * 0.1)
		blink_timer.start()


#Handles Calculations for Breakpoint Progress Ticks
func break_task(task: String, value: float):
	var test_cap = critical_testing_bar.max_value
	var debug_cap = critical_debugging_bar.max_value
	var learn_cap = critical_learning_bar.max_value
#	print("Task: ", task)
#	print("Value: ", value)
	if task_processing == true and pause_active == false:
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
	else:
		pass
		
	

#Handles Regression from Breakpoint on Progress Bars
func break_impact():
	var experience = ProgressionBus.cory_skills["Experience"]
	
	var rebound = break_point_traits["Rebound"]
	var puzzle = break_point_traits["Puzzle"]
	var weight = break_point_traits["Weight"] - experience
	
	if testing == true:
		critical_debugging_bar.value -= puzzle
		critical_learning_bar.value -= puzzle
		learn_prog_label.text = str(snapped(critical_learning_bar.value, 0.1)) + "/" + str(critical_learning_bar.max_value)
		eff_prog_label.text = str(snapped(critical_debugging_bar.value, 0.1)) + "/" + str(critical_debugging_bar.max_value)
		
	elif efficiency == true:
		critical_learning_bar.value -= puzzle
		critical_testing_bar.value -= puzzle
		learn_prog_label.text = str(snapped(critical_learning_bar.value, 0.1)) + "/" + str(critical_learning_bar.max_value)
		test_prog_label.text = str(snapped(critical_testing_bar.value, 0.1)) + "/" + str(critical_testing_bar.max_value)
		
	elif learning == true:
		critical_debugging_bar.value -= puzzle
		critical_testing_bar.value -= puzzle
		eff_prog_label.text = str(snapped(critical_debugging_bar.value, 0.1)) + "/" + str(critical_debugging_bar.max_value)
		test_prog_label.text = str(snapped(critical_testing_bar.value, 0.1)) + "/" + str(critical_testing_bar.max_value)
	 
	break_point_bar.value += rebound
	break_prog_label.text = str(snapped(break_point_bar.value, 0.1)) + "/" + str(break_point_bar.max_value)
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
		if bug_breaker == 0:
			bug_diff()
		elif bug_breaker > 0:
			bug_breaker -= 1
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
		
		if current_test >= test_mark and test_mark != 0.0:
			match bug_log["Hidden Bugs"][0]:
				"Simple":
#					print("Found 1: ", bug_level, " Bug")
					bug_log["Hidden Bugs"].erase(bug_level)
#					print(bug_log, " Bug No Longer Hidden")
					bug_log["Found Bugs"].append(bug_level)
					print(bug_log["Found Bugs"][-1], " Now Discovered")
					bug_log["Test Thresh"] = 0
					bug_simple_count += 1
					announce("Bug Found", bug_level)
					bug_trigger("Simple")
					bug_marker(5)
					
				"Standard":
#					print("Found 1: ", bug_level, " Bug")
					bug_log["Hidden Bugs"].erase(bug_level)
#					print(bug_log, " Bug No Longer Hidden")
					bug_log["Found Bugs"].append(bug_level)
					print(bug_log["Found Bugs"][-1], " Now Discovered")
					bug_log["Test Thresh"] = 0
					bug_standard_count += 1
					announce("Bug Found", bug_level)
					bug_trigger("Standard")
					bug_marker(3)
					
				"Complex":
#					print("Found 1: ", bug_level, " Bug")
					bug_log["Hidden Bugs"].erase(bug_level)
#					print(bug_log, " Bug No Longer Hidden")
					bug_log["Found Bugs"].append(bug_level)
					print(bug_log["Found Bugs"][-1], " Now Discovered")
					bug_log["Test Thresh"] = 0
					bug_complex_count += 1
					announce("Bug Found", bug_level)
					bug_trigger("Complex")
					bug_marker(5)
					
		
		else:
			pass
	else:
		pass

#Handles Logging of Bugs
func bug_trigger(difficulty: String):
	var print_label : String
	
	match difficulty:
		"Simple":
#			print("Simple Trigger")
			coding_bar.value -= 2
			learning_bar.max_value -= 3
			debugging_bar.max_value -= 1
			task_progress_bar.value -= 1
			print_label = "-2 Coding Progress
			-3 Learning Cap
			-1 Debugging Cap 
			-1 Task Progress
			"
			result_printer("", print_label)
		"Standard":
#			print("Standard Trigger")
			coding_bar.value -= 5
			learning_bar.max_value -= 5
			debugging_bar.max_value -= 3
			task_progress_bar.value -= 3
			print_label = "-5 Coding Progress
			-5 Learning Cap
			-3 Debugging Cap
			-3 Task Progress
			"
			result_printer("", print_label)
		"Complex":
#			print("Complex Trigger")
			coding_bar.value -= 8
			learning_bar.max_value -= 10
			debugging_bar.max_value -= 5
			task_progress_bar.value -= 5
			print_label = "-8 Coding Progress
			-10 Learning Cap
			-5 Debugging Cap
			-5 Task Progress
			"
			result_printer("", print_label)
	
	var max_eff = debugging_bar.max_value
	print("Eff Limit: ", max_eff)

#Handles Checking of Bug Health vs Efficiency Prog
func bug_health_check(efficiency : float):
	var bug_health : int
	var eff_prog = debugging_bar.value
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

#Generates Random Outcome for Bug Completion
func result_roller(bug: String):
	var check = ProgressionBus.cory_skills["Debugging"] - (difficulty_level) #Tweak the balance of this
	var result_roll = clampi(randi_range(0, 10) - check, 1, 10)
	var bug_level = {"Simple" : 1, 
	"Standard" : 3, 
	"Complex" : 5}
	var pos_value = bug_level[bug]
	var neg_value = bug_level[bug] * -1
	
	var pos_dict = {"Progress" : pos_value,
	"Bug" : bug,
	"Task" : pos_value,
	"Familiarity": pos_value}
	var neg_dict = {"Progress" : neg_value,
	"Bug" : bug,
	"Task" : neg_value,
	"Familiarity": neg_value}
	
	var outcome_options = ["Progress", "Bug", "Task", "Familiarity"]
	var progress_bars = ["Coding", "Testing", "Debugging", "Familiarity"]
	var outcome_roll = randi_range(0, 3)
	var prog_roll = randi_range(0, 3)
	var outcome : String
	var result_value : int = 0
	var print_label : String
	var result : bool
	
	if result_roll <= 3:
		result = false
		print("Result: ", result)
		outcome = outcome_options[outcome_roll]
		print("Outcome: ", outcome)
		var final_result = neg_dict[outcome]
		result_value = neg_value
		print("Final: ", final_result)
		
	elif result_roll <= 7:
		print_label = "Null Effect"
		result_printer(print_label, "")
	
	elif result_roll <= 10:
		result = true
		print("Result: ", result)
		outcome = outcome_options[outcome_roll]
		print("Outcome: ", outcome)
		var final_result = pos_dict[outcome]
		result_value = pos_value
		print("Final: ", final_result)
	
	match outcome:
		"Progess":
			var progress_result = progress_bars[prog_roll]
			print_label = progress_result + " " + "Progessed Increased By" + str(result_value)
			print(print_label)
			result_printer(print_label, "")
			match progress_result:
				"Coding":
					coding_bar.value += result_value
					if result == true:
						print_label = "Coding Progress + " + str(pos_value)
					else:
							print_label = "Coding Progress - " + str(pos_value)
					result_printer(print_label, "")
				"Testing":
					testing_bar.value += result_value
					if result == true:
						print_label = "Coding Progress + " + str(pos_value)
					else:
							print_label = "Coding Progress - " + str(pos_value)
					result_printer(print_label, "")
				"Debugging":
					debugging_bar.value += result_value
					if result == true:
						print_label = "Coding Progress + " + str(pos_value)
					else:
							print_label = "Coding Progress - " + str(pos_value)
					result_printer(print_label, "")
				"Learning":
					learning_bar.value += result_value
					if result == true:
						print_label = "Coding Progress + " + str(pos_value)
					else:
							print_label = "Coding Progress - " + str(pos_value)
					result_printer(print_label, "")
			print("+ ", result_value)
		"Bug":
			var bug_mod = bug_level[bug]
			bug_spawn(bug, result, check, bug_mod)
			
		"Task":
			task_progress_bar.value += result_value
			print("+ ", result_value)
			if result == true:
				print_label = " Task Progress + " + str(result_value)
			elif result == false:
				print_label = " Task Progress - " + str(pos_value)
			result_printer(print_label, "")
			
		"Familiarity":
			print_label = ""
			if result == true:
				print_label = "Gained " + pos_value + " Familiarity"
			else:
				print_label = "Lost " + pos_value + " Familiarity"
			result_printer(print_label, "")
	

func bug_spawn(bug: String, result : bool, check : int, mod: int):
	var debug_value = debugging_bar.value
	var bug_roll = randi_range(1, 10) + check
	var print_label : String
	
	if result == false:
		if bug_roll <= 6:
			print(bug_log["Hidden Bugs"])
			bug_log["Hidden Bugs"]
			print(bug_log["Hidden Bugs"])
			bug_marker(mod)
			print_label = "Null Effect"
		elif bug_roll <= 10:
			print(bug_log["Found Bugs"])
			bug_log["Found Bugs"].push_front(bug)
			print(bug_log["Found Bugs"])
			bug_health_check(debug_value)
			bug_trigger(bug)
			print_label = "New " + bug_log["Found Bugs"][0] + " Bug Created"
	elif result == true:
		print("SRoll: ", bug_roll)
		if bug_roll <= 6:
			if bug_log["Hidden Bug"].is_empty() != false:
				bug_log["Test Thresh"] = testing_bar.value
				bug_finder()
				print_label = "Hidden " + bug_log["Hidden Bug"][0] + " Bug Found"
			else:
				bug_breaker += 1
				print_label = "Bug Breaker Token Gained"
		elif bug_roll <= 10:
			var found_bugs = len(bug_log["Found Bugs"])
			if found_bugs >= 1:
				var bug_len = len(bug_log["Found Bugs"])
				print("Bug L: ", bug_len)
				var hidden_roll = randi_range(0, bug_len)
				print("H Roll: ", hidden_roll)
				var target_bug = bug_log["Found Bugs"][hidden_roll]
				print(bug_log["Found Bugs"])
				print(target_bug)
				bug_log["Found Bugs"].erase(target_bug)
				print(bug_log["Found Bugs"])
				print_label = "Extra " + target_bug + " " + "Bug Fixed"
			elif bug_log["Hidden Bugs"].is_empty() != true:
				var bug_len = len(bug_log["Hidden Bugs"])
				print("Bug L: ", bug_len)
				var hidden_roll = randi_range(0, bug_len)
				print("H Roll: ", hidden_roll)
				var target_bug = bug_log["Hidden Bugs"][hidden_roll]
				print(bug_log["Hidden Bugs"])
				bug_log["Hidden Bugs"].erase(target_bug)
				print(bug_log["Hidden Bugs"])
				print_label = "Random Hidden Bug Fixed"
			else: #Add Bug Token here
				bug_breaker += 1
				print_label = "Bug Breaker Token Gained"
			
	result_printer(print_label, "")

func result_printer(result: String, source: String):
	if result != "":
		result_text.text = result
	elif source != "":
		pass

#Handles Deletion of Bug and its Effects
func bug_kill(bug_health : int, target : String):
	var eff_prog = debugging_bar.value
	var bug_level = bug_log["Found Bugs"][0]
	var source_print : String
	
	if eff_prog >= bug_log["Bug Health"]:
		bug_log["Bug Health"] = 0
		 
		match target:
			"Simple":
				bug_simple_count -= 1
#				print(bug_level, " Bug Erased")
				bug_log["Found Bugs"].erase(bug_level)
#				print("New Bug List: ", bug_log["Found Bugs"])
				announce("Bug Fixed", bug_level)
			"Standard":
				bug_standard_count -= 1
#				print(bug_level, " Bug Erased")
				bug_log["Found Bugs"].erase(bug_level)
#				print("New Bug List: ", bug_log["Found Bugs"])
				announce("Bug Fixed", bug_level)
			"Complex":
				bug_complex_count -= 1
#				print(bug_level, " Bug Erased")
				bug_log["Found Bugs"].erase(bug_level)
#				print("New Bug List: ", bug_log["Found Bugs"])
				announce("Bug Fixed", bug_level)
		
		debugging_bar.value -= effi_marks["Temp"]
		debugging_bar.max_value += effi_marks["Perm"]
		
#		result_printer("", "")
		result_roller(target)
	else:
		pass


#Handles the Probability of a Bug becoming a Breakpoint
func break_check():
	const break_min : float = 5.0
	var breakpoint_base : float = 5.0
	var difficulty_base : float = 5.0
	var break_chance : float
	var break_point = 0
	var break_roll = randf_range(1, 100)
	var break_thresh = 100
	
	break_chance += (breakpoint_base + difficulty_base) - (logic_mod + debug_mod + exp_mod)
#	print("BC ", break_chance)
	clampf(break_chance, 5, 100)
	break_thresh = 100 - (break_chance + break_min)
#	print("BT ", break_thresh)
#	print("Run Check")
	
	if break_roll >= break_thresh:
#		print("True")
		return true
	
	else:
#		print("False")
		return false

#Handles Initialization Trigger of Breakpoint Progress Phase
func break_point_init(): 
	var origin_bug : String
	var break_count = bug_log["Break Count"]
	
#	print("Breakpoint Tally: ", break_points)
	if break_count >= 1 and break_point_active == false:
		print("Break Started")
		label_handler(0.0, 0.0, 0.0, 0.0)
		origin_bug = bug_log["Break Bugs"][-1]
		break_point_active = true
		toggle_vis(task_progress_bar)
		toggle_vis(break_point_bar)
		task_stage_vis()
		break_timer.start()
		announce("Break Start", origin_bug)
		
	
#	print("Challenge: ", origin_bug)
	break_point_config(origin_bug)


#Handles Visibility of Task Progression Bars 
func task_stage_vis():
	toggle_vis(coding_bar)
	toggle_vis(testing_bar)
	toggle_vis(debugging_bar)
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
#	print(challenge, "Begin")
	
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
	critical_debugging_bar.max_value = 5.0
	critical_testing_bar.max_value = 5.0
	critical_learning_bar.max_value = 10.0
	

#Handles Completion of Breakpoint Challenge
func break_point_complete():
	if break_point_bar.value == 0.0 and break_point_active == true and announce_timer.is_stopped() == true:
		label_handler(0.0, 0.0, 0.0, 0.0)
		var _break = bug_log["Break Bugs"][-1]
		bug_log["Break Count"]-= 1
		break_point_active = false
		break_timer.stop()
		print("Breakpoint Finished")
		announce("Break Fixed", _break)
		
	elif break_point_bar.value == 0.0 and announce_timer.is_stopped() == true and break_point_active == true:
		label_handler(0.0, 0.0, 0.0, 0.0)
		break_reset()
		task_stage_vis()
		toggle_vis(break_point_bar)
		toggle_vis(task_progress_bar)
	

#Handles Taskbar Progression Check for Completion
func progress_check():
	if coding_bar.value == 100 and completion == false:
		completion = true
		
#		ProgressionBus.emit_signal("production_complete")

#Handles Breakpoint Progression Ticks
func _on_progress_timer_timeout() -> void:
	if break_point_active == true:
		challenge_progress(true)
	else:
		pass
#	production_growth(task_active)
#	print("Timer Timer")

#Handles Breakpoint Rebounding
func _on_break_timer_timeout() -> void:
	break_impact()
	pass # Replace with function body.

#Handles Text Blinking
func _on_blink_timer_timeout() -> void:
	text_blinker()

#Handles Announce Pause Delay
func _on_announce_timer_timeout() -> void:
	pause_active = false
	print("End Announce")
	announce_text.text = ""
	result_text.text = ""

#Handles Ghost Selector Blinking
func _on_ghost_timer_timeout() -> void:
	toggle_vis(select_ghost)
