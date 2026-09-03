extends Node2D

var player_scene = preload("res://player.tscn")


func _ready() -> void:
	randomize()
	spawn_players()


func spawn_players() -> void:
	var screen_size = get_viewport_rect().size
	var used_positions: Array[Vector2] = []

	for player_data in GameState.players:
		var player = player_scene.instantiate()

		# Set player's control key
		player.set_key(player_data["key"])

		# Find a safe random spawn position
		var spawn_position := Vector2.ZERO
		var valid_position := false
		var attempts := 0

		while not valid_position and attempts < 200:
			spawn_position = Vector2(
				randf_range(150.0, screen_size.x - 150.0),
				randf_range(100.0, screen_size.y * 0.45)
			)

			valid_position = true

			# Keep players from spawning too close together
			for other_position in used_positions:
				if spawn_position.distance_to(other_position) < 250.0:
					valid_position = false
					break

			attempts += 1

		# IMPORTANT:
		# Position the player BEFORE adding it to the scene tree
		player.position = spawn_position

		# Restore the selected character frame
		if player_data.has("frame"):
			player.get_node("AnimatedSprite2D").frame = player_data["frame"]

		# Now add the player
		add_child(player)

		used_positions.append(spawn_position)


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_back_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/home.tscn")


func show_control() -> void:
	$Control.visible = true
