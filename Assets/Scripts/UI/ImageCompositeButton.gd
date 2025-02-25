extends Button
class_name ImageCompositeButton


@export var container: VBoxContainer = null
@export var buttonAnimationDuration: float = 0.1

@export_category("Images")
@export var images: Array[Resource] = []
@export var imagesSizes: Array[Vector2] = []

@export_category("Selected Images")
@export var selectedImages: Array[Resource] = []
@export var selectedImagesSizes: Array[Vector2] = []

@export_category("Shader")
@export var shader: Shader = null
@export_range(0, 1) var colorHue: float

var imagesNames: Array[String] = []
var selectedImagesNames: Array[String] = []

var isSelected: bool = false
var isVisible: bool = true

func _ready() -> void:
	if isVisible:
		_change_images(selectedImages, selectedImagesSizes, selectedImagesNames)
		_change_images(images, imagesSizes, imagesNames)

	self.pressed.connect(_on_button_pressed)

func unselected() -> void:
	isSelected = false
	_change_images(images, imagesSizes, imagesNames)

func _on_button_pressed() -> void:

	isSelected = !isSelected

	await _animation_button_clicked()
	
	if isSelected:
		_change_images(selectedImages, selectedImagesSizes, selectedImagesNames)
	else:
		_change_images(images, imagesSizes, imagesNames)


func _change_images(newImages: Array[Resource], newImagesSizes: Array[Vector2], newImagesNames: Array[String] = []) -> void:
	# Remove all the images
	for child in container.get_children():
		container.remove_child(child)
	
	_setup_container(newImages, newImagesSizes, newImagesNames)

func _shader_effect(imagesToUse: Array[Resource], imagesNamesToUse: Array[String], effectValue: float) -> void:
	for image in imagesToUse:
		var textureRect = container.find_child(imagesNamesToUse[imagesToUse.find(image)], false, false)
		if textureRect:
			textureRect.material.set_shader_parameter("effect", effectValue)

func _setup_container(imagesToUse: Array[Resource], imagesSizesToUse: Array[Vector2], imagesNamesToUse: Array[String] = []) -> void:
	if shader:
		var shaderMaterial = ShaderMaterial.new()
		shaderMaterial.shader = shader
		shaderMaterial.set_shader_parameter("color", colorHue)
		shaderMaterial.set_shader_parameter("range", 0.1)
		for image in imagesToUse:
			# Instantiate the image
			var textureRect = TextureRect.new()
			textureRect.texture = image
			textureRect.material = shaderMaterial

			textureRect.custom_minimum_size = imagesSizesToUse[imagesToUse.find(image)]

			textureRect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
			textureRect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			textureRect.size_flags_vertical = Control.SIZE_EXPAND_FILL

			# Set node data
			textureRect.name = image.get_path()
			textureRect.name = textureRect.name.replace("_", "")

			if imagesNamesToUse.find(textureRect.name) == -1:
				imagesNamesToUse.append(textureRect.name)

			# Add the image to the container
			container.add_child(textureRect)
	
	# Force the container to update its layout
	container.add_theme_constant_override("separation", 0)
	container.queue_sort()


func _animation_button_clicked() -> void:
	if isSelected:
		_shader_effect(images, imagesNames, 1)
		await get_tree().create_timer(buttonAnimationDuration).timeout
		_shader_effect(images, imagesNames, 0)
	else:
		_shader_effect(selectedImages, selectedImagesNames, 1)
		await get_tree().create_timer(buttonAnimationDuration).timeout
		_shader_effect(selectedImages, selectedImagesNames, 0)
