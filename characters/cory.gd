extends CharacterBody2D

#Node Ref's
@onready var cory : CharacterBody2D = $"."
@onready var actionable_area : Area2D = $Action_Area
@onready var task_progress_bar : TextureProgressBar = $Task_Progress_Bar
@onready var task_timer : Timer = $"Task Timer"
@onready var break_timer : Timer = $"Break Timer"

#Node Status
@export var process : bool = true

#Task Check
@export var is_brainstorming : bool
@export var is_working : bool
@export var is_problem_solving : bool
@export var is_on_break : bool

#Work Status
@export var work_load : float = 0.0
@export var over_load : float = 0.0
@export var burnout : int = 0
@export var break_time : float = 0.0
@export var stress : int


const SPEED = 60.0
const work_time : float = 100.0
const work_mod : float = 10.0
const progress : float = 1.0

#Unmodified 'naked' traits
var base_traits = {
	"Patience" = 0,
	"Perseverance" = 0,
	"Motivation" = 0,
	"Creativity" = 0,
	"Focus" = 0,
	"Lethargy" = 0,
	"Frailty" = 0,
	"Anxiety" = 0,
	"Depression" = 0,
	"Insight" = 0,
	"Heart" = 0,
	"Serenity" = 0,
	"Hope" = 0,
	"Strain" = 0
}

#Modified 'true' trais
var true_traits = {
	"True Patience" = 0,
	"True Perseverance" = 0,
	"True Motivation" = 0,
	"True Creativity" = 0,
	"True Focus" = 0,
	"True Lethargy" = 0,
	"True Frailty" = 0,
	"True Anxiety" = 0,
	"True Strain" = 0
}

#Handles Connections and initial Checks, Test Function
func _ready() -> void:
	work_time_check()
	ProgressionBus.stat_add.connect(trait_increase)
	ProgressionBus.stat_sub.connect(trait_decrease)
	ProgressionBus.connect("action_initiated", toggle_activity)
	ProgressionBus.connect("task_completed", toggle_activity)
	status_check()

func _physics_process(delta: float) -> void:
	detect_input(delta, process)
	

#Handles Input Control
func detect_input(delta, process: bool):
	var direction = 0
	
	if process == true:
		if Input.is_action_pressed("left"):
			direction += -1
			velocity.x = direction * SPEED
			velocity.y = 0
		elif Input.is_action_pressed("right"):
			direction += 1
			velocity.x = direction * SPEED
			velocity.y = 0
		elif  Input.is_action_pressed("up"):
			direction += -1
			velocity.y = direction * SPEED
			velocity.x = 0
		elif  Input.is_action_pressed("down"):
			direction += 1
			velocity.y = direction * SPEED
			velocity.x = 0
		else:
			direction = 0
			velocity = Vector2.ZERO
		move_and_slide()
	
		if actionable_area.actionable_present == true:
			if Input.is_action_just_pressed("action"):
				ProgressionBus.emit_signal("action_prompt", "Cory")
#				print("Task Triggered")

	if Input.is_action_just_pressed("bubble_pop"):
		DialogueManager.show_dialogue_balloon(actionable_area.dialogue_resource, actionable_area.dialogue)
		

#Handles Updating True values of Traits with respective mods
func status_check(): #Condense this into 2 for loops please and thank you, possibly 3
	var true_lethargy = base_traits["Lethargy"] + base_traits["Depression"]
	var true_frailty = base_traits["Frailty"] + base_traits["Depression"]
	var true_anxiety = base_traits["Anxiety"] + base_traits["Depression"]
	var true_strain = base_traits["Strain"] + base_traits["Depression"]
	var true_patience = base_traits["Patience"] - true_frailty
	var true_perseverance = base_traits["Perseverance"] - true_frailty
	var true_motivation = base_traits["Motivation"] - true_lethargy
	var true_creativity = base_traits["Creativity"] - true_lethargy
	var true_focus = base_traits["Focus"] - true_anxiety
	
	
	
	true_traits["True Patience"] = true_patience
	true_traits["True Perseverance"] = true_perseverance
	true_traits["True Motivation"] = true_motivation
	true_traits["True Creativity"] = true_creativity
	true_traits["True Focus"] = true_focus
	true_traits["True Strain"] = true_strain

#Handles Brainstorming Tick Tally
func brain_efficiency_check():
	var creative_add = base_traits["Creativity"] * 0.1
	var strain_sub = true_traits["True Strain"] * -0.1
	var brainstorm_progress = progress + (creative_add + strain_sub)
	
#	print("Brainstorm ", brainstorm_progress)
	return brainstorm_progress

