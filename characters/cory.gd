extends CharacterBody2D


@onready var actionable_area : Area2D = $Action_Area


#Status
@export var work_load : float = 0.0
@export var brain_eff : int = 0
@export var break_eff : int = 0
@export var prob_solv_eff : int = 0

@export var stress : int = 0
@export var strain : int = 0

#Positive Traits
var patience : int = 0
var perserverance : int = 0
var motivation : int = 0
var creativity : int = 0
var focus : int = 0

#Negative Traits
var lethargy : int = 0 #Progress slows, affects motivation and creativity
var frailty : int = 0 #Tires out faster, affects perservance and patience
var anxiety : int = 0 #Distracts, affects focus
var depression : int = 0 #Limits work time, affects all

#Resistances
var insight : int = 0 #Counters Lethargy
var heart : int = 0 #Counters Frailty
var serenity : int = 0 #Counters Anxiety
var hope : int = 0 #Counters Depression

const SPEED = 300.0
const work_time : float = 100.0
const work_mod : float = 10.0
const progress : float = 1.0

func _ready() -> void:
	work_time_check()
	ProgressionBus.stat_add.connect(trait_increase)
	

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
		#DialogueManager.show_dialogue_balloon(actionable_area.dialogue_resource, actionable_area.dialogue)
		ProgressionBus.emit_signal("added_trask_progress", "Brainstorm", 10)


func status_check():
	pass

func work_time_check():
	var stress_mod : int = 0
	
	if stress != 0:
		stress_mod += stress - perserverance
		
	var work_pressure = motivation - (stress_mod)
	var work_limit = work_time + (work_pressure * 10)
	
	print("Work Limit: ", work_limit)
#	task_progress += progress

func brain_efficiency_check():
	pass
	

func problem_solve_efficiency_check():
	pass
	

func break_time_check():
	pass
	



func trait_increase():
	print("Trait Increased")
	

#func task_progress():
#	pass




func _on_timer_timeout() -> void:
	pass
#	print("Task Complete")
