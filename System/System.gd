extends Node2D

var data = {}
var target = 'systems'
onready var body_parent = $SystemContainer/Bodies
onready var drag_target = $SystemContainer
var origin = Vector2()

var selected = null
var mouse_over = null

var planet = preload("res://System/Assets/Planet.tscn")



func _ready() -> void:
    Master.systemC = self
    origin = Vector2(get_viewport_rect().size.x - $GUI/SystemGui.get_size().x,0)/2
    drag_target.global_position = origin
    body_parent.position = Vector2(0,0)


func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and Input.is_action_just_pressed("left_mouse") and mouse_over == null:
        Signals.emit_signal('drag', drag_target, true)
    elif event is InputEventMouseButton and Input.is_action_just_released("left_mouse") and mouse_over == null:
        Signals.emit_signal('drag', drag_target, false)
    elif event is InputEventMouseButton and Input.is_action_just_pressed("left_mouse") and selected != mouse_over and mouse_over != null:
        if selected != null:
            deSelect(selected)
        select(mouse_over)
    elif event is InputEventMouseButton and Input.is_action_just_pressed("right_mouse") and mouse_over == selected:
        deSelect(selected)
    elif event is InputEventMouseButton and Input.is_action_just_pressed("left_mouse") and mouse_over == selected:
        ProCom.dragMe(selected,true)
    elif event is InputEventMouseButton and Input.is_action_just_released("left_mouse") and ProCom.state == 'dragging':
        ProCom.dragMe(selected,false)


# ------ Universal Functions ------ #
func setActive(is_active): # --- Sets whether this branch is active in the editor --- #
    if is_active == true:
        data = Global.Master.mapC.getSystemData(Global.Master.mapC.selected_system.system_id)
    if is_active == false:
        pass

func refresh(): # --- Refreshes the UI --- #
    pass


# ------ Branch Specific Functions ------ #
func pack():
    pass

func drag(object, mouse_pos): # --- Drag an object with the mouse - Called once per frame --- #
    pass

func select(object_id): # --- Select an object --- #
    selected = mouse_over
    selected.select()

func deSelect(object_id): # --- Deselect an object --- #
    selected.deselect()
    selected = null

func editProperties(object_id): # --- Open the properties editor --- #
    pass

func saveData(key,value):
    data[key] = value

func createBody(type):
    if type == 'planet':
        print('creating planet!')
        var p = planet.instance()
        body_parent.add_child(p)
        p.global_position = origin
        print('planet created!')
    elif type == 'station':
        print('Type Not Yet Implemented!')
    elif type == 'asteroid':
        print('Type Not Yet Implemented!')
        
