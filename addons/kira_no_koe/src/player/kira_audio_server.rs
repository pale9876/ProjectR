use std::collections::HashMap;

use godot::{classes::notify::{NodeNotification, ObjectNotification}, prelude::*};
use kira::*;

use crate::player::{
    kira_db::KiraDB, kira_listener::KiraListener, sound_data::GodotStaticSoundData
};


#[derive(GodotClass)]
#[class(base=Node, tool, init, singleton)]
struct KiraAudioServer
{
    #[init(val=KiraDB::db_init())]
    db: KiraDB,
    #[init(val=HashMap::new())]
    bus: HashMap<String, AudioManager>,
    listener: Option<KiraListener>,

    base: Base<Node>,
}

#[godot_api]
impl INode for KiraAudioServer
{
    fn on_notification(&mut self, what: NodeNotification)
    {
        if what == NodeNotification::EXTENSION_RELOADED
        {
            self.db.load_files_from_path(
                &String::from(KiraDB::DEFAULT_PATH)
            );
        }
    }

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

    #[func]
    fn create_data(&self, name: String) -> Gd<GodotStaticSoundData>
    {
        let mut result: Gd<GodotStaticSoundData> = GodotStaticSoundData::new_gd();
        let data = self.db.find_data(&name);
        result.bind_mut().data = data;

        result
    }

}