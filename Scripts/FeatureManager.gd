class_name FeatureManager
extends Node

func get_class_features(game: Object, character_class: String) -> Array:
    var class_data = game.classes.get(character_class, {})
    var features = []
    for f in class_data.get("features", []):
        if f.get("level", 1) == 1:
            features.append(f["name"])
    return features