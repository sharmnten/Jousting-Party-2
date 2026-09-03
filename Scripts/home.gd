extends Node2D

var available_keys = [
	'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p',
	'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l',
	'z', 'x', 'c', 'v', 'b', 'n', 'm'
]

var taken_keys = []
var selected_players = []

var players_per_row = 13
var horizontal_spacing = 80
var vertical_spacing = 150

var start_position = Vector2(120, 150)


func _ready() -> void:
	GameState.players.clear()


func _input(event) -> void:
	if event is InputEventKey and event.pressed:
		for key in available_keys:
			if Input.is_action_pressed(key):
				add_player(key)
				break


func add_player(key: String) -> void:
	available_keys.erase(key)
	taken_keys.append(key)

	var player = create_player(key)

	# Keep track of the actual player node
	selected_players.append(player)

	var player_index = selected_players.size() - 1
	var column = player_index % players_per_row
	var row = floori(float(player_index) / players_per_row)

	player.position = Vector2(
		start_position.x + column * horizontal_spacing,
		start_position.y + row * vertical_spacing
	)


func create_player(key_string: String) -> Node2D:
	var my_scene = load("res://player_template.tscn")
	var player = my_scene.instantiate()

	player.set_key(key_string)

	add_child(player)

	return player


func _on_start_pressed() -> void:
	# Save the final selected players
	GameState.players.clear()

	for player in selected_players:
		GameState.players.append({
			"key": player.key,
			"frame": player.get_node("AnimatedSprite2D").frame
		})

	print("SAVING PLAYERS: ", GameState.players)

	if GameState.players.size() >= 2:
		get_tree().change_scene_to_file("res://game.tscn")
	else:
		print("Need at least 2 players")
