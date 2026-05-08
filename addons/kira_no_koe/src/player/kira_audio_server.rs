use godot::prelude::*;
use kira::sound::SoundData;
use std::{io::Read, *};


use crate::player::kira_db::KiraDB;


#[derive(GodotClass)]
#[class(base=Node, init)]
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
}