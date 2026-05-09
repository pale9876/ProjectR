use godot::prelude::*;
use kira::sound::SoundData;
use std::{io::Read, *};


use crate::player::kira_db::KiraDB;


#[derive(GodotClass)]
#[class(base=Node, init, singleton)]
struct KiraAudioServer
{
    #[init(val=KiraDB::db_init())]
    db: KiraDB,

    base: Base<Node>,
}


#[godot_api]
impl KiraAudioServer
{
    fn get_db(&self) -> KiraDB
    {
        self.db.clone()
    }

    #[func]
    fn has_sound(&self, name: GString) -> bool
    {
        if let Some(data) = self.get_db().find_data(&name.to_string())
        {
            return true
        }

        false
    }

    #[func]
    fn get_list(&self) -> Array<GString>
    {
        let mut result: Array<GString> = Array::new();

        let key_arr = self.db.cache.keys();

        for key in key_arr
        {
            let sound_name = GString::from(key.as_str());
            result.push(&GString::from(key.as_str()));
        }

        result

    }

}