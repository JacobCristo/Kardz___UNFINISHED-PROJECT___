@tool
class_name Card extends Node2D

signal mouse_entered(card: Card)
signal mouse_exited(card: Card)

@export var CardName: String = "Card Name"
@export var Attack: int = 0
@export var Health: int = 0
@export var CardImage: Node2D
@export_enum("Attacker", "Defender", "Special", "Gold") var CardType: String

@onready var card_sprite: Sprite2D = $BaseCardSprite
@onready var image_sprite: Sprite2D = $CardImage/CardImageSprite
@onready var attack: Label = $StatsDisplay/AttackLabel
@onready var health: Label = $StatsDisplay/HealthLabel
@onready var name_label: Label = $CardName/NameLabel
@onready var area2d: Area2D = $Area2D

func _ready() -> void:
	set_values(CardName, Attack, Health, CardType)

func highlight():
	card_sprite.set_modulate(Color(1, 1, 0))

func un_highlight():
	card_sprite.set_modulate(Color(1, 1, 1, 1))

func set_values(p_card_name: String, p_attack: int, p_health: int, p_card_type: String):
	name_label.set_text(p_card_name)
	attack.set_text(str(p_attack))
	health.set_text(str(p_health))

	match p_card_type:
		"Attacker":
			card_sprite.texture = load("res://Assets/Card Templates/Kardz_Red_Template.png")
		"Defender":
			card_sprite.texture = load("res://Assets/Card Templates/Kardz_Blue_Template.png")
		"Special":
			card_sprite.texture = load("res://Assets/Card Templates/Kardz_Green_Template.png")
		"Gold":
			card_sprite.texture = load("res://Assets/Card Templates/Kardz_Gold_Template.png")

func _on_area_2d_mouse_entered() -> void:
	#print("Mouse entered on card:", CardName)
	mouse_entered.emit(self)

func _on_area_2d_mouse_exited() -> void:
	#print("Mouse exited on card:", CardName)
	mouse_exited.emit(self)
