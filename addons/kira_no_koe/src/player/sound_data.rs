use std::thread;

use godot::prelude::*;
use kira::*;


#[derive(GodotClass)]
#[class(tool, init, base=Resource)]
pub struct GodotStaticSoundData
{
    #[init(val=Option::None)]
    pub data: Option<sound::static_sound::StaticSoundData>,

    #[init(val=SoundOption { volume: 1., pitch: 0., yaw: 0.})]
    pub option: SoundOption,
}


#[godot_api]
impl GodotStaticSoundData
{

}


#[derive(GodotClass)]
#[class(init, base=RefCounted)]
struct SoundOption
{
    #[init(val=1.)]
    pub volume: f32,
    #[init(val=0.)]
    pub pitch: f32,
    #[init(val=0.)]
    pub yaw: f32,
}