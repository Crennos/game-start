extends CharacterBody2D


const SPEED = 300.0


#Status
@export var work_load : float = 0.0
@export var brain_eff : int = 0
@export var break_eff : int = 0
@export var prob_solv_eff : int = 0

@export var stress : int = 0
@export var strain : int = 0

#Positive Traits
@export var patience : int = 0
@export var perserverance : int = 0
@export var motivation : int = 0
@export var creativity : int = 0
@export var focus : int = 0

#Negative Traits
@export var lethargy : int = 0 #Progress slows, affects motivation and creativity
@export var frailty : int = 0 #Tires out faster, affects perservance and patience
@export var anxiety : int = 0 #Distracts, affects focus
@export var depression : int = 0 #Limits work time, affects all

#Resistances
@export var insight : int = 0 #Counters Lethargy
@export var heart : int = 0 #Counters Frailty
@export var serenity : int = 0 #Counters Anxiety
@export var hope : int = 0 #Counters Depression


const work_time : float = 100.0
const work_mod : float = 10.0
const progress : float = 1.0

func _ready() -> void:
	progress_check("Hi")

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
	

func status_check():
	pass

func progress_check(task: String):
	var brainstorm = "Brainstorming"
	var work = "Working"
	var problem_solve = "Problem Solving"
	var stress_mod : int = 0
	
	if stress != 0:
		stress_mod += stress - perserverance
		
	var work_pressure = motivation - (stress_mod)
	var work_limit = work_time + (work_pressure * 10)
	
	print("Work Limit: ", work_limit)
#	task_progress += progress
	
	if task == brainstorm:
		pass
	
	if task == work:
		pass
		
	
	if task == problem_solve:
		pass
		
	


#func task_progress():
#	pass




func _on_timer_timeout() -> void:
	print("Task Complete")
