class_name ItemData
extends Resource

enum Type {
	Block,
	Tool,
}

enum MiningTool {
	Pickaxe,
	Axe,
	Hammer,
}

enum ToolType {
	Pickaxe,
	Axe,
	Hammer,
}

@export var type: Type
@export var texture: Texture2D
@export var max_stack: int = 1

@export_category("Block")
@export var required_tool: MiningTool
@export var minimum_mining_strength: int

@export_category("Tool")
@export var tool_type: ToolType
@export var mining_strength: int
