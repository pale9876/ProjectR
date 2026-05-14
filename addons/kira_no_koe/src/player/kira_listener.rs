use glam::Quat;
use godot::prelude::*;
use kira::*;


pub struct KiraListener
{
    
    pitch: f32,
    yaw: f32,    
    pos: Vector3,

}


#[derive(GodotClass)]
#[class(init, base=RefCounted)]
struct KiraAudioListner
{
    position: Vector3,
    pitch: f32,
    yaw: f32,
    base: Base<RefCounted>,
}

#[godot_api]
impl KiraAudioListner
{
    fn add_listner(&self, &pos: Vector3, &mut manager: AudioManager)
    {
        let result = manager.add_listener(
            self.from_godot(pos),
            self.orientation()
        ).expect("Failed");
    }
    
    fn from_godot(&self, &pos: Vector3) -> glam::Vec3
    {
        glam::vec3(pos.x, pos.y, pos.z)
    }

    fn orientation(&self) -> Quat
    {
        Quat::IDENTITY
    }
}



