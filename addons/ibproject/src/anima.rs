use std::{time::Instant};

use godot::{prelude::*};


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
                for id in self.instances.iter_mut()
                {
                    let mut obj = Gd::<AnimaObj>::from_instance_id(InstanceId::from_i64(*id));
                    if !obj.bind().paused
                    {
                        obj.bind_mut().tick();
                    }
                }
            }
        }

        self.time = Instant::now();

    }

    #[func]
    fn obj_init(&mut self, obj: Gd<AnimaObj>)
    {
        self.instances.push(obj.instance_id().to_i64());
    }

    #[func]
    fn obj_free(&mut self, obj: Gd<AnimaObj>)
    {
        if let Ok(val) = self.instances.binary_search(&obj.instance_id().to_i64())
        {
            self.instances.remove(val);
        }
    }


    #[func] fn set_fps(&mut self, &value: f32) { self.delta = value; }
    #[func] fn set_paused(&mut self, &toggle: bool) { self.paused = toggle; }

}


#[derive(GodotClass)]
#[class(tool, base=Object)]
pub struct AnimaObj
{

    paused: bool,
    base: Base<Object>,
}


#[godot_api]
impl IObject for AnimaObj
{
    fn init(_base:Base<Object>) -> Self
    {
        let obj = Self {
            paused: true,

            base: _base,
        };

        obj
    }
}


#[godot_api]
impl AnimaObj
{
    #[func]
    pub fn act(&mut self)
    {
        Anima::singleton().bind_mut().obj_init(self.to_gd());
        self.play();
    }


    #[func]
    pub fn kill(&mut self)
    {
        Anima::singleton().bind_mut().obj_free(self.to_gd());
    }


    #[func]
    pub fn pause(&mut self)
    {
        self.paused = true;
    }


    #[func]
    pub fn play(&mut self)
    {
        self.paused = false;
    }


    #[func(virtual)]
    pub fn tick(&mut self)
    {
        // Do Something
    }
}