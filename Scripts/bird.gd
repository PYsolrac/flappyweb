extends CharacterBody2D

const GRAVITY : int = 1000 #Asi se definen las constantes como nums enteros, esta indica lo rapido que cae el bird
const MAX_VEL : int = 600 #Este es velocidad maxima
const FLAP_SPEED : int = -500 #Este controla cuanto brinca el personaje al hacer clic
var flying : bool = false #esta se activa siempre que el bird no haya chocado con nada
var falling : bool = false #Esta variable se activa cuando el bird choca con una tuberia y cae al suelo
const START_POS = Vector2(100, 400)

func _ready() -> void: # :( Al parecer si sirve de algo la funcion ready aunque no la usemos
	pass #lo que hace es alistar/activar en este caso la funcion siguente
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN) VALE, ESTA LINEA DE CODIGO RECIEN LA AGREGUE
	#AHORA QUE VEO COMO HACER ESTE JUEGO PARA CELULAR, LO QUE HACE ES ESCONDER VISUALMENTE LA FLECHA
	#DEL MOUSE, TAMBIEN ACTIVE LO DEL TOUCH SCREEN
	
func reset(): #Esta funcion se encarga de resetear todos los parametros al iniciar a jugar de nuevo
	falling = false #la funcion ready activa esta cada vez que se reinicia el game ya que esta "ready"
	flying = false
	position = START_POS #esta es la posicion inicial por lo que se resetea aqui
	set_rotation(0) #y este es el encargado de poner al bird con la rotacion original, sin ningun giro
		
func _physics_process(delta: float) -> void: #esta se encargara de todo el movimiento/fisicas del bird
		if flying or falling: #ESTE if se encarga de todo esto de flying o falling
			velocity.y += GRAVITY * delta #RECORDAR que delta es es el tiempo transcurrido desde el frame anterior
			#ESTE velocity.y de arriba es solo para aplicarle gravedad al bird
			#Velocidad terminal
			if velocity.y > MAX_VEL:
				velocity.y = MAX_VEL
			if flying: #Si el bird esta en el aire lo rotamos, eso hace esto
				set_rotation(deg_to_rad(velocity.y * 0.05))
				$AnimatedSprite2D.play()
			elif falling: #si el bird se cae o choco, rotamos la animacion
				set_rotation(PI/2) #OSEA que la rotacion del bird se pone en 90 grados
				$AnimatedSprite2D.stop()
			move_and_collide(velocity * delta) #ESTE se pone fuera del elif ya que aplica a los anteriores tambien
			#y se encarga de mover el bird
		else: #IGUAL este, se parara la animacion en caso de que no se cumpla el if osea que el bird no este en el aire
			$AnimatedSprite2D.stop()
func flap(): #ESTA funcion se encarga de que el bird brinque hacia arriba como indicamos
	velocity.y = FLAP_SPEED















#const SPEED = 300.0 ESTO LO DEFINIO GODOT AUTOMATICAMENTE, ES COMO LA BASE POR SI QUIERES CHECARLA
#const JUMP_VELOCITY = -400.0
#
#
#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
