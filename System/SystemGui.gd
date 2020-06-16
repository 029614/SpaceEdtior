extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    Master.systemUI = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass


func _on_AddBody_pressed() -> void:
    $BodyList.show()


func _on_BodyList_item_selected(index: int) -> void:
    if index == 0:
        Master.systemC.createBody('planet')
    elif index == 1:
        Master.systemC.createBody('station')
    elif index == 2:
        Master.systemC.createBody('asteroid')
    $BodyList/BodyList.unselect_all()
    $BodyList.hide()


func _on_Back_pressed() -> void:
    Master.systemC.pack()
    get_tree().change_scene("res://Map/Map.tscn")
