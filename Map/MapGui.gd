extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    Master.mapUI = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass


func _on_Back_pressed() -> void:
    Master.mapC.pack()
    
    get_tree().change_scene("res://Master/Master.tscn")


func _on_AddSys_pressed() -> void:
    Master.mapC.addSystem()
    ProCom.editor_mode = 'menu'


func _on_ZoomIn_pressed() -> void:
    Master.mapC.zoomIn()


func _on_ZoomOut_pressed() -> void:
    Master.mapC.zoomOut()


func _on_DelSys_pressed() -> void:
    Master.mapC.deleteSystem()


func _on_Edit_pressed() -> void:
    Master.mapC.edit(Master.mapC.selected_system)
