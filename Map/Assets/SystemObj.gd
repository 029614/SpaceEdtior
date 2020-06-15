extends Node2D


# ------ Data Variables ------ #
var sys_name = 'New System'
var sys_id = 4
var sys_description = ''
var coordinates = Vector2()
var sys_connections = []
var sys_government = 0
var sys_type = 'uninhabited'
var sys_planets = {}



var sys_color = Color8(255,255,255,255)

var is_selected = false
var is_hover = false
var is_dragging = false

var hover_color = Color8(255,255,255,125)
var select_color = Color8(0,255,243,125)
var secondary_select_color = Color8(253,82,37,125)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    self.set_meta('system', true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass
func select():
    is_selected = true
    highlight(true, 'selected')

func deselect():
    is_selected = false
    highlight(false)
    
func secondarySelect():
    is_selected = true
    highlight(true, 'secondary')
    


func highlight(is_on, mode='off'):
    if is_on == true:
        if mode == 'hover':
            $Indicator.show()
            $Indicator.set_modulate(hover_color)
        elif mode == 'selected':
            $Indicator.show()
            $Indicator.set_modulate(select_color)
        elif mode == 'secondary':
            $Indicator.show()
            $Indicator.set_modulate(secondary_select_color)
    elif is_on == false:
        $Indicator.hide()

func setColor():
    sys_color = Global.data['resources']['government'][sys_government]['color']
    $SystemIcon.set_modulate(sys_color)


func _on_Area2D_mouse_entered() -> void:
    Master.mapC.mouse_over = self
    if is_selected == false:
        highlight(true, 'hover')


func _on_Area2D_mouse_exited() -> void:
    Master.mapC.mouse_over = null
    if is_selected == false:
        highlight(false)


func _on_Area2D_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
    if event is InputEventMouseButton and Input.is_action_just_released('left_mouse') and is_selected != true:
        Master.mapC.select()
    if event is InputEventMouseButton and Input.is_action_pressed('left_mouse') and is_selected == true:
        ProCom.dragMe(self, true)
        is_dragging = true
    if event is InputEventMouseButton and Input.is_action_just_released('left_mouse') and is_dragging == true:
        ProCom.dragMe(self, false)
        is_dragging = false
    if event is InputEventMouseButton and Input.is_action_just_pressed('right_mouse'):
        Master.mapC.secondarySelect()
    
