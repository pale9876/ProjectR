use std::{collections::HashMap, fs::DirEntry};
use godot::{classes::{ProjectSettings, ResourceSaver, resource_saver::SaverFlags}, prelude::*};


use kira::{
    sound::static_sound::StaticSoundData
};

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

    fn find_res(entry: &DirEntry) -> bool
    {
        let resource_file = std::fs::File::open(entry.path());

        false
    }

    fn load_from_file(&mut self, entry: &DirEntry)
    {
        if Self::exts.contains(&entry.path().extension().unwrap().to_str().unwrap())
        {
            let find_res = Self::find_res(entry);

            if find_res { return }

            // If Cannot Find Resource
            let file = StaticSoundData::from_file(&entry.path());
            
            if !file.is_err()
            {
                let unwraped = file.unwrap();
                let save_path = String::from(entry.path().to_str().unwrap()) + &String::from(".res");

                godot_print!("SavePath => {:?}", save_path);

                let mut res = GodotStaticSoundData::new_gd();

                res.bind_mut().data = Some(unwraped.clone());
                ResourceSaver::singleton()
                    .save_ex(&res)
                    .flags(SaverFlags::COMPRESS)
                    .path(&save_path)
                    .done();

                self.cache.insert(
                    String::from(entry.file_name().to_str().unwrap()), unwraped.clone()
                );
                
                godot_print!("File Load SUCCESS => {:?}", entry.path())
            }
            else
            {
                godot_print!("File Load Failed => {:?}", entry.path())
            }
            return
        }
    }

}