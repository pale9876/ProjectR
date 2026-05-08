use std::collections::HashMap;
use godot::prelude::*;


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
    cache: HashMap<String, StaticSoundData>,
}


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


    pub fn load_files_from_folder(&mut self, path: &String)
    {
        let paths = std::fs::read_dir(path).expect("Failed");
        for dir in paths
        {
            let dir_path= dir.unwrap().path();
            let dir_name = dir_path.file_name().unwrap().to_str().unwrap();
            if !self.cache.contains_key(dir_name)
            {
                let sound = StaticSoundData::from_file(dir_path.as_path()).unwrap();
                self.cache.insert(String::from(dir_name), sound);
            }
        }
    }

}