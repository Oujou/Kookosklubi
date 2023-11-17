extends CharacterBody2D
@onready var screensize = get_viewport_rect().size
@export var Area2d_Luoti : PackedScene = preload("res://scenes/area_2d_luoti.tscn")
const SPEED = 150.0
const JUMP_VELOCITY = -400.0

@onready var sprite = $Päähahmo_model
@onready var luoti = $bulletSpawnPoint

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Up") and is_on_floor():
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
		if direction == 0:
			sprite.play("Idle")
		else:
			sprite.play("Run_right")
	else:
		pass

func shoot():
	var b = Area2d_Luoti.instantiate()
	owner.add_child(b)
	b.transform = $bulletSpawnPoint.global_transform
