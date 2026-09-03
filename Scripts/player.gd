extends CharacterBody2D

var SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DAMAGE_COOLDOWN = 7.0

var direction := 1
var health := 3
var state := "fine"
var cooldown := false
var damage_time_left := 0.0

@export var key := "ui_accept"


func set_key(new_key)->void:
	key=new_key

func _ready() -> void:
	$TimerText.visible = false


func change_direction() -> void:
	direction = -direction
	$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h


func take_damage() -> void:
	# Prevent the ground from damaging the player every frame
	if cooldown:
		return

	cooldown = true
	state = "damaged"
	SPEED = 0.0

	# Lose exactly one health
	health -= 1

	$Healthbar.visible = true
	$Healthbar.frame += 1

	if health <= 0:
		eliminate()
		return

	# Start recovery timer
	damage_time_left = DAMAGE_COOLDOWN
	$TimerText.visible = true
	$TimerText.text = "%.0f" % damage_time_left

	await get_tree().create_timer(DAMAGE_COOLDOWN).timeout

	if not is_inside_tree():
		return

	$Healthbar.visible = false

	# Launch player back into the game
	velocity.y = JUMP_VELOCITY

	state = "fine"
	SPEED = 300.0
	cooldown = false

	damage_time_left = 0.0
	$TimerText.visible = false


func eliminate() -> void:
	var players = get_tree().get_nodes_in_group("player")

	if players.size() == 2:
		call_deferred("game_over")

	queue_free()


func game_over() -> void:
	var game = get_tree().current_scene

	if game.has_method("show_control"):
		game.show_control()

	get_tree().paused = true


func _physics_process(delta: float) -> void:
	# Update recovery timer
	if cooldown:
		damage_time_left = max(damage_time_left - delta, 0.0)
		$TimerText.text = "%.0f" % damage_time_left

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Flap
	if Input.is_action_just_pressed(key) and state == "fine":
		velocity.y = JUMP_VELOCITY

		if is_on_floor():
			change_direction()

	# Horizontal movement
	velocity.x = direction * SPEED

	move_and_slide()

	# Collision detection
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider == null:
			continue

		# Hit another player from above
		if collider.is_in_group("player"):
			if global_position.y < collider.global_position.y:

				# If they're currently damaged AND lying on the ground,
				# this stomp eliminates them immediately
				if collider.state == "damaged" and collider.is_on_floor():
					collider.eliminate()

				# Otherwise they just take normal damage
				else:
					collider.take_damage()

		# Falling onto the ground only causes ONE damage
		elif collider.is_in_group("ground"):
			take_damage()
