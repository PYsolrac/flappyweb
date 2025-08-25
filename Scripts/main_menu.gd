extends Control

@onready var start: Button = $VBoxContainer/Start as Button
@onready var exit: Button = $VBoxContainer/Exit as Button
@onready var start_level = preload("res://Scenes/main.tscn") as PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start.button_down.connect(_on_start_pressed)
	exit.button_down.connect(_on_exit_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
#ESTA FUNCION NO SE QUE HACE, PERO NO AFECTA EN NADA DE MOMENTO

func _on_start_pressed() -> void:
	#print("Presionaste start") #esto al parecer se hace como una prueba de que lo que hicimos si funciona
	get_tree().change_scene_to_packed(start_level)
	
func _on_options_pressed() -> void:
	#print("Presionaste ajustes")
	pass #CUANDO AGRUEGE OPCIONES COMO CAMBIAR EL VOLUMEN O ALGO ASI ACTIVARE ESTE BOTON, MIENTRAS NO HACE NADA

func _on_exit_pressed() -> void:
	#print("Presionaste salir")
	get_tree().quit()
