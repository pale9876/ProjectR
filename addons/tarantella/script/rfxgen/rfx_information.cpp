#include <rfxgen/rfx_information.h>
#include <godot_cpp/core/class_db.hpp>

using namespace godot;


RFXInformation::RFXInformation()
{

}

RFXInformation::~RFXInformation()
{

}

void RFXInformation::_bind_methods()
{
    
}

void RFXInformation::set_wave_type(const WaveType wave_type)
{
    this->waveTypeValue = wave_type;
}

RFXInformation::WaveType RFXInformation::get_wave_type() const
{
    return this->waveTypeValue;
}