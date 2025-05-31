
extends Node

var world_context := "normal"  # e.g. "post-plague", "war-torn"
var factions = {
	"Merchants": ["I'm always looking for a deal.", "Gold talks, friend."],
	"Knights": ["For the realm!", "Honor above all."],
	"Scholars": ["Knowledge is the true power.", "Did you know...?"],
	"Cultists": ["The stars whisper secrets.", "Soon, the veil shall lift."],
}

var tone_modifiers = {
	"normal": [],
	"post-plague": ["We've seen too much death lately...", "Hard times breed harder folks."],
	"war-torn": ["The land bleeds red.", "We stand on broken ground."],
}

func generate_dialogue(npc_faction: String, npc_role: String, context: String) -> Dictionary:
	var greeting = []
	var farewell = []
	var idle = []

	world_context = context

	match npc_role:
		"shopkeeper":
			greeting = ["Welcome, traveler!", "Looking to trade?", "Step inside, finest goods around."]
			farewell = ["Come again!", "Safe travels!", "May fortune favor you."]
			idle = ["Browsing?", "No rush.", "Need anything specific?"]
		"guard":
			greeting = ["Halt! Who goes there?", "State your business."]
			farewell = ["Move along.", "Stay out of trouble."]
			idle = ["Quiet night so far.", "Watch your step."]
		"villager":
			greeting = ["Hello there.", "Lovely weather, isn’t it?", "Oh! A new face."]
			farewell = ["Goodbye now.", "Take care."]
			idle = ["The well’s acting strange again.", "Did you hear about the crops?"]
		_:
			greeting = ["Greetings.", "Hmm?", "Yes?"]
			farewell = ["Farewell.", "Good day."]
			idle = ["..."]

	if factions.has(npc_faction):
		greeting.append_array(factions[npc_faction])
		idle.append_array(factions[npc_faction])

	if tone_modifiers.has(world_context):
		greeting.append_array(tone_modifiers[world_context])
		idle.append_array(tone_modifiers[world_context])

	return {
		"greeting": greeting[randi() % greeting.size()],
		"farewell": farewell[randi() % farewell.size()],
		"idle": idle[randi() % idle.size()],
	}
