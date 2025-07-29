extends CharacterBody2D

@export var player_active : bool


#Node Ref's
@onready var cory : CharacterBody2D = $"."
@onready var cory_sprite : AnimatedSprite2D = $Cory_Sprite
@onready var actionable_area : Area2D = $Action_Area
@onready var trans_timer : Timer = $Trans_Timer
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
@export var stress : float


const SPEED = 60.0
const work_time : float = 100.0
const work_mod : float = 10.0
const progress : float = 1.0

var scene_dict = {
	"Scene One": true,
	"Scene Two": false,
	"Scene Three": false,
	"Scene Four": false
}

#Unmodified 'naked' traits
var base_traits = {
	"Patience" = 0,
	"Perseverance" = 0,
	"Motivation" = 0,
	"Creativity" = 0,
	"Focus" = 0,
	"Insight" = 0,
	"Anxiety" = 0,
	"Lethargy" = 0,
	"Frailty" = 0,
	"Stress" = 0,
	"Strain" = 0,
	"Burnout" = 0,
	"Depression" = 0,
	"Heart" = 0,
	"Serenity" = 0,
	"Hope" = 0,
}


var work_skills = {
	"Scripting"= 0,
	"Debugging"= 0,
	"Computer Logic"= 0,
	"Study"= 0,
	"Experience"= 0
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
	ProgressionBus.connect("ready_scene", ready_timer_start)
	ProgressionBus.connect("game_start", game_start)
	status_check()


func _physics_process(delta: float) -> void:
	detect_input(delta, process)

#Coordinates with Transition Timer
func ready_timer_start(new_scene: String):
	trans_timer.start()
	if ProgressionBus.scene_completion_dict[new_scene] == false:
		if new_scene == "Scene Two":
			print("Second Move")
			cory.global_position = Vector2(112, -16)
		
	
		elif new_scene == "Scene Three":
			cory.global_position = Vector2(65, -16)

#Include scene stop for this?
func game_start():
	process = true
	player_active = true
	actionable_area.monitorable = true

func game_stop():
	process = false
	player_active = false
	actionable_area.monitorable = false

#Handles Input Control
func detect_input(delta, process: bool):
	var direction = 0
	
	if Input.is_action_just_pressed("Player 1"):
		player_active = true
	
	if Input.is_action_just_pressed("Player 2"):
		player_active = false
	
	if process == true and player_active == true:
		if Input.is_action_pressed("left"):
			cory_sprite.set_frame_and_progress(2, 0.0)
			cory_sprite.flip_h
			direction += -1
			velocity.x = direction * SPEED
			velocity.y = 0
			
		elif Input.is_action_pressed("right"):
			cory_sprite.set_frame_and_progress(2, 0.0)
			direction += 1
			velocity.x = direction * SPEED
			velocity.y = 0
			
		elif  Input.is_action_pressed("up"):
			cory_sprite.set_frame_and_progress(1, 0.0)
			direction += -1
			velocity.y = direction * SPEED
			velocity.x = 0
			
		elif  Input.is_action_pressed("down"):
			cory_sprite.set_frame_and_progress(0, 0.0)
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
				toggle_vis(cory)
	

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
	ProgressionBus.emit_signal("update_stat_panel")

#	character_trait_collection()



#Handles Brainstorming Tick Tally, consider increasing tick
func brain_efficiency_check():
	var creative_add = true_traits["True Creativity"] * 0.1
	var strain_sub = true_traits["True Strain"] * -0.1
	var brainstorm_progress = progress + (creative_add + strain_sub)
	
#	print("Brainstorm ", brainstorm_progress)
	return brainstorm_progress

#Handles Problem Solving Tick Tally
func problem_solve_efficiency_check():
	var focus_add = true_traits["True Focus"] * 0.1
	var strain_sub = true_traits["True Strain"] * -0.1
	var problem_solve_progress = progress + (focus_add + strain_sub)
	
#	print("Problem Solve ", problem_solve_progress)
	return problem_solve_progress

#Handles General Task Tick Tally
func task_efficiency_check():
	var strain_sub = true_traits["True Strain"] * -0.1
	var experience_add = work_skills["Experience"] * 0.1
	var task_efficiency = progress + (experience_add + strain_sub)
	
	
	return task_efficiency

#Handles Upper Work Limit
func work_time_check():
	var burnout_mod : int = 0
	
	if burnout!= 0:
		burnout_mod += burnout - base_traits["Perseverance"]
		
	var work_pressure = true_traits["True Motivation"] - burnout
	var work_limit = work_time + (work_pressure * 10)
#	print(work_limit)
	
	return work_limit

#Handles Work Load Accumulation
func work_load_limit(work_limit: float):
	var work_tick = 1.0
	
	if work_load < work_limit:
		work_load += work_tick
#		print("Work Load: ",work_load)
	
	elif work_load >= work_limit:
		over_load += work_tick
#		print("Over Load ",over_load)
		over_load_check()
	

#Handles Overload Accumulation and Strain
func over_load_check():
	if over_load >= 10:
		ProgressionBus.emit_signal("stat_add", "Cory", "Strain")
		base_traits["Strain"] += 1
		over_load -= 10
		print("Strain ", base_traits["Strain"])
	

func stress_build():
	var stress_tick = 1.0
	var motivation_mod = base_traits["Motivation"] * -0.1
	var strain_mod = base_traits["Strain"] * 0.1
	var total_stress = stress_tick + (strain_mod + motivation_mod)
	stress += total_stress
#	print("+ ", total_stress, " Stress")
	base_traits["Stress"] = stress
	
	


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
	

func focus_work_check(work: float, stress: float, familiarity: float):
	var familiar_build = 0.0
	work_load += work
	stress += stress
	familiar_build += familiarity
	
	if familiar_build == 100:
		work_skills["Familiarty"] += 1
		familiar_build = 0

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
		toggle_vis(cory)
		actionable_area.monitoring = false
		process = false
		task_timer.start()
#		print(task_timer, " Started")
	
	elif start == false:
		process = true
		actionable_area.monitoring = true
		toggle_vis(cory)
		task_timer.stop()
	
	print("Triggered")
	
	#Why the additional if statements? Are those necessary? Yeah probably...
	if activity == "Brainstorming":
		is_brainstorming = start
		print("Brainstorm ", start)
		
	
	elif activity == "Working":
		is_working = start
		print("Progress True")
	
	elif activity == "Problem Solving":
		is_problem_solving = start
		print("Problem Solve True")
	
	elif activity == "Break":
		is_on_break = start
		print("Break True")
	
	else:
		is_brainstorming = false
		is_working = false
		is_problem_solving = false
		is_on_break = false


#Handles Task Bar Progression
func _on_task_timer_timeout() -> void:
	var brainstorm_tick = brain_efficiency_check()
	var problem_solve_tick = problem_solve_efficiency_check()
	var task_tick = task_efficiency_check()
	var work_time = work_time_check()
	
	if is_brainstorming == true:
		ProgressionBus.emit_signal("added_task_progress", "Brainstorming", brainstorm_tick)
#		print("Brainstorm Timer Cycle End")
	
	elif is_working == true:
		ProgressionBus.emit_signal("added_task_progress", "Working", task_tick)
#		print("Task Timer Cycle End")
	
	elif is_problem_solving == true:
		ProgressionBus.emit_signal("added_task_progress", "Problem Solving", problem_solve_tick)
		
	
	work_load_limit(work_time)
	stress_build()
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
