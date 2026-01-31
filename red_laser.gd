extends CharacterBody2D

#Objects
@onready var red_laser : CharacterBody2D = $Red_Laser


const SPEED = 100

var spawn_pos : Vector2

func _ready() -> void:
	global_position = spawn_pos
	

func _process(delta: float):
	fire()

func fire():
	velocity.y = SPEED
	move_and_slide()

func _on_enemy_hit_area_area_entered(body: Object) -> void:
#	print(body.collision_layer)
	if body.collision_layer == 1:
		queue_free()
		
	elif body.collision_layer == 2:
		call_deferred("queue_free") #Is instantly deleting before it can register the hit, needs fix.
#		print("Red Hit")
