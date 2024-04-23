extends TextureButton
@export var windowScene = ""
@export var iconName = ""
var window
var windowInstance

func _ready():
	window = load(windowScene)
	$name.text = "[center]"+iconName+"[/center]"

func _on_pressed():
	windowInstance = window.instantiate()
	get_parent().add_sibling(windowInstance)
