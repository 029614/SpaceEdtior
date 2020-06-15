extends Node2D

var data = {}
var target = 'systems'

var selected = null
var over = null



func _ready() -> void:
    get_parent().get_parent().systemC = self



# ------ Universal Functions ------ #
func setActive(is_active): # --- Sets whether this branch is active in the editor --- #
    if is_active == true:
        data = Global.Master.mapC.getSystemData(Global.Master.mapC.selected_system.system_id)
    if is_active == false:
        pass

func refresh(): # --- Refreshes the UI --- #
    pass


# ------ Branch Specific Functions ------ #
func drag(object, mouse_pos): # --- Drag an object with the mouse - Called once per frame --- #
    pass

func select(object_id): # --- Select an object --- #
    pass

func deSelect(object_id): # --- Deselect an object --- #
    pass

func editProperties(object_id): # --- Open the properties editor --- #
    pass

func saveData(key,value):
    data[key] = value
