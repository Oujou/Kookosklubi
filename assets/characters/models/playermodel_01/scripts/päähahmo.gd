extends CharacterBody2D
@onready var screensize = get_viewport_rect().size
@export var Area2d_Luoti : PackedScene = preload("res://scenes/area_2d_luoti.tscn")

var on_ladder : bool = false

# Character speed
const SPEED = 150.0

# How high main character can jump negative means upwards, positive downwards
const JUMP_VELOCITY = -400.0

@onready var sprite = $Päähahmo_model
@onready var luoti = $bulletSpawnPoint

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	#print(on_ladder)
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Up"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction != 0:
		sprite.flip_h = (direction == -1)
		
	if Input.is_action_just_pressed("Shoot"):
		shoot()

	move_and_slide()
	
	update_animations(direction)

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

func shoot():
	# Spawn new scene from area_2d_luoti 
	var b = Area2d_Luoti.instantiate()
	# 
	owner.add_child(b)
	
	# Move bullet spawnpoint to near our character which is set up in Päähahmo_container
	b.transform = $bulletSpawnPoint.global_transform


func _on_ladder_check_body_entered(body):
	on_ladder = true

func _on_ladder_check_body_exited(body):
	on_ladder = false
