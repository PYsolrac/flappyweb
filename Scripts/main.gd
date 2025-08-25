extends Node
#AQUI EN EL MAIN vamos a poner todas las variables del juego

@export var pipe_scene : PackedScene #esto es para exportar la escena de las tuberias aqui al main ya que
#vamos a hacerlas mediante codigo aqui, AHORA NOS SALE UNA OPCION EN EL NODE MAIN EN LA VENTANA DERECHA 
#EN INSPECTOR NOS SALE PIPE SCENE Y AHI ARRASTRAMOS NUESTRA PIPE.SCN
@export var main_menu_scene : PackedScene

var game_running : bool #la mayoria de lo tipo bool se consideran como FLAGS osea banderas que indican algo
var game_over : bool #en este caso estas 2 indicarac si el juego sigue o termina mediante el true o false
var scroll #usaremos esta para mover las imagenes de la pantalla
var score
const SCROLL_SPEED : int = 4 #esto es para hacer que el juego vaya mas o menos rapido
var screen_size : Vector2i
var ground_height : int
var pipes : Array #este es un array para aplicarle lo mismo por asi decirlo a todas las tuberias que usemos
const PIPE_DELAY : int = 100
const PIPE_RANGE : int = 200 #estas ultimas 2 se encargan de la generacion de las tuberias en pantalla
#esta const de pipe range se aplica al fin el la funcion de generate pipes de hasta abajo, lo que hace es que
#definir los limites de las coordenadas

func _ready() -> void:
	screen_size = get_window().size #esto se agrego hasta despues de tener las 3 escenas juntas
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()#AHORA AL AGREGAR LA SCENE DE PIPE
	#AGREGAMOS ESTA LINEA QUE DETERMINA LA MEDIDA DEL ALTO DEL SUELO, EN EL READY PARA QUE SIEMPRE ESTE LISTO
	new_game()
	
func new_game(): #Esta funcion se encargara de determinar o reiniciar las variables iniciales 
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	$ScoreLabel.text = "SCORE: " + str(score) #y actualizara el txt del score
	$GameOver.hide() #escondemos la scene de GameOver ya que el boton de restart que esta en esa escena
	#solo debe aparecer cuando el jugador pierde
	get_tree().call_group("pipes", "queue_free") #WOW ESTO DE HACER UN GRUPO DE LAS PIPES HACE QUE 
	#AL REINICIAR EL JUEGO LAS TUBERIAS NO SE SOBREPONGAN CON LAS DE LA PARTIDA ANTERIOR
	pipes.clear() #recien despues de agregar el timer agregamos esto para que el juego elimine las pipes de la 
	#partida anterior
	#generamos el comienzo de las pipes
	generate_pipes() #y aqui generamos las pipes otra vez, antes de que el timer acabe de generar el resto de pipes
	$Bird.reset()#y esta reinicia la funcion del bird para que este ready(listo)
	
func _input(event: InputEvent) -> void: #esta funcion es para detectar la entrada del juego
	if game_over == false: #checamos que NO haya acabado el juego
		if event is InputEventMouseButton: #checamos si le dieron clic al mouse
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#lo que hace es iniciar el juego y el movimiento del bird al hacer clic al mouse
				if game_running == false: #si no se esta ejecutando el juego usamos el primer clic
					start_game() #del mouse para comenzar el juego
				else: # de otra forma si el juego ya esta ejecutandose y el bird sigue volando(vivo/NO a chocado) 
					if $Bird.flying:
						$Bird.flap() #entonces que el pajaro brinque con sus alas(flap)
						check_top() #la agregamos depues de crear la funcion check top y la ponemos aqui en 
						#la funcion de input justo cuando el bird hace flap(brinca), todo esto hace que si
						#el bird sale de la pantalla por arriba, muera y acabe el juego ahi
					
func start_game(): #esta funcion iniciara el juego con el bird brincando/moviendose

	game_running = true
	$Bird.flying = true
	$Bird.flap()
	#AQUI COMENZAREMOS AL INICIAR EL JUEGO NUESTRO PIPE TIMER PARA QUE SE EMPIECEN A GENERAR LAS PIPES
	$PipeTimer.start()
	
func _process(delta: float) -> void: #esta funcion con todo nos dice que despues de verificar que el juego este 
	#corriendo, si el scroll supera el tamaño de la pantalla se reseteara el scroll a 0, osea al inicio
	if game_running: #esto que hacemos es para dar el efecto de el piso infinito
		scroll += SCROLL_SPEED #si el juego esta corriendo se aumenta la velocidad del scroll
		#reseteamos el scroll
		if scroll >= screen_size.x:
			scroll = 0
		#MOVEMOS el nodo de la tierra(ground node)
		$Ground.position.x = -scroll #todo esto para dar el efecto de tierra infinita
