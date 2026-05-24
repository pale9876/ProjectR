use godot::prelude::*;


struct GodotCime;


mod godot_cime;


#[gdextension]
unsafe impl ExtensionLibrary for GodotCime
{
    
}