#Handles Problem Solving Tick Tally
func problem_solve_efficiency_check():
	var focus_add = base_traits["Focus"] * 0.1
	var strain_sub = true_traits["True Strain"] * -0.1
	var problem_solve_progress = progress + (focus_add + strain_sub)
	
#	print("Problem Solve ", problem_solve_progress)
	return problem_solve_progress

#Handles General Task Tick Tally
func task_efficiency_check():
	var strain_sub = true_traits["True Strain"] * -0.1
	var task_efficiency = progress + strain_sub
	
	
	return task_efficiency

#Handles Upper Work Limit
func work_time_check():
	var stress_mod : int = 0
	
	if stress != 0:
		stress_mod += stress - base_traits["Perseverance"]
		
	var work_pressure = base_traits["Motivation"] - (stress_mod)
	var work_limit = work_time + (work_pressure * 10)
#	print(work_limit)
	
	return work_limit

#Handles Work Load Accumulation
func work_load_limit(work_limit: float):
	var strain = base_traits["Strain"]
	var work_tick = 1.0
	
	if work_load < work_limit:
		work_load += work_tick
		print("Work Load: ",work_load)
	
	elif work_load >= work_limit:
		over_load += work_tick
		print("Over Load ",over_load)
		over_load_check()
	

#Handles Overload Accumulation and Strain
func over_load_check():
	if over_load >= 10:
		base_traits["Strain"] += 1
		over_load -= 10
		burnout += 1
		print("Strain ", base_traits["Strain"])
	

#Handles Break reduction of Overload/Work Load
func break_time_check():
	var patience_mod = base_traits["Patience"] * 0.1
	var lethargy_mod = true_traits["True Lethargy"] * -0.1
	var relax_tick = progress + (patience_mod + lethargy_mod)
	
	
	if is_on_break == true:
		if burnout == 0:
			work_load -= relax_tick
#			print(work_load)
		
		elif burnout != 0:
			pass
	

#Handles Event Trait Increases
func trait_increase(char: String, stat: String):
	if char == "Cory":
		base_traits[stat] += 1
		print(base_traits[stat])
		print(stat, " Increased")
#		base_status_check()
		status_check()
	else: 
		pass
	

#Handles Event Trait Decreases
func trait_decrease(char: String, stat: String):
	if char == "Cory":
		base_traits[stat] -= 1
		print(base_traits[stat])
		print(stat, " Decreased")
		status_check()
	
	else:
		pass

#Handles Visibility Toggle
func toggle_vis(object):
	if object.visible == false:
		object.visible = true
	
	else:
		object.visible = false

#Handles Activity Activation
func toggle_activity(activity: String, start: bool):
	if start == true:
		process = false
		task_timer.start()
		toggle_vis(task_progress_bar)
#		print(task_timer, " Started")
	
	elif start == false:
		process = true
		task_timer.stop()
	
	if activity == "Brainstorming":
		is_brainstorming = start
		print("Brainstorm True")
		
	
	elif activity == "Working":
		is_working = start
		print("Progress True")
	
	elif activity == "Problem Solving":
		is_problem_solving = start
		print("Problem Solve True")
	
	elif activity == "Break":
		is_on_break = start
		print("Break True")
	
	pass
	


#Handles Task Bar Progression
func _on_task_timer_timeout() -> void:
	var brainstorm_tick = brain_efficiency_check()
	var problem_solve_tick = problem_solve_efficiency_check()
	var task_tick = task_efficiency_check()
	var work_time = work_time_check()
	
	if is_brainstorming == true:
		ProgressionBus.emit_signal("added_task_progress", "Braistorming Progress", brainstorm_tick)
		work_load_limit(work_time)
#		print("Brainstorm Timer Cycle End")
	
	elif is_working == true:
		ProgressionBus.emit_signal("added_task_progress", "Working Progress", task_tick)
		work_load_limit(work_time)
#		print("Task Timer Cycle End")
	
	elif is_problem_solving == true:
		ProgressionBus.emit_signal("added_task_progress", "Problem Solving Progress", problem_solve_tick)
		work_load_limit(work_time)
#		print("Problem Solve Timer Cycle End")

#Handles Break Time Recuperation
func _on_break_timer_timeout() -> void:
	break_time_check()


func _on_action_area_area_entered(area: Area2D) -> void:
	if area.work_id == "Cory":
		actionable_area.actionable_present = true
	else:
		pass


func _on_action_area_area_exited(area: Area2D) -> void:
	if area.work_id == "Cory":
		actionable_area.actionable_present = false
	else:
		pass
