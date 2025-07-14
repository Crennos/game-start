extends CharacterBody2D


const SPEED = 300.0

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


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func detect_input(delta, process: bool):
	pass
