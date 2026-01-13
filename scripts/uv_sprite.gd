extends Sprite2D

@onready var uv_sprite: Sprite2D = $"../Uv"
@onready var uv: Sprite2D = $"../Lamp/Uv"
func _ready():
	if self.material:
		self.material = self.material.duplicate()
	if uv_sprite == null:
		uv_sprite = uv

func _process(delta):
	var mat = self.material
	if mat and mat is ShaderMaterial:
		var uv_global_pos = uv_sprite.global_position
		var uv_visibility = uv_sprite.visible
		var uv_texture_size = uv_sprite.texture.get_size()
		var global_scale = uv_sprite.get_global_transform().get_scale()
		var uv_size = uv_texture_size * global_scale
		
		mat.set_shader_parameter("uv_light_global_pos", uv_global_pos)
		mat.set_shader_parameter("uv_light_size", uv_size)
		mat.set_shader_parameter("uv_mask", uv_sprite.texture)
		mat.set_shader_parameter("uv_visible", uv_visibility)
