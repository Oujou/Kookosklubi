extends Area2D

#Projectile speed
var speed = 750
var direction = 1

func init(dir):
	direction = dir

func _physics_process(delta):
	position += transform.x * speed * delta * direction

func _on_body_entered(body):
	# If projectile enters into mobs categorized hitbox
	if body.is_in_group("mobs"):
		# Destroy projectile
		body.queue_free()
	# Tilesets are treated as bodies so if projectile hits tileset then destroy
	if body.name == "TileMap" or body.name == "tilesetti2":
		# Destroy projectile
		queue_free()

# If projectile exits screen, destroy
func _on_visible_on_screen_notifier_2d_screen_exited():
	# Destroy
	queue_free()
