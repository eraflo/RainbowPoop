# Main Classes

## Collectable

This class represents collectible items in the game.

Collectibles can be picked up by the player to manage health, but there is also bad one that give him bad effects.

### Need to implement in children

```gdscript
func _on_body_entered(_body: Node) -> void
```

## Player

This class represents the player character in the game. The Player node handles player movement, health management, and interactions with other game elements. It is responsible for responding to user inputs and updating the game state accordingly.

### Key Features (Already Added)

- Gravity
- Interact with Escherichia Coli
