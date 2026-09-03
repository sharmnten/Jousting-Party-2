extends Node2D

var key: String = ""
var current_frame: int = 0

var framecount: int = 0
var num_player_sprites: int = 4


func set_key(key_string: String) -> void:
	key = key_string
	
	if is_node_ready():
		$Key.frame = letter_to_number(key)


func _ready() -> void:
	if key != "":
		$Key.frame = letter_to_number(key)


func _input(event: InputEvent) -> void:
	if key == "":
		return

	if event.is_action_pressed(key):
		current_frame += 1
		$Key.frame = letter_to_number(key) + 26
		$AnimatedSprite2D.frame = current_frame % num_player_sprites

	if event.is_action_released(key):
		$Key.frame = letter_to_number(key)


func letter_to_number(letter: String) -> int:
	return ord(letter.to_upper()) - ord("A")
