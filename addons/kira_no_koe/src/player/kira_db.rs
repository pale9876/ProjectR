use std::{collections::HashMap, fs::DirEntry};
use godot::{classes::ProjectSettings, prelude::*};


use kira::{
    AudioManager,
    AudioManagerSettings,
    DefaultBackend,
    Tween,
    sound::static_sound::StaticSoundData
};


#[derive(Debug, Clone)]
pub struct KiraDB
{
    pub cache: HashMap<String, StaticSoundData>,
}

const DEFAULT_PATH: &str = "res://audio/";
const exts: [&str; 3] = ["mp3","ogg","wav"];

impl KiraDB
{

    pub fn db_init() -> Self
    {
        let loaded = Self::load_files_from_folder(&String::from(DEFAULT_PATH));

        Self {
            cache : loaded
        }
    }


    pub fn find_data(&self, name: &String) -> Option<StaticSoundData>
    {
        if self.cache.contains_key(name)
        {
            return Some(self.cache[name].clone())
        }

        Option::None
    }


    pub fn add_data(&mut self, name: String, sound: StaticSoundData) -> bool
    {
        if !self.cache.contains_key(&name)
        {
            self.cache.insert(name, sound);
            return true;
        }

        false
    }


    pub fn load_files_from_folder(path: &String) -> HashMap<String, StaticSoundData>
    {
        let mut result = HashMap::<String, StaticSoundData>::new();
        let g_path = ProjectSettings::singleton().globalize_path(path);
        let paths = std::fs::read_dir(g_path.to_string()).expect("Failed");
        
        for dir in paths
        {
            let dir_path= dir.unwrap().path();
            let dir_name = dir_path.file_name().unwrap().to_str().unwrap();
            let ext = dir_path.extension().unwrap();
            if exts.contains(&ext.to_str().unwrap())
            {
                let sound = StaticSoundData::from_file(dir_path.as_path()).unwrap();
                result.insert(String::from(dir_name), sound);
            }
        }

        result
    }

}