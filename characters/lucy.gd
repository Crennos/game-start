extends CharacterBody2D


@onready var trans_timer : Timer = $Trans_Timer

@export var player_active : bool

const SPEED = 300.0

@onready var lucy : CharacterBody2D = $"."

@export var opening_dialogue : DialogueResource


#Positive Traits
@export var patience : int = 0
@export var perserverance : int = 0
@export var motivation : int = 0
@export var creativity : int = 0
@export var focus : int = 0

#Negative Traits
@export var lethargy : int = 0 #Progress slows, affects patience and creativity
@export var fragility : int = 0 #Tires out faster, affects perservance and motivation
@export var anxiety : int = 0 #Affects all, distracts and obfuscates

#Resistances
@export var insight : int = 0 #Counters Apathy
@export var grace : int = 0 #Counters Fragility 
@export var serenity : int = 0 #Counters Anxiety
@export var hope : int = 0 #Counters All

func _ready() -> void:
	ProgressionBus.connect("ready_scene", ready_scene)
	ProgressionBus.connect("start_game", scene_state_check)


func _physics_process(delta: float) -> void:
	detect_input(delta, true)
	


func ready_scene(new_scene: String):
	if ProgressionBus.scene_completion_dict[new_scene] == false:
		if new_scene == "Scene One":
			trans_timer.start(3)
			await trans_timer.timeout
			lucy.visible = true
			var tween = get_tree().create_tween()
			tween.tween_property(lucy, "global_position", Vector2(80, 32), 2)
			await tween.finished
			scene_trigger(new_scene)
		
		elif new_scene == "Scene Two":
			lucy.global_position = Vector2(48, -16)
		
		elif new_scene == "Scene Three":
			lucy.visible = false

func scene_trigger(new_scene: String):
	ProgressionBus.emit_signal("start_scene", new_scene)

func scene_state_check():
	if ProgressionBus.scene_completion_dict["Scene Three"] == true:
		lucy.visible = false

#func greetings_talk():
#	DialogueManager.show_dialogue_balloon(lucy.opening_dialogue, "start")

func detect_input(delta, process: bool):
	var direction = 0
	
	if process == true and player_active == true:
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
	
	if Input.is_action_just_pressed("Player 1"):
		player_active = false
	
	if Input.is_action_just_pressed("Player 2"):
		player_active = true


func _on_trans_timer_timeout() -> void:
	pass # Replace with function body.
