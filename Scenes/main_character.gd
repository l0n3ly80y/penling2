extends CharacterBody2D

#Constantes
const SPEED = 325.0
const JUMP_VELOCITY = -900.0

#Variables

@onready var playerSprite = $AnimatedSprite2D
@onready var double_jump_sound = $DoubleJumpSound
@onready var spawn_sound = $SpawnSound


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var doubleJumping = 0
var dying = false
var isSpawning = false
var spawnCoordinates = Vector2(829,1592)
var rollingAnimation = false
var endurance = 1000

func jump_player(speed):
	"""
	IN:speed, vitesse du saut
	Propulse le joueur sur l'axe y de speed
	"""
	velocity.y=speed

func push_player(direction,speed,max_speed):
	"""
	Pousse le joueur dans la direction ('y' ou 'x'), de la speed, jusqu'à ce que soit atteint la max_speed
	"""
	if direction=='y':
		if max_speed<0:
			if velocity.y>max_speed:
				#si tu cherhces un bug il est là je pense
				if velocity.y>0:
					if velocity.y>800:#au cas où il va trop vite vers le bas, a equilibrer
						velocity.y+=-250
					velocity.y+=speed*((-max_speed)/(-max_speed-velocity.y))#calcul pour adapter la vitesse de propulsion relativement à la vitesse max
				else:
					velocity.y+=speed*((-max_speed)/(-max_speed-velocity.y))
		else:
			if velocity.y<max_speed:
				#il est ptt ici aussi 
				velocity.y+=speed*(max_speed/(max_speed-velocity.y))#calcul pour " 
	else:
		if max_speed<0:#a ajuster differement car pas de gravité
			if velocity.x>max_speed:
				velocity.x+=speed
		else:
			if velocity.x<max_speed:
				velocity.x+=speed
		  
func start_death():
	"""
	Démarre l'annimation de mort
	"""
	dying = true
	playerSprite.play("hit")

func set_spawn(pos_x,pos_y):
	"""met de nouvelle coordonnees de spawn"""
	spawnCoordinates.x=pos_x
	spawnCoordinates.y=pos_y

func spawn():
	"""
	Spawn le joueur aux coordonnées de spawn
	"""
	isSpawning = true
	position = spawnCoordinates
	playerSprite.play("appearing")


func _ready() :
	"""
	Démarre l'animation de spawn au lancement du jeu
	"""
	spawn()


func _physics_process(delta):
	#Animations
	#game_manager.affiche_endurance()
	if not dying and not isSpawning :
		if is_on_wall() :
			doubleJumping = false
			rollingAnimation = false
			playerSprite.animation = "onwall"
			if velocity.y > 0 :
				if velocity.y < 250 :
					velocity.y += 0.1 * gravity * delta
				elif velocity.y > 250 :
					velocity.y -= 0.1 * gravity * delta
			else :
				velocity.y += 1.5 * gravity * delta


		if rollingAnimation :
			playerSprite.animation = "roll"

		if playerSprite.animation == "roll" and playerSprite.frame == 5 :
			rollingAnimation = false

		if (velocity.x > 1 || velocity.x < -1) and is_on_floor() and not is_on_wall() :
			playerSprite.animation = "walk"
		else :
			if is_on_floor() and not is_on_wall() :
				playerSprite.animation = "idle"

		# Add the gravity.
		if not is_on_floor() and not is_on_wall() :
			velocity.y += gravity * delta
			if rollingAnimation == false :
				playerSprite.animation = "jump"

			if Input.is_action_just_pressed("jump") and not doubleJumping and endurance > 0 :
				double_jump_sound.play()
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
			playerSprite.flip_h =  true 
		if (velocity.x > 1):
			playerSprite.flip_h = false 
		if (position.y>2700 and velocity.y>1000):#mort par chute
			start_death()

	
	else :
		if dying :
			#Fait disparaitre et réapparaite le joueur
			if playerSprite.animation == "hit" and playerSprite.frame == 0 :
				spawn_sound.play()
			if playerSprite.frame == 6 :
				playerSprite.play("disappearing")
			if playerSprite.animation == "disappearing" and playerSprite.frame == 6 :
				dying = false
				spawn()
		if isSpawning :
			#Immobilise le joueur le temps se son apparition
			if playerSprite.frame == 6 :
				velocity = Vector2(0,0)
				isSpawning = false
		
