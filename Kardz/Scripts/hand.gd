@tool
class_name Hand extends Node2D

@export var hand_radius: int = 1000
@export var card_angle: float = -90
@export var angle_limit: float = 25
@export var max_card_spread_angle: float = 2.5

@onready var debug_card: Card = $DebugCard
@onready var debug_shape: CollisionShape2D = $DebugShape

var hand: Array = []
var touched: Array = []
var current_selected_card_index = -1

func add_card(card: Node2D):
	# Add card to hand and connect signals
	hand.push_back(card)
	add_child(card)
	
	# Connect signals from the card to the Hand's handling functions
	card.get_child(0).mouse_entered.connect(Callable(self, "handle_card_touched"))
	card.get_child(0).mouse_exited.connect(Callable(self, "handle_card_untouched"))
	
	reposition_cards()

func remove_card(index: int) -> Node2D:
	if !hand.is_empty():
		var removing_card = hand[index]
		hand.remove_at(index)
		remove_child(removing_card)
		reposition_cards()
		return removing_card
	return null

func reposition_cards():
	var card_spread = min(angle_limit / hand.size(), max_card_spread_angle)
	var current_angle = -(card_spread * (hand.size() - 1)) / 2 - 90
	for card in hand:
		_update_card_transform(card, current_angle)
		current_angle += card_spread

func get_card_position(angle_deg: float) -> Vector2:
	var x: float = hand_radius * cos(deg_to_rad(angle_deg))
	var y: float = hand_radius * sin(deg_to_rad(angle_deg))
	
	return Vector2(int(x), int(y))

func _update_card_transform(card: Node2D, angle_in_drag: float):
	card.set_position(get_card_position(angle_in_drag))
	card.set_rotation(deg_to_rad(angle_in_drag + 90))

func handle_card_touched(card: Card):
	print("Card touched:", card.CardName)
	if touched.has(card):
		return
	touched.push_back(card)

func handle_card_untouched(card: Card):
	print("Card untouched:", card.CardName)
	if touched.has(card):
		touched.erase(card)

func _input(event):
	if event.is_action_pressed("click") && current_selected_card_index >= 0:
		remove_card(current_selected_card_index)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if touched.is_empty():
		print("empty")
	
	for card in hand:
		current_selected_card_index = -1
		card.un_highlight()
	
	if !touched.is_empty():
		var highest_touched_index: int = -1
		
		for touched_card in touched:
			highest_touched_index = max(highest_touched_index, hand.find(touched_card))
			
		if highest_touched_index >= 0 && highest_touched_index < hand.size():
			hand[highest_touched_index].highlight()
			current_selected_card_index = highest_touched_index
	
	if (debug_shape.shape as CircleShape2D).radius != hand_radius:
		(debug_shape.shape as CircleShape2D).set_radius(hand_radius)
		
	_update_card_transform(debug_card, card_angle)
