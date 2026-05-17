use godot::prelude::*;
use godot::classes::{
    Engine, IResourceFormatLoader, IResourceFormatSaver, ResourceFormatLoader,
    ResourceFormatSaver, ResourceLoader, ResourceSaver
};
use kira::sound::static_sound::StaticSoundData;

struct KiraNoKoe;

mod player;

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

    fn on_stage_deinit(stage: InitStage) {
        if stage == InitStage::MainLoop {
            // Cleanup code before shutdown.
        }
    }
}