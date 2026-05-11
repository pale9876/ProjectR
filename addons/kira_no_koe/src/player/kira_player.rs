use godot::{classes::{AudioListener2D, RefCounted}, prelude::*};

use kira::{
	AudioManager,
    AudioManagerSettings,
    DefaultBackend,
    Tween,
    backend::cpal::CpalBackend,
    sound::static_sound::StaticSoundData,
    track::MainTrackBuilder
};

use mint::*;



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
    sound_data: Option<StaticSoundData>,

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
        let settings = AudioManagerSettings::default();
        let main_track_builder = MainTrackBuilder::new().volume(1.);
        

        let mut _manager = AudioManager::<CpalBackend>::new(
            settings
        ).expect("Error");
        
        _manager.main_track().set_volume(self.volume, Tween::default());
        _manager.play(
            self.sound_data.as_ref().unwrap().clone()
        ).expect("Error");
        
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
#[class(init, base=RefCounted)]
struct KiraAudioStreamer2D
{
    position: Vector2,
    base: Base<RefCounted>,
}


#[derive(GodotClass)]
#[class(init, base=RefCounted)]
struct KiraAudioListner
{
    position: Vector2,
    base: Base<RefCounted>,
}

type godotvec2 = godot::prelude::Vector2;
type mintvec3 = mint::Vector3::<f32>;


macro_rules! mint3
{
    ($i:ident) => {
        mint::Vector3::<f32>{x: $i.x, y :$i.y, z:0.}
    };
}


macro_rules! qt {
    ($i: tt) => {
        mint::Quaternion::<f32>::from($i)
    };
}


#[godot_api]
impl KiraAudioListner
{
    fn add_listner(&self, &pos: godotvec2, &mut manager: AudioManager)
    {
        let vec3 = mint3!(pos);
        let qt = qt!([0., 0., 0., 0.]);

        let result = manager.add_listener(
            vec3,
            qt
        ).expect("Failed");
    }
    
}

