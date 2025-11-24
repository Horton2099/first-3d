extends Node

@export var mob_scene: PackedScene


func _on_mob_timer_timeout():
	#Create a new instance of the Mob scene
	var mob = mob_scene.instantiate()
	
	#Choose a random location on the SpawnPath.
	# We store the refernce to the SpawnLocation node.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	# And give it a random offset.
	mob_spawn_location.progress_ratio = randf()
	
	var player_postion = $Player.position
	mob.initialize(mob_spawn_location.position, player_postion)
	
	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
