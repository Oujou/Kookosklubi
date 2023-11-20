extends RigidBody2D

#Projectile speed
var speed = 250
var BouncesLeft = 3
var velocity : Vector2

func init(dir):
	velocity = dir * speed
	add_to_group("Bullets")

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		if collision.get_collider().has_method("_bullet_hit"):
			collision.get_collider()._bullet_hit()
		look_at(transform.origin + velocity)
	
func Remove():
	queue_free()

# If projectile exits screen, destroy
func _on_visible_on_screen_notifier_2d_screen_exited():
	# Destroy
	queue_free()

func _on_timer_timeout():
	set_collision_mask_value(10, true)
