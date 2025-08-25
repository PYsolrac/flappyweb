extends Area2D

signal hit #creamos esta señal para todo lo que nos hace daño, osea el suelo y las tuberias
signal scored

func _on_body_entered(body: Node2D) -> void:
	hit.emit()
	
func _on_score_area_body_entered(body: Node2D) -> void:
	scored.emit()#esto es para detectar cuando el jugador pasa por las tuberias y que haga un seguimiento de 
	#el score que lleva acumulado el jugador
	
