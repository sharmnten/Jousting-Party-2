extends CharacterBody2D


var SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var direction := 1
@onready var jumpable = true
@onready var health = 3
@onready var state ="fine"
@onready var cooldown = false
@export var key ="ui_accept"
func change_direction()->void:
	direction = -direction
	$Sprite2D.flip_h=not $Sprite2D.flip_h
func take_damage() -> void:
	state = "damaged"
	SPEED = 0
	print("player damaged")
	# Short delay before applying damage
	if cooldown == false:
		health -= 1
		cooldown = true
	if health <= 0:
		queue_free()
		return
	# Longer delay before recovering
	await get_tree().create_timer(7.0).timeout
	velocity.y = JUMP_VELOCITY #Jumps after taking damage.
	cooldown = false
	state = "fine"
	SPEED = 300
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed(key) and state=="fine":
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed(key) and is_on_floor():
		change_direction()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if(state=="damaged"):
		SPEED=0
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		# Check what you collided with
		if collider.is_in_group("player"):
			if(position.y>collider.position.y):
				collider.take_damage()
		elif collider.is_in_group("ground"):
			take_damage()

func wait(seconds: float) -> void:
	var timer = get_tree().create_timer(seconds)
	await timer.timeout
