extends Node2D

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	pass

func highlight():
	$Card.highlight()

func un_highlight():
	$Card.un_highlight()
