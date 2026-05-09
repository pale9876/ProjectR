use godot::prelude::*;
use kira::*;


#[derive(GodotClass)]
#[class(init, base=Resource)]
pub struct StaticSoundData
{
    data: Option<sound::static_sound::StaticSoundData>,

    #[init(val=1.)]
    vol: f32,

    base: Base<Resource>,
}


#[godot_api]
impl StaticSoundData
{

    

}