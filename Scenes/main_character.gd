extends CharacterBody2D

#Constantes
const SPEED = 325.0
const JUMP_VELOCITY = -900.0

@onready var game_manager = %GameManager
@onready var sprite_2d = $Sprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var doubleJumping = false
var isHit = false
var isSpawning = false
var spawnCoordinates = Vector2(829,1592)
var rollingAnimation = false
var endurance = 1000

func start_death():
	isHit = true
	sprite_2d.play("hit")

func spawn():
	isSpawning = true
	position = spawnCoordinates
	sprite_2d.play("appearing")

func _ready() :
	spawn()

func _physics_process(delta):
	#Animations
	game_manager.affiche_endurance()
	if not isHit and not isSpawning :
		if is_on_wall() :
			doubleJumping = false
			rollingAnimation = false
			sprite_2d.animation = "onwall"
			if velocity.y > 0 :
				if velocity.y < 250 :
					velocity.y += 0.1 * gravity * delta
				elif velocity.y > 250 :
					velocity.y -= 0.1 * gravity * delta
			else :
				velocity.y += 1.5 * gravity * delta


		if rollingAnimation :
			sprite_2d.animation = "roll"

		if sprite_2d.animation == "roll" and sprite_2d.frame == 5 :
			rollingAnimation = false

		if (velocity.x > 1 || velocity.x < -1) and is_on_floor() and not is_on_wall() :
			sprite_2d.animation = "walk"
		else :
			if is_on_floor() and not is_on_wall() :
				sprite_2d.animation = "idle"

		# Add the gravity.
		if not is_on_floor() and not is_on_wall() :
			velocity.y += gravity * delta
			if rollingAnimation == false :
				sprite_2d.animation = "jump"

			if Input.is_action_just_pressed("jump") and not doubleJumping and endurance > 0 :
				velocity.y = JUMP_VELOCITY
				rollingAnimation = true
				doubleJumping = true
				endurance -= 250

		if is_on_floor() :
			doubleJumping = false
			endurance = 1000

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("left", "right")
		if direction :
			velocity.x = direction * SPEED
		else :
			velocity.x = move_toward(velocity.x, 0, 2000*delta)

		move_and_slide()

		if (velocity.x < -1):
			sprite_2d.flip_h =  true 
		if (velocity.x > 1):
			sprite_2d.flip_h = false 

	
	else :
		if isHit :
			if sprite_2d.frame == 6 :
				sprite_2d.play("desappearing")
			if sprite_2d.animation == "desappearing" and sprite_2d.frame == 6 :
				isHit = false
				spawn()
		if isSpawning :
			if sprite_2d.frame == 6 :
				velocity = Vector2(0,0)
				isSpawning = false
				doubleJumping = false
				rollingAnimation = false

