extends Node2D

#Timers
@onready var start_timer : Timer = $Start_Timer
@onready var spawn_timer : Timer = $Spawn_Timer
@onready var shield_timer : Timer = $Shield_Timer

#Spawn Points
@onready var spawn_point_one : Node2D = $Enemy_Spawn_1
@onready var spawn_point_two : Node2D = $Enemy_Spawn_2
@onready var spawn_point_three : Node2D = $Enemy_Spawn_3
@onready var spawn_point_four : Node2D = $Enemy_Spawn_4
@onready var spawn_point_five : Node2D = $Enemy_Spawn_5
@onready var spawn_point_six : Node2D = $Enemy_Spawn_6
@onready var spawn_point_seven : Node2D = $Enemy_Spawn_7
@onready var spawn_point_eight : Node2D = $Enemy_Spawn_8
@onready var spawn_point_nine : Node2D = $Enemy_Spawn_9
@onready var spawn_point_ten : Node2D = $Enemy_Spawn_10
@onready var spawn_point_eleven : Node2D = $Enemy_Spawn_11

#Screen Labels
@onready var score_label : Label = $Score_Label
@onready var level_label : Label = $Level_Label
@onready var wave_label : Label = $Wave_Label
@onready var lives_label : Label = $Lives_Label
@onready var health_label : Label = $Health_Label
@onready var shield_label : Label = $Shield_Label

#Spawn Coords, Note: Coords Change While Child of the Enemies Node, Extract to get True Coords
var spawn_pos_1 = Vector2(-83, -177)
var spawn_pos_2 = Vector2(-51, -177)
var spawn_pos_3 = Vector2(-19, -177)
var spawn_pos_4 = Vector2(13, -177)
var spawn_pos_5 = Vector2(45, -177)
var spawn_pos_6 = Vector2(77, -177)
var spawn_pos_7 = Vector2(109, -177)
var spawn_pos_8 = Vector2(141, -177)
var spawn_pos_9 = Vector2(173, -177)
var spawn_pos_10 = Vector2(205, -177)
var spawn_pos_11 = Vector2(237, -177)


#Level Var's
var level : int
var wave : int
var score : int


func _ready() -> void:
	start_timer.start()
	ProgressionBus.connect("score_kill", score_keep)
	ProgressionBus.connect("live_count", live_keep)
	ProgressionBus.connect("health_count", health_keep)
	ProgressionBus.connect("shield_state", shield_keep)


func _process(delta: float) -> void:
	pass


func toggle_vis(body: Object):
	if body.visible == true:
		body.visible = false
	else:
		body.visible = true

#Handles Wave Spawning
func wave_spawn():
	var spawn_points = [spawn_pos_1, spawn_pos_2, spawn_pos_3, spawn_pos_4, spawn_pos_5, spawn_pos_6, spawn_pos_7, spawn_pos_8, spawn_pos_9, spawn_pos_10, spawn_pos_11]
	wave += 1
	
	for spawn in spawn_points:
		var enemy_source = preload("res://characters/enemy_ship.tscn")
		var enemy_ship = enemy_source.instantiate()
#		print(spawn)
		enemy_ship.spawn_pos = spawn
		add_sibling(enemy_ship)
	
	wave_keep()

#Handles Score Text Update
func score_keep(value : int):
	score += value
	score_label.text = "Score: " + str(score)
	

#Handles Wave Text Update
func wave_keep():
	wave_label.text = "Wave " + str(wave)

#Handles Life Text Update
func live_keep(lives : int):
	lives_label.text = "Lives: " + str(lives)

#Handles Health Text Update
func health_keep(health: int):
	health_label.text = "Health: " + str(health)

func shield_keep(state: String):
	if state == "On":
		shield_label.text = "Shield: " + state
		shield_label.visible = true
		shield_timer.autostart = false
		shield_timer.stop()
	else:
		shield_label.text = "Shield: " + state
		shield_timer.autostart = true
		shield_timer.start()

func _on_spawn_timer_timeout() -> void:
	wave_spawn()


func _on_start_timer_timeout() -> void:
	wave_spawn()
	spawn_timer.start()
	spawn_timer.autostart = true


func _on_shield_timer_timeout() -> void:
	pass # Replace with function body.
