use godot::{prelude::*};


struct IBProject;


mod test;
mod endeka;
mod anima;
mod dice;
mod tag;


#[gdextension(entry_symbol=ibproject)]
unsafe impl ExtensionLibrary for IBProject
{
    fn on_main_loop_frame()
    {
        anima::Anima::singleton().bind_mut()._tick();
    }
}

