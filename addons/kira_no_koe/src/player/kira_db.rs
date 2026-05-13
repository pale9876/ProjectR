use std::{collections::HashMap, error::Error, fs::DirEntry, path::PathBuf};
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
        Self {
            cache : HashMap::new()
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


    pub fn load_files_from_folder(&mut self, path: &String) -> HashMap<String, StaticSoundData>
    {
        let mut result = HashMap::<String, StaticSoundData>::new();

        let g_path = ProjectSettings::singleton().globalize_path(path);
        let read_dir = std::fs::read_dir(g_path.to_string()).expect("Failed");
        
        for dir in read_dir
        {
            if !dir.is_err()
            {
                self._get_dir_or_file(dir.unwrap());
            }
        }
        result
    }

    fn _get_dir_or_file(&mut self, dir: DirEntry)
    {
        let path = dir.path();
        
        // if dir.is_err() { return; }
        if path.is_dir()
        {
            let read_dir = std::fs::read_dir(path).expect("Failed");

            for _d in read_dir
            {
                if !_d.is_err()
                {
                    self._get_dir_or_file(_d.unwrap());
                }
            }
        }
        else if path.is_file()
        {
            let ext = path.extension().unwrap();
            if exts.contains(&ext.to_str().unwrap())
            {
                self.cache.insert(
                    String::from(path.file_name().unwrap().to_str().unwrap()),
                    StaticSoundData::from_file(path).expect("Failed")
                );
            }
        }
        
    }

}