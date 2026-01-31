extends CharacterBody2D

@onready var blue_laser : CharacterBody2D = $Blue_Laser
@onready var hit_box : Area2D = $"Hit_Box_Area"

const SPEED = -200

var spawn_pos : Vector2
var triggered : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = spawn_pos
	ProgressionBus.connect("projectile_boom", explode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	shoot()
	

#Handles Laser Firing Velocity
func shoot():
	velocity.y = SPEED
	move_and_slide()

#Handles Impact Explosion FX
func explode(type: String):
	print(type)
	print(triggered)
	if type == "Enemy" and triggered == true:
		print("Boom")
		call_deferred("queue_free")
	else:
		pass
		

func _on_hit_box__area_area_entered(body: Object) -> void:
	if body.collision_layer == 1:
		queue_free()
		
	elif body.collision_layer == 8:
		call_deferred("queue_free")
