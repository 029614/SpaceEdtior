extends Node


var editor_mode = 'menu' # menu, resource, map, system


var target = null
var target_offset = Vector2(0,0)
var mouse_relative

var state = 'idle' # idle, dragging

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    Signals.connect("drag", self, 'dragMe')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if target != null:
        if target.has_meta('system'):
            target.position += mouse_relative
            target.coordinates = target.position
            Master.mapC.drawPaths()
        else:
            target.global_position += mouse_relative
        mouse_relative = Vector2(0,0)

func _input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        mouse_relative = Vector2(event.relative.x, event.relative.y)


func dragMe(obj, value):
    if value == true:
        target = obj
        state = 'dragging'
    elif value == false:
        target = null
        state = 'idle'
