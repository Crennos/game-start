extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	detect_input(delta, true)

func detect_input(delta, process: bool):
	var direction = 0
	
	if process == true:
		if Input.is_action_pressed("left"):
			direction += -1
			velocity.x = direction * SPEED
			velocity.y = 0
		elif Input.is_action_pressed("right"):
			direction += 1
			velocity.x = direction * SPEED
			velocity.y = 0
		elif  Input.is_action_pressed("up"):
			direction += -1
			velocity.y = direction * SPEED
			velocity.x = 0
		elif  Input.is_action_pressed("down"):
			direction += 1
			velocity.y = direction * SPEED
			velocity.x = 0
		else:
			direction = 0
			velocity = Vector2.ZERO
		move_and_slide()
