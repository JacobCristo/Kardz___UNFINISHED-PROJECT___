extends Node2D

@onready var CardScene: PackedScene = preload("res://Scenes/card.tscn")
@onready var SHIELD_CARD: PackedScene = preload("res://Scenes/Cards/ShieldCard.tscn")
@onready var SWORD_CARD: PackedScene = preload("res://Scenes/Cards/SwordCard.tscn")
@onready var hand: Hand = $CanvasLayer/Hand

func _on_draw_button_pressed() -> void:
	var sword_card = SWORD_CARD.instantiate()
	hand.add_card(sword_card)	
	
func _on_draw_button_2_pressed() -> void:
	var shield_card = SHIELD_CARD.instantiate()
	hand.add_card(shield_card)	
