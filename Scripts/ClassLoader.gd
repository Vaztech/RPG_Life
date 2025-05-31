class_name ClassLoader
extends Node

var loaded_classes: Dictionary = {}

func _ready():
    load_classes()

func load_classes() -> void:
    var db = get_node("/root/Main/DatabaseManager")
    if not db:
        push_error("DatabaseManager not found")
        return
    var query = """
        SELECT 
            Barbarian_description AS barb_desc, Barbarian_hit_die AS barb_hit_die, Barbarian_features AS barb_features,
            Wizard_description AS wiz_desc, Wizard_hit_die AS wiz_hit_die, Wizard_features AS wiz_features,
            Wizard_subclasses_Abjurer_description AS abj_desc, Wizard_subclasses_Abjurer_features AS abj_features
        FROM classes
    """
    var result = db.query(query)
    if result and result.size() > 0:
        var row = result[0]
        loaded_classes["Barbarian"] = {
            "description": row["barb_desc"],
            "hit_die": row["barb_hit_die"],
            "features": JSON.parse_string(row["barb_features"]) if row["barb_features"] else []
        }
        loaded_classes["Wizard"] = {
            "description": row["wiz_desc"],
            "hit_die": row["wiz_hit_die"],
            "features": JSON.parse_string(row["wiz_features"]) if row["wiz_features"] else [],
            "subclasses": {
                "Abjurer": {
                    "description": row["abj_desc"],
                    "features": JSON.parse_string(row["abj_features"]) if row["abj_features"] else []
                }
            }
        }
        print("Loaded %d classes" % loaded_classes.size())
    else:
        push_error("Failed to load classes from database")