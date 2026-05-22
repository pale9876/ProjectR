use godot::{classes::Engine, prelude::*};


struct IBProject;


mod test;
mod endeka;
mod anima;
mod dice;


#[gdextension(entry_symbol=ibproject)]
unsafe impl ExtensionLibrary for IBProject
{
    fn on_main_loop_frame()
    {
        // let main_loop = ;

        anima::Anima::singleton().bind_mut()._tick();
    }
}

