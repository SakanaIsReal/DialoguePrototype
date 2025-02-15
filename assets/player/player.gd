extends CharacterBody2D

@export var speed: int = 150

var currentAnimation: String = "player"
var currentFacing:String = "down"
var currentFacingVector = Vector2.DOWN
var direction := Vector2.ZERO

var dash_speed = speed * 30
var dash_distance = 0
var dash_vector = Vector2.DOWN

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var player_ray_cast = $RayCast2D

var currentCharSprite: Sprite2D = null


func _physics_process(delta):	
	dash_updater(delta)
	
	if Input.is_action_just_pressed("secondary"):
		dash(delta)
		
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	facing_direction(direction)
	velocity = direction * speed
	move_and_slide()
	


#func _input(event):
	#
	
func dash_updater(delta):
	dash_distance = dash_speed * delta
	dash_vector = currentFacingVector.normalized() * dash_distance

	# Update RayCast2D target position
	player_ray_cast.enabled = true
	player_ray_cast.target_position = dash_vector

	# Force RayCast2D to update
	player_ray_cast.force_raycast_update()	
	

func dash(delta):
	#var dash_pass_item: Array = []
	
	#if player_ray_cast.is_colliding():
		#while true:
			#var hit = player_ray_cast.get_collider()
			#if 
			#print(hit)
		

	velocity = currentFacingVector * dash_speed
	move_and_collide(currentFacingVector * delta * dash_speed)
	print("dash!")


func facing_direction(input_direction: Vector2):
	var currentPlay = ""
	
	if input_direction.y < 0:
		currentFacing = "up"
		animated_sprite_2d.flip_h = true
		currentFacingVector = input_direction
	elif input_direction.x > 0:
		currentFacing = "side"
		animated_sprite_2d.flip_h = true
		currentFacingVector = input_direction
	elif input_direction.x < 0:
		currentFacing = "side"
		animated_sprite_2d.flip_h = false
		currentFacingVector = input_direction
	elif input_direction.y > 0:
		currentFacing = "down"
		animated_sprite_2d.flip_h = true
		currentFacingVector = input_direction

	currentPlay = currentAnimation + "_" + currentFacing
	animated_sprite_2d.play(currentPlay)
