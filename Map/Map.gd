extends Node2D

# ------ Data ------ #
var data = {}
var target = 'systems'
var systems_reference_array = []

# ------ Editor Specific Variables ------ #
var selected_system = null
var secondary_selected = null
var mouse_over = null
onready var dragThis = $MapContainer
var zoom = Vector2(1,1)
onready var system_parent = $MapContainer/Nodes

# ------ Assets ------ #
var system = preload("res://Map/Assets/System.tscn")
var path = preload("res://Map/Assets/Path.tscn")



func _ready() -> void:
    dragThis.global_position = Vector2(get_viewport_rect().size.x-Master.mapUI.rect_size.x,get_viewport_rect().size.y)/2
    Master.mapC = self
    data = Master.unPackData(target)
    refresh()

func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and Input.is_action_just_pressed("left_mouse") and mouse_over == null:
        Signals.emit_signal('drag', dragThis, true)
    if event is InputEventMouseButton and Input.is_action_just_released("left_mouse") and mouse_over == null:
        Signals.emit_signal('drag', dragThis, false)
    
    if event is InputEventMouseButton and mouse_over != null and event.doubleclick:
        edit(mouse_over)



# ------ Universal Functions ------ #
func pack(): # --- Submits all relevant branch data to Global for export --- #
    Global.pack(target, data)

func setActive(is_active): # --- Sets whether this branch is active in the editor --- #
    pass

func refresh(): # --- Refreshes the UI --- #
    if selected_system != null:
        deSelect()
    if secondary_selected != null:
        secondaryDeselect()
    
    var count = 0
    while count < system_parent.get_child_count():
        var sys = system_parent.get_child(count)
        #systemDisconnect(sys)
        sys.queue_free()
        count += 1
    systems_reference_array.clear()
        
    if data.keys().size() > 0:
        for node in data.keys():
            var new_system = system.instance()
            new_system.coordinates = data[node]['coordinates']
            new_system.sys_id = data[node]['id']
            new_system.sys_name = data[node]['name']
            new_system.sys_description = data[node]['description']
            new_system.sys_government = data[node]['government']
            new_system.sys_type = data[node]['type']
            new_system.sys_connections = data[node]['connections']
            new_system.sys_planets = data[node]['planets']
            new_system.setColor()
            systems_reference_array.append(new_system)
            system_parent.add_child(new_system)
            new_system.position = new_system.coordinates
            new_system.set_meta('system',true)
            print(new_system.sys_id, " connections: ", new_system.sys_connections)
        drawPaths()
    else:
        print('No Systems found')


# ------ Branch Specific Functions ------ #

func select(): # --- Select an object --- #
    if secondary_selected != null and mouse_over != secondary_selected:
        systemDisconnect(mouse_over, secondary_selected)
        drawPaths()
    elif secondary_selected != null and mouse_over == secondary_selected:
        secondaryDeselect()
        select()
    else:
        if selected_system != null:
            deSelect()
        selected_system = mouse_over
        selected_system.select()

func secondarySelect():
    if mouse_over == selected_system:
        deSelect()
    elif mouse_over != selected_system:
        if selected_system != null:
            systemConnect(mouse_over, selected_system)
            drawPaths()
        elif secondary_selected != null and mouse_over == secondary_selected:
            secondaryDeselect()
        else:
            if secondary_selected != null:
                secondaryDeselect()
            secondary_selected = mouse_over
            secondary_selected.secondarySelect()

func deSelect(): # --- Deselect an object --- #
    selected_system.deselect()
    selected_system = null

func secondaryDeselect():
    secondary_selected.deselect()
    secondary_selected = null

func systemConnect(sys_a, sys_b):
    if sys_a.sys_connections.has(sys_b.sys_id) and sys_b.sys_connections.has(sys_a.sys_id):
        print("Path already exists!")
    else:
        sys_a.sys_connections.append(sys_b.sys_id)
        sys_b.sys_connections.append(sys_a.sys_id)
        saveState()

func systemDisconnect(sys_a,sys_b=null):
    if sys_b != null:
        if sys_a.sys_connections.has(sys_b.sys_id) and sys_b.sys_connections.has(sys_a.sys_id):
            sys_a.sys_connections.erase(sys_b.sys_id)
            sys_b.sys_connections.erase(sys_a.sys_id)
        else:
            print('No path exists')
    elif sys_b == null:
        for connect in sys_a.sys_connections:
            for reference in systems_reference_array:
                if connect == reference.sys_id:
                    connect = reference
                    break
            connect.sys_connections.erase(sys_a.sys_id)
        sys_a.sys_connections.clear()
    saveState()

func drawPaths(id='all'):
    if id=='all':
        if $MapContainer/Connections.get_child_count() > 0:
            for i in range(0, $MapContainer/Connections.get_child_count()):
                $MapContainer/Connections.get_child(i).queue_free()
                
        for system in $MapContainer/Nodes.get_children():
            for connection in system.sys_connections:
                for reference in systems_reference_array:
                    if reference.sys_id == connection:
                        connection = reference
                        break
                var new_path = path.instance()
                var path_icon = new_path.get_node('NinePatchRect')
                $MapContainer/Connections.add_child(new_path)
                new_path.global_position = system.global_position
                path_icon.set_modulate(system.sys_color)
                new_path.look_at(connection.global_position)
                path_icon.set_size(Vector2(system.global_position.distance_to(connection.global_position),path_icon.get_size().y)*.75)
        

func edit(object): # --- Open the properties editor --- #
    pass

func saveState(): # --- Store current changes in memory --- #
    data.clear()
    for node in systems_reference_array:
        data[node.sys_id] = {
            'coordinates':node.coordinates,
            'name':node.sys_name,
            'id':node.sys_id,
            'government':node.sys_government,
            'type':node.sys_type,
            'description':node.sys_description,
            'connections':node.sys_connections,
            'planets':node.sys_planets
           }

func addSystem():
    var new_system = system.instance()
    systems_reference_array.append(new_system)
    $MapContainer/Nodes.add_child(new_system)
    new_system.setColor()
    new_system.sys_id = assignID()
    new_system.set_meta('system',true)
    #new_system.global_position = Vector2(500,250)
    saveState()
    refresh()

func deleteSystem():
    systemDisconnect(selected_system)
    data.erase(selected_system.sys_id)
    selected_system.queue_free()
    refresh()

func assignID():
    var count = 0
    var id = null
    while id == null:
        if data.has(count):
            count += 1
        else:
            id = count
    return id


# ------ Getters and Setters ------ #
func getSystemData(system_id):
    return data[system_id]

func setSystemData(system_id, new_data):
    data[system_id] = new_data

func zoomIn():
    dragThis.scale += Vector2(.1,.1)

func zoomOut():
    dragThis.scale -= Vector2(.1,.1)
