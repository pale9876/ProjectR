use std::fmt::Debug;

use godot::{classes::{AudioListener2D, RefCounted}, prelude::*};

use kira::{
	AudioManager,
    AudioManagerSettings,
    DefaultBackend,
    Tween,
    backend::cpal::CpalBackend,
    sound::{static_sound::StaticSoundData, streaming::StreamingSoundData},
    track::MainTrackBuilder
};

use glam::*;

use crate::player::sound_data::{self, GodotStaticSoundData};



#[derive(GodotClass)]
#[class(init, tool, base=Node)]
struct KiraPlayer
{
    // VAR
    #[export]
    #[init(val = 0.)]
    #[var(set = set_vol)]
    volume: f32,

    // NON VAR
    audio_manager: Option<AudioManager>,
    #[export]
    sound_data: Option<Gd<GodotStaticSoundData>>,

    // tool button
    #[export_tool_button(fn=Self::play, name = "Play")]
    _play: PhantomVar<Callable>,
    #[export_tool_button(fn=Self::stop, name = "Stop")]
    _stop: PhantomVar<Callable>,

    base: Base<Node>,
}


#[godot_api]
impl KiraPlayer
{
    #[func]
    fn play(&mut self)
    {
        if self.sound_data.is_none() { return }

        let settings = AudioManagerSettings::default();
        let main_track_builder = MainTrackBuilder::new().volume(1.);

        let mut _manager = AudioManager::<CpalBackend>::new(settings).expect("Error");
        
        let mut _playback = self.sound_data.as_mut().unwrap().bind_mut().data.clone().unwrap();
        _manager.main_track().set_volume(self.volume, Tween::default());
        _manager.play(_playback).expect("Error");
        
        
        self.audio_manager = Some(_manager);

        godot_print!("Play");
    }


    #[func]
    fn stop(&mut self)
    {
        if self.audio_manager.is_some()
        {
            self.audio_manager = Option::None;
        }

        godot_print!("Stop");
    }

    #[func]
    fn set_vol(&mut self, value: f32)
    {
        self.volume = value;

        if self.audio_manager.is_some()
        {
            self.audio_manager
                .as_mut().unwrap()
                .main_track()
                .set_volume(
                    value, kira::Tween::default()
                );
        }
    }
}

#[derive(GodotClass)]
#[class(init, base=Resource)]
struct KiraStream
{
    position: Vector2,
    data: Gd<GodotStaticSoundData>,
    base: Base<Resource>,
}
