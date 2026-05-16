#pragma once

#ifndef RFX_INFORMATION_H
#define RFX_INFORMATION_H

#include <godot_cpp/classes/resource.hpp>
#include <rfxgen/raylib.h>
#include <rfxgen/rfxgen.h>

namespace godot
{
    class RFXInformation : public Resource
    {
        GDCLASS(RFXInformation, Resource)
        
        enum WaveType
        {
            SQUARE = 0,
            SAWTOOTH = 1,
            SINE = 2,
            NOISE = 3,
        };

        public:
            RFXInformation();
            ~RFXInformation();

            void set_wave_type(const WaveType wave_type);
            WaveType get_wave_type() const;

            void set_attack_time_value(const float value);
            float get_attack_time_value();

            WaveParams GenPickupCoin(void);

        protected:
            static void _bind_methods();

        private:
            WaveParams _waveparams;
            int randSeed;

            // Wave type (square, sawtooth, sine, noise)
            WaveType waveTypeValue;

            // Wave envelope parameters
            float attackTimeValue;
            float sustainTimeValue;
            float sustainPunchValue;
            float decayTimeValue;

            // Frequency parameters
            float startFrequencyValue;
            float minFrequencyValue;
            float slideValue;
            float deltaSlideValue;
            float vibratoDepthValue;
            float vibratoSpeedValue;
            //float vibratoPhaseDelayValue;

            // Tone change parameters
            float changeAmountValue;
            float changeSpeedValue;

            // Square wave parameters
            float squareDutyValue;
            float dutySweepValue;

            // Repeat parameters
            float repeatSpeedValue;

            // Phaser parameters
            float phaserOffsetValue;
            float phaserSweepValue;

            // Filter parameters
            float lpfCutoffValue;
            float lpfCutoffSweepValue;
            float lpfResonanceValue;
            float hpfCutoffValue;
            float hpfCutoffSweepValue;

    };

}






#endif