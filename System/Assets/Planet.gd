extends Node2D

var planet_name = ''
var planet_gov = 4
var planet_type = 'uninhabited'
var planet_coord = Vector2()
var planet_desc = ''
var planet_id = 0
var planet_satellites = []

var command = Master.systemC
var ui = Master.systemUI

var lock = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass


func pack():
    var data = {
        'coordinates':planet_coord,
        'name':planet_name,
        'id':planet_id,
        'type':planet_type,
        'description':planet_desc,
        'government':planet_gov,
        'satellites':planet_satellites
       }
    return data

func save():
    pass



#'coordinates':Vector2(53,109),
#'name':'Sol',
#'id':0,
#'government':1,
#'type':'Inhabited',
#'description':'The home system of humanity.',
#'connections':[],
#'planets': {

func active(is_active):
    if lock == false:
        if is_active == true:
            $SelectorIcon.show()
        elif is_active == false:
            $SelectorIcon.hide()

func _on_Area2D_mouse_entered() -> void:
    active(true)
    command.mouse_over = self


func _on_Area2D_mouse_exited() -> void:
    active(false)
    command.mouse_over = null


func _on_Area2D_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
    pass # Replace with function body.

func select():
    active(true)
    lock = true

func deselect():
    lock = false
    active(false)
