use std::{time::Instant};

use godot::{classes::node::ProcessMode, prelude::*};


#[derive(GodotClass)]
#[class(init, singleton)]
pub struct Anima
{
    #[init(val=1./60.)]
    delta: f32,

    #[init(val=false)]
    paused: bool,

    #[init(val=0.)]
    elapsed: f32,

    #[init(val=Instant::now())]
    time: Instant,

    #[init(val=Vec::new())]
    pub instances: Vec<i64>,

    base: Base<Object>,
}

#[godot_api]
impl Anima
{
    pub fn _tick(&mut self)
    {
        if self.paused { return }

        let el = self.time.elapsed().as_secs_f32();
        self.elapsed += el;

        if self.elapsed >= self.delta
        {
            self.elapsed = 0.0;

            // Do
            if !self.instances.is_empty()
            {
                for id in self.instances.iter()
                {
                    let instance_id = godot::prelude::InstanceId::from_i64(*id);
                    let mut obj = Gd::<AnimaObj>::from_instance_id(instance_id);

                    obj.bind_mut().tick();
                }
            }
        }

        self.time = Instant::now();

    }

    #[func]
    fn init(&mut self, &id: i64)
    {
        if !self.instances.contains(&id)
        {
            self.instances.push(id);
        }
    }

    #[func]
    fn free(&mut self, &id: i64)
    {
        if let Ok(s) = self.instances.binary_search(&id)
        {
            let val = self.instances.remove(s);
            godot_print!("{} has removed", val);
        }
    }


    #[func] fn set_fps(&mut self, &value: f32) { self.delta = value; }
    #[func] fn set_paused(&mut self, &toggle: bool) { self.paused = toggle; }
}


#[derive(GodotClass)]
#[class(base=Object)]
pub struct AnimaObj
{
    base: Base<Object>,
}


#[godot_api]
impl IObject for AnimaObj
{
    fn init(_base:Base<Object>) -> Self
    {
        let obj = Self {base: _base };

        let instance_id = obj.base().instance_id();
        Anima::singleton().bind_mut().init(instance_id.to_i64());

        obj
    }

}


#[godot_api]
impl AnimaObj
{
    #[func(virtual)]
    pub fn tick(&mut self)
    {
        // Do Something
    }
}