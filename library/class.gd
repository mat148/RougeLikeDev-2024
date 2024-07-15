extends Resource
class_name Class

const close = 1
const far = 5

enum entity_classes {WARRIOR, RANGED}
@export var entity_class_name: entity_classes
@export var entity_class_base_health: int

enum entity_attack_styles {CLOSE, FAR}
@export var entity_class_attack_style: entity_attack_styles = return_entity_class_attack_style()

@export var entity_class_base_attack: int = 1

func return_entity_class_attack_style() -> entity_attack_styles:
	if entity_class_name == entity_classes.WARRIOR:
		return entity_attack_styles.CLOSE
	if entity_class_name == entity_classes.RANGED:
		return entity_attack_styles.FAR
	
	return entity_attack_styles.CLOSE
