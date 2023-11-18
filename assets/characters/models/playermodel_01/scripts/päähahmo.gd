extends CharacterBody2D
@export var Area2d_Luoti : PackedScene = preload("res://scenes/area_2d_luoti.tscn")

@onready var screensize = get_viewport_rect().size
@onready var sprite = $Päähahmo_model
@onready var luoti = $bulletSpawnPoint
# Character speed
@export var SPEED = 150.0
# How high main character can jump negative means upwards, positive downwards
@export var JUMP_VELOCITY = -400.0
@export var LADDER_SPEED = 2
# Get the gravity from the project settings to be synced with RigidBody nodes.
var DEFAULT_GRAV = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = DEFAULT_GRAV
var current_direction = 1
var on_ladder : bool = false

func _physics_process(delta):
	var direction = Input.get_axis("Left", "Right")
	if not is_on_floor(): velocity.y += gravity * delta # Add the gravity.
	handle_jump()
	handle_movement(direction)	
	handle_player_flip(direction)	
	handle_shoot()
	handle_ladder()
	move_and_slide()
	update_animations(direction)

func handle_movement(direction):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func handle_jump():
	if Input.is_action_just_pressed("Up") and on_ladder != true:
		if is_on_floor():
			velocity.y = JUMP_VELOCITY

func handle_ladder():
	if on_ladder == true:
		if Input.is_action_pressed("Up"):
			gravity = 0
			velocity.y = 0
			position.y -= LADDER_SPEED
		elif Input.is_action_pressed("Down") and not is_on_floor():
			gravity = 0
			velocity.y = 0
			#if not is_on_floor():
			position.y += LADDER_SPEED
	else:
		on_ladder = false
		gravity = DEFAULT_GRAV
		
func should_climb_ladder() -> bool:
	if on_ladder and (Input.is_action_pressed("Up") or Input.is_action_pressed("Down")):
		return true
	else:
		return false

func handle_player_flip(direction):
	if direction != 0:
		sprite.flip_h = (direction < 0)
		if direction > 0:
			current_direction = 1
		elif direction < 0: 
			current_direction = -1
		if current_direction == 1 and $bulletSpawnPoint.position.x < 0 or current_direction == -1 and $bulletSpawnPoint.position.x > 0:
			$bulletSpawnPoint.position *= Vector2(-1,1)
		
func update_animations(direction):
	if is_on_floor():
		# If player is not moving play idle animation from päähahmo.tscn
		if direction == 0:
			# Play Idle animation from päähahmo.tscn
			sprite.play("Idle")
		else:
			# Play Run_right animation from päähahmo.tscn
			sprite.play("Run_right")
	else:
		pass

func handle_shoot():
	if Input.is_action_just_pressed("Shoot"):
		# Spawn new scene from area_2d_luoti 
		var b = Area2d_Luoti.instantiate()
		b.init(current_direction)
		owner.add_child(b)
		# Move bullet spawnpoint to near our character which is set up in Päähahmo_container
		b.transform = $bulletSpawnPoint.global_transform

func _on_ladder_check_body_entered(_body):
	on_ladder = true

func _on_ladder_check_body_exited(_body):
	on_ladder = false
