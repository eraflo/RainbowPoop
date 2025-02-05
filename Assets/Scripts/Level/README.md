# Level System

The game is divided in multiple level. The player needs to complete each level to unlock the next ones.

## Level Node

Node for the level. 

When you create a new level, you create a `Node2D` and you add the script `LevelNode` on it.
Then, to modify the value of the level, you need to create a `LevelData`, which you store in the `Assets/Resources/Levels` folder. You name it `NameOfLevelLevel.tres`. (See example of `TestLevel.tres`).

PS : you can directly create the `LevelData` with the editor in the inspector of `LevelNode`.

## Level Data

Contain the data of a level. Will save the score the player made on the level.

It is a Resources file (See `Assets/Ressources`).

## EndOfLevelArea

This area is the area the player needs to go in to finish the level. Place it at the end of your level.

Also, don't forget to fill the `Level Name` field in the inspector (Needs to be the same as the name of the Level)

