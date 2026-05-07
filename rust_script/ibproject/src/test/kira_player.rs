use godot::{prelude::*};
use kira::{
	AudioManager,
    AudioManagerSettings,
    DefaultBackend,
    Tween,
    sound::static_sound::StaticSoundData
};


#[derive(GodotClass)]
#[class(init, tool, base=Node)]
struct KiraPlayer
{
    // VAR
    #[export]
    #[init(val = 0.)]
    #[var(set = set_vol)]
    volume: f32,
    #[export]
    stream: Option<Gd<AudioStream>>,

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


const SAMPLE_PATH: &str = "C:/Users/fndlt/OneDrive/문서/GitHub/project_revenant/audio/AZALI - show me the sky. show me how to live.mp3";


#[godot_api]
impl INode for KiraPlayer
{
    fn enter_tree(&mut self)
    {
        let data = StaticSoundData::from_file(SAMPLE_PATH).expect("Static Sound Data Load Error");
        self.sound_data = Some(data);
    }
}


#[godot_api]
impl KiraPlayer
{
    #[func]
    fn play(&mut self)
    {
        let mut _manager = AudioManager::<DefaultBackend>::new(AudioManagerSettings::default()).expect("Error");
        
        _manager.main_track().set_volume(10., Tween::default());

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
                .set_volume(value, kira::Tween::default());
        }
    }


}
