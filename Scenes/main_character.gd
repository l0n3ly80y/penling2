extends CharacterBody2D

#Constantes
const SPEED = 325.0
const JUMP_VELOCITY = -900.0

@onready var sprite_2d = $Sprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var double = 0
var isHit = false

func start_death():
	isHit = true
	sprite_2d.play("death")

func _physics_process(delta):
	#Animations
	if not isHit :
		if (velocity.x > 1 || velocity.x < -1) :
			sprite_2d.animation = "walk"
		else :
			sprite_2d.animation = "default"
		
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
			sprite_2d.animation = "jump"

			if Input.is_action_just_pressed("jump") and double == 0 :
				velocity.y = JUMP_VELOCITY
				double = 1
		
		if is_on_floor() :
			double = 0

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("left", "right")
		if direction :
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, 2000*delta)

		move_and_slide()

		var isLeft = velocity.x < 0
		sprite_2d.flip_h = isLeft
	
	
	else :
		if sprite_2d.frame == 6 :
			sprite_2d.play("desappearing")
		if sprite_2d.animation == "desappearing" and sprite_2d.frame == 6 :
			isHit = false
			sprite_2d.animation = "default"
			position.x = 837
			position.y = 1564
