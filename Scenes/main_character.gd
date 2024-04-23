extends CharacterBody2D

#Constantes
const SPEED = 325.0
const JUMP_VELOCITY = -900.0

#Variables

@onready var playerSprite = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var doubleJumping = 0
var dying = false
var isSpawning = false
var spawnCoordinates = Vector2(829,1592)
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
	spawn le joueur aux coordonnées de spawn
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
	if not dying and not isSpawning :
		if (velocity.x > 1 || velocity.x < -1) :
			playerSprite.animation = "walk"
		else :
			playerSprite.animation = "idle"
			
		#Gravité et sauts
		if not is_on_floor():
			velocity.y += gravity * delta
			playerSprite.animation = "jump"

			if Input.is_action_just_pressed("jump") and doubleJumping == 0 :
				velocity.y = JUMP_VELOCITY
				doubleJumping = 1
			
		if is_on_floor() :
			doubleJumping = 0

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		#Déplacements latéraux
		var direction = Input.get_axis("left", "right")
		if direction :
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, 2000*delta)

		move_and_slide()

		#Orientation du sprite
		if (velocity.x < -1):
			playerSprite.flip_h =  true 
		if (velocity.x > 1):
			playerSprite.flip_h = false 
		if (position.y>2700 and velocity.y>1000):#mort par chute
			start_death()

	
	else :
		if dying :
			#Fait disparaitre et réapparaite le joueur
			if playerSprite.frame == 6 :
				playerSprite.play("desappearing")
			if playerSprite.animation == "desappearing" and playerSprite.frame == 6 :
				dying = false
				spawn()
		if isSpawning :
			#Immobilise le joueur le temps se son apparition
			if playerSprite.frame == 6 :
				velocity = Vector2(0,0)
				isSpawning = false
		
