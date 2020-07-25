extends Panel

var guy_icon := preload("res://ui/textures/GuyIcon.png")
var manager_icon := preload("res://ui/textures/ManagerIcon.png")
var customer_icon := preload("res://ui/textures/CustomerIcon.png")
var customer_names = ["Average Andy", "Boring Bobby", "Cumbersome Caleb", 
"Dummy Dylan", "Egoistic Ethan", "Flaky Franklin", "Greedy Gilbert", 
"Hairy Harvey", "Icy Isaac", "Jobless Jacob", "Kooky Kenny", "Loser Larry", 
"Moody Melvin", "Needy Nathan", "Obnoxious Olaf", "Petty Parker", 
"Quirky Quinton", "Raging Randy", "Smelly Simon", "Tasteless Tanner", "Ugly Ulric",
"Vulture Vernon", "Wrinkly Wallace", "\"X\"-tra Xavier", "Yawner Yuki", 
"Zoomer Zachary"
]

onready var icon: TextureRect = $HBoxContainer/ProfileBorder/Profile
onready var npc_name: Label = $HBoxContainer/VBoxContainer/Name
onready var text: Label = $HBoxContainer/VBoxContainer/Text


func _ready() -> void:
	randomize()


func dialogue_guy(text_: String):
	icon.texture = guy_icon
	npc_name.text = "Guy"
	text.text = text_


func dialogue_manager(text_: String):
	icon.texture = manager_icon
	npc_name.text = "Manager Manny"
	text.text = text_


func dialogue_customer(text_: String):
	icon.texture = customer_icon
	npc_name.text = customer_names[randi() % customer_names.size()]
	text.text = text_
