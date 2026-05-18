use std::collections::HashMap;
use std::fs::{DirEntry, ReadDir};

use godot::prelude::*;
use godot::classes::{
    Engine, IResourceFormatLoader, IResourceFormatSaver, ProjectSettings, ResourceFormatLoader, ResourceFormatSaver, ResourceLoader, ResourceSaver, WorkerThreadPool
};
use kira::sound::static_sound::StaticSoundData;

use crate::player::kira_audio_server::KiraAudioServer;
use crate::player::kira_db::KiraDB;

struct KiraNoKoe;

mod player;



fn search_files(pathes: &mut Vec<DirEntry>, directory: ReadDir)
{
    for dir in directory
    {
        if let Ok(entry) = dir
        {
            if entry.path().is_dir()
            {
                
            }
            else if entry.path().is_file()
            {
                let filename = String::from(entry.file_name().to_str().unwrap());
                pathes.push(entry);
            }
        }
    }
}


fn load_file(db: &mut HashMap<String, StaticSoundData>, entry: &DirEntry)
{
    
}


#[gdextension(entry_symbol=kira_no_koe)]
unsafe impl ExtensionLibrary for KiraNoKoe {
    fn on_stage_init(stage: InitStage) {
        if stage == InitStage::MainLoop
        {
            
        }
        else if stage == InitStage::Scene
        {
            let mut server = player::kira_audio_server::KiraAudioServer::singleton();
            let mut db = &server.bind_mut().db;
            let mut wtp = WorkerThreadPool::singleton();

            let mut pathes = Vec::<DirEntry>::new();

            let default_folder_path = ProjectSettings::singleton().globalize_path(KiraDB::DEFAULT_PATH);
            let read_directory = std::fs::read_dir(default_folder_path.to_string()).expect("Failed");

            search_files(&mut pathes, read_directory);

            wtp.add_group_task_ex(
                &Callable::from_custom(load_file.into()),
                pathes.len() as i32
            ).high_priority(true).done();
        }
    }

    fn on_stage_deinit(stage: InitStage) {
        if stage == InitStage::MainLoop
        {

        }
    }
}