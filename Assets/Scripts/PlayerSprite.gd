extends Sprite2D

var player 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# orient the sprite in the right direction
	if WorldDirection.direction == WorldDirection.Direction.RIGHT:
		scale.x = 0.5
	else:
		scale.x = -0.5
	
	# get all the food values and put them between 0 and 20
	var sugar = player._sugar.value
	var protein = player._protein.value
	var fat = player._fat.value
	var water = player._water.value
	var fiber = player._fiber.value
	var vitamin = player._vitamin.value
	material.set_shader_parameter("sugar", sugar)
	material.set_shader_parameter("protein", protein)
	material.set_shader_parameter("fat", fat)
	material.set_shader_parameter("water", water)
	material.set_shader_parameter("fiber", fiber)
	material.set_shader_parameter("vitamin", vitamin)
	print(sugar,", ", protein,", ", fat,", ", water,", ", fiber,", ", vitamin)
