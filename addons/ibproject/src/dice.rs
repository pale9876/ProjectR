use std::collections::HashMap;

use godot::prelude::*;
use rand::prelude::*;


struct Dice<T>
{
    spot_count: i64,
    spots: Vec<(f32, T)>,
    result: Option<T>
}

impl<T> Dice<T>
{
    fn roll(&mut self)
    {
        let rand: f32 = rand::random();
        

    }

}

impl<T> Default for Dice<T>
{
    fn default() -> Self {
        Self {
            spot_count: 6,
            spots: Vec::new(),
            result: Option::None,
        }
    }
}



#[derive(GodotClass)]
#[class(init, base=RefCounted)]
struct DiceBox { title: GString, spots: Vec<DiceSpot>, spot_count: u16, base: Base<RefCounted>}


#[derive(GodotClass)]
#[class(init, base=Resource)]
struct DiceSpot { assignment: f32, value: Variant, base: Base<Resource> }


#[godot_api]
impl DiceBox
{
    #[func]
    fn make_dice(&mut self, _title: GString, spot_count: u16)
    {
        let mut dice = Dice::<Variant>::default();

        self.title = _title;

    }

    #[func]
    fn add_spot(&mut self, &info: Gd<DiceSpot>) -> bool
    {
        if self.spot_count < self.spots.len() as u16 { return false }

        let total_assign = info.bind().assignment + self.get_total_assignment();

        true
    }

    fn get_total_assignment(&self) -> f32
    {
        let mut result: f32 = 0.;

        for spot in self.spots.iter()
        {
            result += spot.assignment;
        }

        result
    }

}

