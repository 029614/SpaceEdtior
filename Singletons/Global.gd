extends Node


var Master


# ------ Main Data Depot ------ #
var data = {
    'resources': {
        'government':{
            0:{
                'name':'Federation',
                'description':'',
                'id':0,
                'color':Color8(29,42,245,255)
               },
            1:{
                'name':'Alliance',
                'description':'',
                'id':1,
                'color':Color8(29,245,47,255)
               },
            2:{
                'name':'Rebellion',
                'description':'',
                'id':2,
                'color':Color8(245,206,29,255)
               },
            3:{
                'name':'Pirates',
                'description':'',
                'id':3,
                'color':Color8(198,0,0,255)
               },
            4:{
                'name':'Independant',
                'description':'',
                'id':4,
                'color':Color8(182,254,252,255)
               },
           },
        'commodity':{
            0:{
                'name':'Iron',
                'description':''
               },
            1:{
                'name':'Steel',
                'description':''
               },
            2:{
                'name':'Titanium',
                'description':''
               },
            3:{
                'name':'Gold',
                'description':''
               },
            4:{
                'name':'Silver',
                'description':''
               },
            5:{
                'name':'Copper',
                'description':''
               },
            6:{
                'name':'Carbon',
                'description':''
               },
           },
       },
    'systems':{
        0:{
            'coordinates':Vector2(53,109),
            'name':'Sol',
            'id':0,
            'government':1,
            'type':'Inhabited',
            'description':'The home system of humanity.',
            'connections':[],
            'planets': {
                0:{
                    'coordinates':Vector2(0,0),
                    'name':'Earth',
                    'id':0,
                    'type':'inhabited',
                    'description':'The seat of humanity!',
                    'government':'Federation',
                    'satellites':{
                        0:{
                            'coordinates':Vector2(10,0),
                            'name':'Moon',
                            'description':'',
                            'id':0,
                            'type':'inhabited',
                            'government':'Federation',
                           },
                        1:{
                            'coordinates':Vector2(7,3),
                            'name':'Nobel Station',
                            'description':'',
                            'id':1,
                            'type':'inhabited',
                            'government':'Federation',
                           },
                       }
                   },
               }
           },
       },
    
   }


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#    pass


func pack(module, package): 
    data[module] = package

func unPack():
    pass

func exportData():
    var jstr = JSON.print(data)
    var file = File.new()
    file.open(str(Master.file_address) + '.json', file.WRITE)
    file.store_string(jstr)
    file.close()

func importData():
    var file = File.new()
    file.open(str(Master.file_address), file.READ)
    var text = file.get_as_text()
    var parse = JSON.parse(text)
    data = parse.result
    file.close()
    
    Master.file_loaded = true
    Master.displayLoaded(Master.file_address)

