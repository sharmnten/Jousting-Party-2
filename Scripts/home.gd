extends Node2D

@onready var available_keys = ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p',
	'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l',
	'z', 'x', 'c', 'v', 'b', 'n', 'm']
@onready var taken_keys=[]
#var player_scene = preload("res://Player.tscn")  # Adjust path if needed

func _ready() -> void:
	pass

func _input(event):
	if event is InputEventKey and event.pressed:
		for key in available_keys:
			var action_name = key
			if Input.is_action_pressed(action_name):
				available_keys.erase(key)
				taken_keys.append(key)
				var player = create_player(key)
				player.position=Vector2(30*letter_to_number(key),100)
				break  # Prevent multiple spawns per frame

func create_player(key_string: String) -> Node2D:
	var my_scene = load("res://player_template.tscn")
	var player = my_scene.instantiate()
	player.set_key(key_string)
	add_child(player)
	return player
	#var player = player_scene.instantiate()
	#player.name = "Player_" + key_string
	#player.position = Vector2(randf_range(100, 500), randf_range(100, 500))  # Random spawn position
	#add_child(player)
func letter_to_number(letter: String) -> int:
	print(ord(letter.to_upper()) - ord('A'))
	return ord(letter.to_upper()) - ord('A')
