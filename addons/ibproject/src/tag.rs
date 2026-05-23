use std::collections::HashMap;

use godot::prelude::*;



#[derive(GodotClass)]
#[class(tool, init, base=RefCounted)]
pub struct KeyChain
{
    #[init(val=HashMap::new())]
    tags: HashMap<StringName, Gd<Tag>>,

    base: Base<RefCounted>,
}

#[godot_api]
impl KeyChain
{
    #[func]
    pub fn add_tag(&mut self, tag: Gd<Tag>)
    {
        let mut t = tag;
        t.bind_mut().entered();

        let key = &t.bind().name;
        let amount = t.bind().amount;
        let duration = t.bind().duration;
        
        if self.tags.contains_key(&t.bind().name)
        {
            self.tags.get_mut(&t.bind().name).unwrap().bind_mut().duration = duration;
            self.tags.get_mut(&t.bind().name).unwrap().bind_mut().amount += amount;
        }
        else
        {
            self.tags.insert( key.clone(), t.clone() );
            self.tag_entered(key.clone());
        }
    }

    #[func]
    pub fn erase_tag(&mut self, name: StringName)
    {
        if self.tags.contains_key(&name)
        {
            self.tags.get_mut(&name).unwrap().bind_mut().exited(); // exited 호출
            self.tags.remove(&name);
            self.tag_exited(name);
        }
    }


    #[func]
    pub fn tick(&mut self, delta: f32)
    {
        let mut arr: Vec<StringName> = Vec::new();

        for tup in self.tags.iter_mut()
        {
            tup.1.bind_mut()._duration -= delta;
            
            let dur = tup.1.bind()._duration;
            if dur < 0.
            {
                let lim = tup.1.bind().duration; 
                let dec = tup.1.bind().dec;

                // 태그 효과 발동
                tup.1.bind_mut().invoke();
                // Amount 감소
                tup.1.bind_mut().amount -= dec;

                if tup.1.bind().amount < 0.
                {
                    arr.push(tup.0.clone());
                }
                else
                {
                    tup.1.bind_mut()._duration = lim;
                }
            }
        }

        // 기한이 다 된 (키, 태그) 제거
        for key in arr
        {
            self.erase_tag(key);
        }

    }


    #[func(virtual)]
    pub fn tag_entered(&mut self, tag_name: StringName)
    {
        // do something
    }

    #[func(virtual)]
    pub fn tag_exited(&mut self, tag_name: StringName)
    {

    }
}



#[derive(GodotClass)]
#[class(tool, init, base=RefCounted)]
pub struct Tag
{
    #[export] name: StringName,
    #[export] amount: f32,
    #[export] #[var(set=set_duration)] duration: f32,
    #[export] dec: f32,

    _duration: f32,

    base: Base<RefCounted>,
}


#[godot_api]
impl Tag
{
    #[func]
    pub fn set_duration(&mut self, value: f32)
    {
        self.duration = value;
        self._duration = value;
    }

    #[func(virtual)]
    pub fn entered(&mut self)
    {

    }

    #[func(virtual)]
    pub fn exited(&mut self)
    {

    }

    #[func(virtual)]
    pub fn invoke(&mut self)
    {

    }
}