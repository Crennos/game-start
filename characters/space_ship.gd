extends CharacterBody2D

#Objects
@onready var space_ship : Sprite2D = $Ship_Sprite
@onready var space_ship_shield : Sprite2D = $Ship_Shield_Sprite
@onready var hurt_box : Area2D = $Hurt_Box_Area
@onready var shield_hurt_box : Area2D = $Shield_Hurt_Area

#SFX's
@onready var laser_sfx : AudioStreamPlayer = $Laser_Audio
@onready var hurt_sfx : AudioStreamPlayer = $Hurt_Audio

#Timers
@onready var left_laser_timer : Timer = $Left_Laser_Timer
@onready var right_laser_timer : Timer = $Right_Laser_Timer
@onready var blink_timer : Timer = $Blink_Timer
@onready var invul_timer : Timer = $Invuln_Timer
@onready var shield_timer : Timer = $Shield_Timer


const SPEED = 100.0


#Player and Ship Status
var ship_health : int = 3
var player_lives : int = 3
var left_laser : bool = true
var right_laser : bool = true
var ship_shield : int = 1


#Player Progress
var player_score : int = 0


func _ready() -> void:
	ProgressionBus.connect("score_kill", score_increase)
	print("Start Shield ", ship_shield)


func _physics_process(delta: float) -> void:
	detect_input()
	laser_fire()
	move_and_slide()
	shield_check()


func detect_input():
	var direction := Input.get_axis("key_a", "key_d")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

#Handles Firing of Lasers
func laser_fire():
	var left_laser_pos : Vector2 = space_ship.global_position - Vector2(13, -4) 
	var right_laser_pos : Vector2 = space_ship.global_position - Vector2(-13, -4)
	
	
	if Input.is_action_just_pressed("left_fire") and left_laser_timer.is_stopped():
		var left_laser_origin = preload("res://blue_laser.tscn")
		var left_laser_fire = left_laser_origin.instantiate()
		left_laser_fire.spawn_pos = left_laser_pos
		add_sibling(left_laser_fire)
		laser_sfx.play()
		left_laser_timer.start(0.3)
	if Input.is_action_just_pressed("right_fire") and right_laser_timer.is_stopped():
		var right_laser_origin = preload("res://blue_laser.tscn")
		var right_laser_fire = right_laser_origin.instantiate()
		right_laser_fire.spawn_pos = right_laser_pos
		add_sibling(right_laser_fire)
		laser_sfx.play()
		right_laser_timer.start(0.3)

#Handles Damage to Player Adjustment
func hurt_ship():
	if invul_timer.is_stopped() == true:
		ship_health -= 1
		ProgressionBus.emit_signal("health_count", ship_health)
		if ship_health == 0:
			destruct()
		left_laser_timer.start(3)
		right_laser_timer.start(3)
		invul_timer.start()
		blinker()
		hurt_sfx.play()
		hurt_box.monitoring = false
	else:
		pass

#Handles Damage Intercepted by Player Shield
func hurt_shield():
	if ship_shield > 0:
		ship_shield -= 1
		if ship_shield == 0:
			ProgressionBus.emit_signal("shield_state", "Charging")
			shield_timer.start()
	else:
		pass

#Processing Check for Shield Status
func shield_check():
	if ship_shield > 0:
		shield_hurt_box.monitorable = true
		space_ship_shield.visible = true
	else:
		shield_hurt_box.monitorable = false
		space_ship_shield.visible = false

#Initiates the Blinker Sequence
func blinker():
	if invul_timer.is_stopped() == false:
		blink_timer.start()
	else:
		blink_timer.stop()
		space_ship.visible = true

#Toggles Visibility
func toggle_vis(toggle: Object):
	if toggle.visible == true:
		toggle.visible = false
	else:
		toggle.visible = true

#Handles Player Destruction Sequence
func destruct():
	if player_lives == 0:
		print("Game Over")
	else:
		player_lives -= 1
		print("Lives: ", player_lives)
		ProgressionBus.emit_signal("live_count", player_lives)
		ship_health = 3
		ProgressionBus.emit_signal("health_count", ship_health)
		ship_shield = 1

func score_increase(value: int):
	player_score += value


func _on_hurt_box_area_area_entered(body: Object) -> void:
	if body.projectile == "Enemy":
		hurt_ship()
		


func _on_invuln_timer_timeout() -> void:
	hurt_box.monitoring = true


func _on_blink_timer_timeout() -> void:
	toggle_vis(space_ship)
	blinker()


func _on_shield_hurt_area_area_entered(body: Object) -> void:
	if body.projectile == "Enemy":
		hurt_shield()


func _on_shield_timer_timeout() -> void:
	ship_shield = 1
	ProgressionBus.emit_signal("shield_state", "On")
