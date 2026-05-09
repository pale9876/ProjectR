use godot::prelude::*;


struct IBProject;


mod test;
mod endeka;


#[gdextension(entry_symbol=ibproject)]
unsafe impl ExtensionLibrary for IBProject {

}

