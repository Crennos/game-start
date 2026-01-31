extends CharacterBody2D


#Objects
@onready var enemy_ship : Sprite2D = $Enemy_Sprite


#SFX's
@onready var enemy_laser_sfx : AudioStreamPlayer = $Enemy_Laser_SFX


#Timers
@onready var laser_timer : Timer = $Laser_Timer
@onready var recoil_timer : Timer = $Recoil_Timer

const SPEED = 10.0

var laser_ready : bool = true
var spawn_pos : Vector2

func _ready() -> void:
	ready_fire()
	global_position = spawn_pos
	


func _physics_process(delta: float) -> void:
	move()
	move_and_slide()

func move():
	velocity.y = SPEED


func ready_fire():
	var aim = randi_range(1, 4)
	laser_timer.start(aim)


func laser_fire():
	var fire_point = enemy_ship.global_position + Vector2(0, 8)
	
	var red_laser = preload("res://red_laser.tscn")
	var fire_laser = red_laser.instantiate()
	fire_laser.spawn_pos = fire_point
	add_sibling(fire_laser)
	enemy_laser_sfx.play()

	recoil_timer.start()


func _on_laser_timer_timeout() -> void:
	laser_fire()
	


func _on_recoil_timer_timeout() -> void:
	ready_fire()


func _on_hurt_box_area_area_entered(body: Object) -> void:
	if body.projectile == "Player":
		ProgressionBus.emit_signal("score_kill", 1)
#		print("Ow")
		queue_free()


func _on_collision_area_area_entered(body: Object) -> void:
	if body.collision_layer == 1:
		queue_free()
