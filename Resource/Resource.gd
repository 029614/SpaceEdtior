extends Control

var data = {}
var target = 'resources'

var selected_item_type = null # null, government, commodity
var selected_item_id = 0
var selected_item_data = {}


# ------ Entry References ------ #
onready var gov_list = $Panel/LeftPanel/GovernmentList
onready var gov_name = $Panel/RightPanel/Government/Info/GovName
onready var gov_color = $Panel/RightPanel/Government/Info/GovColor
onready var gov_desc = $Panel/RightPanel/Government/Info/GovDesc

onready var com_list = $Panel/LeftPanel/CommodityList
onready var com_name = $Panel/RightPanel/Commodities/Info/ComName
onready var com_desc = $Panel/RightPanel/Commodities/Info/ComDesc

onready var government_edit = $Panel/RightPanel/Government
onready var commodity_edit = $Panel/RightPanel/Commodities




func _ready() -> void:
    Master.resourceC = self
    data = Master.unPackData(target)
    refresh()



# ------ Universal Functions ------ #
func setActive(is_active): # --- Sets whether this branch is active in the editor --- #
    pass

func refresh(): # --- Refreshes the UI --- #
    gov_list.clear()
    com_list.clear()
    gov_list.add_item('+ New Government')
    com_list.add_item('+ New Commodity')
    for id in data['government'].keys():
        gov_list.add_item(data['government'][id].name)
    for id in data['commodity'].keys():
        com_list.add_item(data['commodity'][id].name)

func refreshInfo(): # --- Refreshes the selected entry --- #
    if selected_item_type == 'government':
        gov_name.set_text(selected_item_data['name'])
        gov_color.color = selected_item_data['color']
        gov_desc.set_text(selected_item_data['description'])
    elif selected_item_type == 'commodity':
        com_name.set_text(selected_item_data['name'])
        com_desc.set_text(selected_item_data['description'])
    elif selected_item_type == null:
        print('No Item Selected')

func reID(target):
    var new_id = {}
    var count = 0
    for gov in data[target].keys():
        new_id[count] = data[target][gov]
        count += 1
    data[target] = new_id
    
# ------ Branch Specific Functions ------ #

func select(): # --- Select an object --- #
    selected_item_data = data[selected_item_type][selected_item_id]
    refreshInfo()

func save():
    if selected_item_type == 'government':
        data[selected_item_type][selected_item_id]['name'] = gov_name.get_text()
        data[selected_item_type][selected_item_id]['description'] = gov_desc.get_text()
        data[selected_item_type][selected_item_id]['color'] = gov_color.color
    elif selected_item_type == 'commodity':
        data[selected_item_type][selected_item_id]['name'] = com_name.get_text()
        data[selected_item_type][selected_item_id]['description'] = com_desc.get_text()
    elif selected_item_type == null:
        print('No Item Selected')
    Master.packData(target, data)
    data = Master.unPackData(target)
    refresh()

func delete():
    data[selected_item_type].erase(selected_item_id)
    reID(selected_item_type)
    selected_item_data = null
    selected_item_id = null
    selected_item_type = null
    refresh()

func createGovernment():
    var new_id = gov_list.get_item_count()-1
    data['government'][new_id] = {
        'name':'New Government',
        'description':'',
        'color':Color8(255,255,255,255)
       }
    refresh()
    
func createCommodity():
    var new_id = com_list.get_item_count()-1
    data['commodity'][new_id] = {
        'name':'New Commodity',
        'description':'',
       }
    refresh()



func _on_GovSubmit_pressed() -> void:
    save()
    refreshInfo()


func _on_GovCancel_pressed() -> void:
    refreshInfo()
    government_edit.hide()


func _on_GovDelete_pressed() -> void:
    delete()
    government_edit.hide()


func _on_CommodityList_item_selected(index: int) -> void:
    if index == 0:
        createCommodity()
    else:
        selected_item_id = index-1
        selected_item_type = 'commodity'
        select()
        commodity_edit.show()


func _on_GovernmentList_item_selected(index: int) -> void:
    if index == 0:
        createGovernment()
    else:
        selected_item_id = index-1
        selected_item_type = 'government'
        select()
        government_edit.show()


func _on_Back_pressed() -> void:
    get_tree().change_scene("res://Master/Master.tscn")
    ProCom.editor_mode = 'menu'


func _on_Governments_toggled(button_pressed: bool) -> void:
    if button_pressed == true:
        gov_list.show()
        com_list.hide()
        government_edit.show()
        commodity_edit.hide()
        $Panel/LeftPanel/ListSelectors/Commodities.set_pressed(false)


func _on_Commodities_toggled(button_pressed: bool) -> void:
    if button_pressed == true:
        gov_list.hide()
        com_list.show()
        government_edit.hide()
        commodity_edit.show()
        $Panel/LeftPanel/ListSelectors/Governments.set_pressed(false)


func _on_ComDelete_pressed() -> void:
    delete()
    commodity_edit.hide()


func _on_ComCancel_pressed() -> void:
    refreshInfo()
    commodity_edit.hide()


func _on_ComSubmit_pressed() -> void:
    save()
    refreshInfo()
