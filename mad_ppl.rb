use_debug false
use_bpm 150

live_loop :metro do
  sleep 1
end

define :pattern do |pattern|
  return pattern.ring.tick == "x"
end


#----------------------------------------------------------------------
#MIXER
master = 1.0
kick_amp = 0.0
seckick_amp = 0.0
drum_amp = 0.0
snare_amp = 0.0
snare2_amp = 0.0
snare3_amp = 0.0
hihat_amp = 0.00

samp1_amp = 0.0

synth1_amp = 0.0
synth2_amp = 0.2
#----------------------------------------------------------------------
#----------------------------------------------------------------------
#DRUM CONTROLS

#kick
kick_co = range(80, 65, 0.25).mirror

#seckick
seckick_pitch = -22

#----------------------------------------------------------------------
#----------------------------------------------------------------------
#SYNTH CONTROLS

#----------------------------------------------------------------------
#----------------------------------------------------------------------
#SAMPLE CONTROLS

#----------------------------------------------------------------------

#----------------------------------------------------------------------
#RHYTMS
kick_rhythm = (ring 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
               1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
               1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
               1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0)

kick_rhythm2 = (ring 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1)

snare_rhythm = (ring 1, 0, 1, 1, 1, 1, 0)

#----------------------------------------------------------------------


#----------------------------------------------------------------------
#SAMPLES
catlaugh = "/Users/rober/Documents/samples/use_rnd/catshire.wav"
sechats = "/Users/rober/Documents/samples/use_rnd/hat.wav"
hardkick = "/Users/rober/Documents/samples/use_rnd/hardkick.wav"
#----------------------------------------------------------------------


#----------------------------------------------------------------------
#TEST PART

#----------------------------------------------------------------------
#DRUM PART

#Kick
live_loop :kick do
  with_fx :reverb, room: 0.8, mix: 0.5 do
    sleep 1
    sample  :bass_trance_c,
      amp: seckick_amp * master * kick_rhythm2.tick,
      beat_stretch: 0.4,
      pitch: seckick_pitch
  end
end

#MAINKICK
live_loop :mainkick, sync: :metro do
  #stop
  with_fx :distortion, distort: 0.35 do
    with_fx :eq, amp: 1, low_shelf: 0.125, low: -0.5 do
      sample hardkick,
        amp: kick_amp * master * kick_rhythm.tick,
        depth: 0.1,
        cutoff: kick_co.look,
        decay: 0.25
      sleep 0.5
    end
  end
end

#SNARE
with_fx :reverb, damp: 1 do
  live_loop :snare do
    sample  :sn_zome,
      amp: snare_amp * master,
      rate: (ring, 4, 6).tick,
      cutoff: 90
    sleep 4
  end
end

#SNARE
with_fx :distortion, distort: 0.15 do
  live_loop :snare2 do
    sample :sn_generic,
      amp: snare2_amp * master * snare_rhythm.tick,
      rate: 8,
      cutoff: 80,
      beat_stretch: 1.2
    sleep 1
  end
end

with_fx :reverb, mix: 0.5 do
  live_loop :snare3 do
    sample  :sn_dub,
      amp: snare3_amp * master,
      rate: (ring, 1.75, 1.8).tick,
      cutoff: 80
    sleep 2
  end
end

with_fx :distortion, distort: 0.5 do
  with_fx :reverb, mix: 0.25 do
    live_loop :hihat do
      sync :kick
      sample :drum_cymbal_pedal, amp: hihat_amp * master, rate: 1.5, beat_stretch: 1.25
      sleep 1
      sample :drum_cymbal_closed, amp: hihat_amp * master, rate: 1.25
      sleep (ring, 1, 1).tick
      sample :drum_cymbal_pedal, amp: hihat_amp * master, rate: 1.0
      sleep 1
      sample :drum_cymbal_closed, amp: hihat_amp * master, rate: 1.25
    end
  end
end

#DRUM
with_fx :reverb, mix: 0.5 do
  live_loop :drum do
    sample :drum_tom_mid_soft,
      amp: drum_amp * master,
      rate: ring(1.5, 2, 1.5, -2).tick,
      cutoff: 80,
      beat_stretch: 2
    sleep 4
  end
end

#----------------------------------------------------------------------
#----------------------------------------------------------------------
#SYNTH PART
live_loop :synth1, sync: :metro do
  with_fx :flanger, feedback: 0.05, phase: 1 do
    with_fx :reverb, mix: 0.75 do
      synth_co = range(85, 65, 0.5).mirror
      #with_fx :pan, pan: ring(0, 0, 1, 1).tick do
      use_random_seed ring(100, 1500, 125, 400, 2500).tick
      16.times do
        with_synth :tb303 do #kalimba for harmonic version
          n1 = (ring :g1, :d1, :e2).tick
          n2 = (ring :e3, :d1, :d2, :d3).tick
          play n1,
            release: (ring, 0.1, 0.1, 0.5, 0.5).tick,
            cutoff: synth_co.look,
            res: 0.8,
            wave: 0,
            amp: synth1_amp * master,
            pitch: 10
          sleep 0.5
        end
      end
    end
  end
end

with_fx :flanger, phase: 0.2, feedback: 0.55 do
  synth_co = range(70, 80, 0.5).mirror
  live_loop :samp1 do
    sample catlaugh,
      amp: samp1_amp * master,
      beat_stretch: 8,
      rate: (ring 1, -1).tick,
      release: 0.35,
      cutoff: synth_co.look
    sleep 8
  end
end

with_fx :flanger, feedback: 0.85 do
  synth_co = range(50, 60, 0.5).mirror
  live_loop :synth2 do
    sample :ambi_dark_woosh,
      amp: synth2_amp * master,
      rate: (ring -1, -2).tick,
      beat_stretch: (ring 16, 22).tick,
      release: 0.35,
      cutoff: synth_co.look
    sleep 4
  end
end
#----------------------------------------------------------------------

