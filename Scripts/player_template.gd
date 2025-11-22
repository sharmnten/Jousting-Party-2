extends Node2D

@onready var key
@onready var current_frame =0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Key.frame=letter_to_number(key)
	pass # Replace with function body.

@onready var framecount =0
@onready var num_player_sprites =3
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_key(key_string:String)-> void:
	key = key_string
func _input(event: InputEvent) -> void:
	if event.is_action_pressed(key):
		current_frame=current_frame+1
		$Key.frame=letter_to_number(key)+26
		$AnimatedSprite2D.frame=current_frame%num_player_sprites
	if event.is_action_released(key):
		$Key.frame=letter_to_number(key)
func letter_to_number(letter: String) -> int:
	#print(ord(letter.to_upper()) - ord('A'))
	return ord(letter.to_upper()) - ord('A')
