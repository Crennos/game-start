extends CharacterBody2D


@onready var actionable_area : Area2D = $Action_Area


@export var is_brainstorming : bool
@export var is_working : bool
@export var is_problem_solving : bool


@export var work_load : float = 0.0
@export var break_time : float = 0.0

@export var stress : int



const SPEED = 300.0
const work_time : float = 100.0
const work_mod : float = 10.0
const progress : float = 1.0

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

func _ready() -> void:
#	work_time_check()
	ProgressionBus.stat_add.connect(trait_increase)
	ProgressionBus.stat_sub.connect(trait_decrease)
#	base_status_check()
	status_check()
	

func _physics_process(delta: float) -> void:
	detect_input(delta, true)
	

func detect_input(delta, process: bool):
	var direction = 0
	
	if process == true:
		if Input.is_action_pressed("left"):
			direction += -1
			velocity.x = direction * SPEED
		elif Input.is_action_pressed("right"):
			direction += 1
			velocity.x = direction * SPEED
		elif  Input.is_action_pressed("up"):
			direction += -1
			velocity.y = direction * SPEED
		elif  Input.is_action_pressed("down"):
			direction += 1
			velocity.y = direction * SPEED
		else:
			direction = 0
			velocity = Vector2.ZERO
		move_and_slide()
	

	if Input.is_action_just_pressed("bubble_pop"):
		DialogueManager.show_dialogue_balloon(actionable_area.dialogue_resource, actionable_area.dialogue)
#		status_check()
#		ProgressionBus.emit_signal("added_trask_progress", "Brainstorm", 10)


#func base_status_check():
#	var character_traits : Array = [patience, 
#	perseverance, 
#	motivation, 
#	creativity, 
#	focus,
#	lethargy,
#	frailty,
#	anxiety,
#	depression,
#	insight,
#	heart,
#	serenity,
#	hope
#	]
#	var array_key = -1
#	
#	for key in base_traits:
#		array_key += 1
#		base_traits[key] = character_traits[array_key]
#		print(base_traits[key])
	

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
#	print(true_strain)
#	print(true_traits["Strain"])

func brain_efficiency_check():
	var creative_add = base_traits["Creativity"] * 0.1
	var strain_sub = true_traits["True Strain"] * -0.1
	var brainstorm_progress = progress + (creative_add + strain_sub)
	
#	print("Brainstorm ", brainstorm_progress)
	return brainstorm_progress

func problem_solve_efficiency_check():
	var focus_add = base_traits["Focus"] * 0.1
	var strain_sub = true_traits["True Strain"] * -0.1
	var problem_solve_progress = progress + (focus_add + strain_sub)
	
#	print("Problem Solve ", problem_solve_progress)
	return problem_solve_progress

func task_efficiency_check():
	var strain_sub = true_traits["True Strain"] * -0.1
	var task_efficiency = progress + strain_sub
	
	
	return task_efficiency

func work_time_check():
	var stress_mod : int = 0
	
	if stress != 0:
		stress_mod += stress - base_traits["Perseverance"]
		
	var work_pressure = base_traits["Motivation"] - (stress_mod)
	var work_limit = work_time + (work_pressure * 10)
	

func break_time_check():
	pass
	


func trait_increase(char: String, stat: String):
	if char == "Cory":
		base_traits[stat] += 1
		print(base_traits[stat])
		print(stat, " Increased")
#		base_status_check()
		status_check()
	else: 
		pass
	

func trait_decrease(char: String, stat: String):
	if char == "Cory":
		base_traits[stat] -= 1
		print(base_traits[stat])
		print(stat, " Decreased")
		status_check()
	
	else:
		pass


func _on_task_timer_timeout() -> void:
	var brainstorm_tick = brain_efficiency_check()
	var problem_solve_tick = problem_solve_efficiency_check()
	var task_tick = task_efficiency_check()
	
	if is_brainstorming == true:
		ProgressionBus.emit_signal("added_trask_progress", "Braistorming Progress", brainstorm_tick)
		print("Brainstorm Timer Cycle End")
	
	elif is_working == true:
		ProgressionBus.emit_signal("added_trask_progress", "Working Progress", task_tick)
		print("Task Timer Cycle End")
	
	elif is_problem_solving == true:
		ProgressionBus.emit_signal("added_trask_progress", "Problem Solving Progress", problem_solve_tick)
		print("Problem Solve Timer Cycle End")
