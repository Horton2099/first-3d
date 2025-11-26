extends Node

@export var mob_scene: PackedScene

func _ready():
	$UserInterface/Retry.hide()
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		# This restartrs the current scene.
		get_tree().reload_current_scene()

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
	# We connect the mob to the score label to update the score upon squashing
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())


func _on_player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()