#CHECAR SIEMPRE QUE todo ESTE DONDE DEBERIA, CADA LINEA DE CODIGO O SI NO NO ESTARA COMO QUEREMOS
#AAQUI CASI LA ARRUINO SOLO PORQUE $GROUND LO HABIA PUESTO DENTRO DE ESTE ULTIMO IF PERO HIBA FUERA 
#DE ESTE IF YA QUE SE APLICA A todo, NO SOLO EL IF DE SCROLL

		#AHORA YA DESPUES DE LO DEL TIMER, AGREGAMOS ESTO DE ABAJO PARA MOVER LAS PIPES
		for pipe in pipes: #iteramos por la lista de las pipes
			pipe.position.x -= SCROLL_SPEED #y actualizamos la posicion de cada pipe

func _on_pipe_timer_timeout() -> void: #esto es para que las tuberias se generen mediante el timer
	generate_pipes()
	
func generate_pipes():
	var pipe = pipe_scene.instantiate() #esto de instantiate se encarga de crear una nueva copia
	pipe.position.x = screen_size.x + PIPE_DELAY #esto hace que la tuberia aparezca del lado derecho con
	#con delay y avance a la izquierda
	pipe.position.y = (screen_size.y - ground_height) / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	#esta hace lo mismo pero en y, lo que hace es basarse en la altura vertical que hay disponible
	#y ademas se añaden rangos de valores aleatorios para que las tuberias aparezcan con diferentes
	#alturas para hacer el juego mas desafiante, define los limites de las coordenadas y los valores random
	pipe.hit.connect(bird_hit) #aqui conectamos la señal de hit para identificar cuando el bird 
	#haga contacto con ellas
	pipe.scored.connect(scored) #AQUI PONEMOS LA SEÑAL DE DETECTAR EL SCORE
	add_child(pipe) #aqui agregamos una child scene para la main scene 
	pipes.append(pipe) #y agregamos las pipes a nuestro array de pipes que creamos al principio para que
	#se aplique a todas las tuberias
	
func scored(): #esta funcion va a detectar el score actual al pasar por las tuberias
	score +=1 #incrementara 1 
	$ScoreLabel.text = "SCORE: " + str(score) #y actualizara el txt del score
	
func check_top(): #esta funcion se encarga de el choque del bird arriba
		if $Bird.position.y < 0: #si la posicion del bird es menor a 0 quiere decir que esta fuera de pantalla
			$Bird.falling = true #entonces quiere decir que el bird esta cayendo
			stop_game() #lo que para el juego
	
func stop_game(): #esta funcion para el juego
	$PipeTimer.stop()#para la generacion de pipes
	$GameOver.show() #Aqui si mostramos el boton restart ya que el jugador paro el juego ya sea por
	#que perdio o pauso el juego y puede decidir si quiere darle a restart
	$Bird.flying = false #matiene al bird volando
	game_running = false# y actualiza estas 2 banderas
	game_over = true
	
func bird_hit():
	$Bird.falling = true #entonces quiere decir que el bird esta cayendo
	stop_game()#lo que para el juego

func _on_ground_hit() -> void:
	$Bird.falling = false #aqui ponemos bird falling false en vez de true ya que queremos que cuando el 
	stop_game()#bird caiga al suelo, ahi acabe el juego, que el bird quede en el suelo, que no pase la pantalla
#NO ENTIENDO PORQUE PERO NO HACE LO MISMO QUE EN EL VIDEO, SE SUPONE QUE AL TOCAR EL SUELO EL BIRD DEBERIA
#QUEDARSE AHI TIRADO, NO PASAR LA PANTALLA DE ABAJO PERO AUNQUE TENGO IGUAL EL CODIGO, NO HACE ESTO

func _on_game_over_restart() -> void:
	new_game()

#Y YA ESTARIA, AQUI ACABA EL TUTORIAL PARA HACER EL FLAPPY BIRD EN COMPUTADORA
#SOLO ME FALTA VER COMO HACER QUE SI TOCAS EL SUELO MUERES,
#JAJAJAJA NO ME LO CREO EL PAJARO NO MORIA AL TOCAR EL SUELO PORQUE SE ME HABIA PASADO
#PONER EL HIT EMIT AL TOCARLO en el script de ground
# AHORA SOLO ME FALTA VER SI PUEDO HACERLO EN CELULARES
