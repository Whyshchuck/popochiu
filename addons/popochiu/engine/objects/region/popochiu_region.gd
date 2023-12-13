@tool
@icon('res://addons/popochiu/icons/region.png')
class_name PopochiuRegion
extends Area2D
# Can trigger events when the player walks checked them. Can tint the PC.
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

@export var script_name := ''
@export var description := ''
@export var enabled := true : set = _set_enabled
# TODO: If walkable is false, characters should not be able to walk through this.
#export var walkable := true
@export var tint := Color.WHITE
@export var scaling :bool = false
@export var scale_top :float = 1.0
@export var scale_bottom :float = 1.0


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ GODOT ░░░░
func _ready() -> void:
	add_to_group('regions')
	
	area_entered.connect(_check_area.bind(true))
	area_exited.connect(_check_area.bind(false))


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ VIRTUAL ░░░░
func _on_character_entered(chr: PopochiuCharacter) -> void:
	pass


func _on_character_exited(chr: PopochiuCharacter) -> void:
	pass

func _update_scaling_region(chr: PopochiuCharacter) -> void:
	var polygon_y_array = []
	for x in get_node("InteractionPolygon").get_polygon():
		polygon_y_array.append(x.y)

	chr.on_scaling_region= {
		'region_description': self.description,
		'scale_top': self.scale_top, 
		'scale_bottom': self.scale_bottom,  
		'polygon_top_y': polygon_y_array.min()+self.position.y+get_node("InteractionPolygon").position.y if self.position else '',
		'polygon_bottom_y': polygon_y_array.max()+self.position.y+get_node("InteractionPolygon").position.y if self.position else '',

		}


func _clear_scaling_region(chr: PopochiuCharacter) -> void:
	if chr.on_scaling_region and chr.on_scaling_region['region_description'] == self.description:
		chr.on_scaling_region = {}

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PRIVATE ░░░░
func _check_area(area: PopochiuCharacter, entered: bool) -> void:
	if area is PopochiuCharacter:
		if entered:
			_on_character_entered(area)
			if scaling:
				_update_scaling_region(area)
		else:
			_on_character_exited(area)
			_clear_scaling_region(area)


func _set_enabled(value: bool) -> void:
	enabled = value
	monitoring = value
	
	notify_property_list_changed()