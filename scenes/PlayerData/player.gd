extends CharacterBody2D

const SPEED = 300
const JUMP_SPEED = -400

@onready var reflection = $"../MirrorPoint/Reflection"
var reflect_colide: Vector2 = Vector2(0,0)
var is_in_drop = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta

	if is_in_drop and is_on_floor():
		is_in_drop = false
		velocity.y = JUMP_SPEED * 1.4
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_SPEED
	
	if Input.is_action_just_pressed("drop") and !is_on_floor():
		velocity.y = -JUMP_SPEED * 3
		is_in_drop = true
	
	var direction = Input.get_axis("move_left","move_right")
	
	velocity.x = direction * SPEED
	
	if reflect_colide.x != 0:
		velocity.x = 0
	
	move_and_slide()
	if get_slide_collision_count() == 0:
		reflection.player_collide = Vector2(0,0)
	for i in get_slide_collision_count():
		var collition = get_slide_collision(i)
		reflection.player_collide = collition.get_normal()
