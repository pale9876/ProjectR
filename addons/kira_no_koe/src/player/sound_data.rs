use godot::prelude::*;
use kira::*;


#[derive(GodotClass)]
#[class(init, base=Resource)]
pub struct StaticSoundData
{
    #[init(val=Option::None)]
    pub data: Option<sound::static_sound::StaticSoundData>,

    #[init(val=SoundOption { volume: 1. })]
    pub option: SoundOption,

    base: Base<Resource>,
}


#[godot_api]
impl StaticSoundData
{

    

}

#[derive(GodotClass)]
#[class(init, base=RefCounted)]
struct SoundOption
{
    #[init(val=1.)]
    pub volume: f32,
}