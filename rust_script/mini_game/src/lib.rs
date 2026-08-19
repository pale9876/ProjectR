use godot::prelude::*;


mod minigame_unit;


struct Minigame;

#[gdextension(entry_symbol = minigame)]
unsafe impl ExtensionLibrary for Minigame
{

}