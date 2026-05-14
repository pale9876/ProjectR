use std::{collections::HashMap, fs::DirEntry, io::{Cursor, Read}};
use godot::{classes::{ProjectSettings, ResourceSaver, resource_saver::SaverFlags}, prelude::*};
use symphonia::core::{conv::{FromSample, IntoSample}, io::MediaSource};

use std::io::{BufReader, BufWriter};
use kira::sound::{SoundData, static_sound::StaticSoundData};

use crate::player::{sound_data::StaticSoundData as GodotStaticSoundData};


#[derive(Debug, Clone)]
pub struct KiraDB
{
    pub cache: HashMap<String, StaticSoundData>,
}

impl KiraDB
{
    pub const DEFAULT_PATH: &str = "res://audio/";
    pub const exts: [&str; 3] = ["mp3","ogg","wav"];

    pub fn db_init() -> Self
    {
        let mut db = Self {
            cache : HashMap::new()
        };

        db.load_files_from_path(&String::from(Self::DEFAULT_PATH));

        db
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

    pub fn load_files_from_path(&mut self, path: &String)
    {
        self.cache.clear();

        let g_path = ProjectSettings::singleton().globalize_path(path);
        let read_dir = std::fs::read_dir(g_path.to_string()).expect("Failed");
        
        for dir in read_dir
        {
            if !dir.is_err()
            {
                let entry = dir.unwrap();

                if entry.path().is_dir()
                {
                    let sub_dir = std::fs::read_dir(&entry.path()).expect("Failed");
                    for f in sub_dir
                    {
                        if !f.is_err()
                        {
                            let _file = f.unwrap();
                            if _file.path().is_file()
                            {
                                self.load_from_file(&_file);
                            }
                        }
                    }
                }
                else if entry.path().is_file()
                {
                    self.load_from_file(&entry);
                }
            }
        }

        godot_print!("Audio Data Load Finished");
    }

    fn find_res(path: &String) -> bool
    {
        std::fs::File::open(path).is_ok()
    }

    fn load_from_file(&mut self, entry: &DirEntry)
    {
        let entry_path = entry.path();
        let ext = entry_path.extension();

        if Self::exts.contains(&ext.unwrap().to_str().unwrap())
        {
            let file_name = entry_path.file_name().unwrap().to_str().unwrap();

            // If Cannot Find Resource
            let data = StaticSoundData::from_file(&entry.path());
            
            if !data.is_err()
            {
                let unwraped = data.unwrap();
                
                // godot_print!("SavePath => {:?}", save_path);

                let key = entry.file_name().to_str().unwrap().replace(
                    entry.path().extension().unwrap().to_str().unwrap(), ""
                ).replace(".", "");

                self.cache.insert(
                    key,
                    unwraped.clone()
                );
                
                godot_print!("Load SUCCESS => {:?}", entry.file_name())
            }
            else
            {
                godot_print!("Load Failed => {:?}", entry.path())
            }
        }
    }

}