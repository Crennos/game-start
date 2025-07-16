extends CharacterBody2D


@onready var actionable_area : Area2D = $Action_Area


#Status
@export var work_load : float = 0.0
@export var brain_eff : int = 0
@export var break_eff : int = 0
@export var prob_solv_eff : int = 0

@export var stress : int
@export var strain : int

#Positive Traits
@export var patience : int
@export var perseverance : int
@export var motivation : int
@export var creativity : int
@export var focus : int

#Negative Traits
@export var lethargy : int #Progress slows, affects motivation and creativity
@export var frailty : int #Tires out faster, affects perservance and patience
@export var anxiety : int #Distracts, affects focus
@export var depression : int #Limits work time, affects all

#Resistances
@export var insight : int #Counters Lethargy
@export var heart : int #Counters Frailty
@export var serenity : int #Counters Anxiety
@export var hope : int #Counters Depression

const SPEED = 300.0
const work_time : float = 100.0
const work_mod : float = 10.0
const progress : float = 1.0

var base_traits = {
	"Patience" = patience,
	"Perseverance" = perseverance,
	"Motivation" = motivation,
	"Creativity" = creativity,
	"Focus" = frailty,
	"Lethargy" = lethargy,
	"Frailty" = frailty,
	"Anxiety" = anxiety,
	"Depression" = depression,
	"Insight" = insight,
	"Heart" = heart,
	"Serenity" = serenity,
	"Hope" = hope
}

var true_traits = {
	"True Patience" = 0,
	"True Perseverance" = 0,
	"True Motivation" = 0,
	"True Creativity" = 0,
	"True Focus" = 0,
	"True Lethargy" = 0,
	"True Frailty" = 0,
	"True Anxiety" = 0
}

func _ready() -> void:
	work_time_check()
	ProgressionBus.stat_add.connect(trait_increase)
	problem_solve_efficiency_check()
	brain_efficiency_check()
	base_status_check()
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


func base_status_check():
	var character_traits : Array = [patience, 
	perseverance, 
	motivation, 
	creativity, 
	focus,
	lethargy,
	frailty,
	anxiety,
	depression,
	insight,
	heart,
	serenity,
	hope
	]
	var array_key = -1
	
	for key in base_traits:
		array_key += 1
		base_traits[key] = character_traits[array_key]
#		print(base_traits[key])
	

func status_check(): #Condense this into 2 for loops please and thank you
	var true_lethargy = base_traits["Lethargy"] + base_traits["Depression"]
	var true_frailty = base_traits["Frailty"] + base_traits["Depression"]
	var true_anxiety = base_traits["Anxiety"] + base_traits["Depression"]
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
	print("True Patience: ", true_traits["True Patience"])
	print("True Perseverance: ", true_traits["True Perseverance"])
	print("True Motivation: ", true_traits["True Motivation"])
	print("True Creativity: ", true_traits["True Creativity"])
	print("True Focus: ", true_traits["True Focus"])

func work_time_check():
	var stress_mod : int = 0
	
	if stress != 0:
		stress_mod += stress - perseverance
		
	var work_pressure = motivation - (stress_mod)
	var work_limit = work_time + (work_pressure * 10)
	
#	print("Work Limit: ", work_limit)
#	task_progress += progress

func brain_efficiency_check():
	var creative_add = creativity * 0.1
	var strain_sub = strain * -0.1
	var brainstorm_progress = progress + (creative_add + strain_sub)
	
#	print("Brainstorm ", brainstorm_progress)
	return brainstorm_progress

func problem_solve_efficiency_check():
	var focus_add = focus * 0.1
	var strain_sub = strain * -0.1
	var problem_solve_progress = progress + (focus_add + strain_sub)
	
#	print("Problem Solve ", problem_solve_progress)
	return problem_solve_progress

func task_efficiency_check():
	var strain_sub = strain * -0.1
	

func break_time_check():
	pass
	



func trait_increase(stat: String):
	base_traits[stat] += 1
	print(base_traits[stat])
	print(stat, " Increased")
#	base_status_check()
	status_check()
	

#func task_progress():
#	pass




func _on_timer_timeout() -> void:
	pass
#	print("Task Complete")
