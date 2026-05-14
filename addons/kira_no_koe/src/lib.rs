use godot::prelude::*;
use godot::classes::{
    Engine, IResourceFormatLoader, IResourceFormatSaver, ResourceFormatLoader,
    ResourceFormatSaver, ResourceLoader, ResourceSaver,
};
struct KiraNoKoe;

mod player;


#[derive(GodotClass)]
#[class(tool, singleton, base=Object)]
struct KiraStaticSoundAsset
{
    saver: Gd<KiraStaticSoundDataSaver>,
    loader: Gd<KiraStaticSoundDataLoader>,
    base: Base<Object>,
}

#[derive(GodotClass)]
#[class(tool, base=Object)]
struct KiraStaticSoundDataLoader{}

#[derive(GodotClass)]
#[class(tool, base=Object)]
struct KiraStaticSoundDataSaver{}


#[godot_api]
impl IObject for KiraStaticSoundDataLoader
{
    fn init(base: Base<Object>) -> Self
    {
        Self {}
    }
}



#[gdextension(entry_symbol=kira_no_koe)]
unsafe impl ExtensionLibrary for KiraNoKoe {
    fn on_stage_init(stage: InitStage) {
        if stage == InitStage::MainLoop {
            // Startup code after fully initialized.
        }
        else if stage == InitStage::Scene
        {
            
        }
    }

    fn on_main_loop_frame() {
        // Per-frame logic.
    }

    fn on_stage_deinit(stage: InitStage) {
        if stage == InitStage::MainLoop {
            // Cleanup code before shutdown.
        }
    }
}