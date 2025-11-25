extends CharacterBody3D

#Minimum speed of the mob in meters per sec
@export var min_speed = 10
#Maximum speed of the mob in meters per sec
@export var max_speed = 18
# Horizontal bounce when enemies collide
@export var impulse_bounce = 10

# Emitted when the player jumped on the mob.
signal squashed

func _physics_process(delta):
	
	# Iterate through collisions and find those with enemies
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		# check for duplicated and continue past null
		if collision.get_collider() == null:
			continue
		if collision.get_collider().is_in_group("mob"): # || collision.get_collider().is_in_group("player"):
			# collsion.get_normal() poitns away from mob
			var mob = collision.get_normal()
			# Bounce in the opposite direction of the impact normal
			velocity += mob * impulse_bounce
		if velocity.length() > 0.1:
			look_at(position + velocity, Vector3.UP)
			
	var max_mob_speed = 20.0
	if velocity.length() > max_mob_speed:
		velocity = velocity.normalized() * max_mob_speed
			
	move_and_slide()
#this function will be called from the Main scene
func initialize(start_position, player_position):
	#We position the mob by placing it at start_position
	#and rotate it towards player_position, so it looks at the player.
	look_at_from_position(start_position, player_position, Vector3.UP)
	#Rotate this mob randomly within range of -45 and +45 degrees,
	#so that it doesn't move directly towards the player.
	rotate_y(randf_range(-PI / 4, PI / 4))
	#We calculate a random speed (integer)
	var random_speed = randi_range(min_speed, max_speed)
	#We calculate a forward velocity that represents the speed.
	velocity = Vector3.FORWARD * random_speed
	#We then rotate the velocity vector based on the mob's Y rotation
	#in order to move in the direction the mob is looking.
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	

func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()

func squash():
	squashed.emit()
	queue_free()
