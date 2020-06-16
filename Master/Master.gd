extends Control


# ------ Reference Data ------
# suffix 'C' implies a command layer element
# suffix 'UI' implies a ui layer element
var resourceC
var resourceUI

var mapC
var mapUI

var systemC
var systemUI

var file_address
var file_name

var file_loaded = false
var loaded = ''

var selected_system

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    Global.Master = self
    Signals.connect("merge_data", self, 'mergeData')


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass

func packData(target,update):
    Global.data[target] = update

func unPackData(target):
    return Global.data[target]

func exportData(): # all, resource, map, system
    Global.exportData()

func importData(data): # all, resource, map, system
    if data == 'all':
        pass
    if data == 'resource':
        pass
    if data == 'map':
        pass
    if data == 'system':
        pass

func refresh(branch): # all, resource, map, system
    if branch == 'all':
        resourceC.refresh()
        mapC.refresh()
        systemC.refresh()
    if branch == 'resource':
        resourceC.refresh()
    if branch == 'map':
        mapC.refresh()
    if branch == 'system':
        systemC.refresh()

func mergeData():
    refresh('all')

func displayLoaded(message):
    $Panel/Label.set_text(message)


func _on_Resource_pressed() -> void:
    get_tree().change_scene("res://Resource/Resource.tscn")
    ProCom.editor_mode = 'resource'


func _on_Map_pressed() -> void:
    get_tree().change_scene("res://Map/Map.tscn")
    ProCom.editor_mode = 'map'


func _on_Export_confirmed() -> void:
    file_name = $Export.get_line_edit().get_text()
    file_address = $Export.get_current_path()
    Global.exportData()


func _on_Export_pressed() -> void:
    $Export.popup_centered()


func _on_Import_confirmed() -> void:
    file_name = $Import.get_line_edit().get_text()
    file_address = $Import.get_current_path()
    Global.importData()


func _on_Import_pressed() -> void:
    $Import.popup_centered()
