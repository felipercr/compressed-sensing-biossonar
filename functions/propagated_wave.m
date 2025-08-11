function resulting_signal = propagated_wave(simulation, distance_travelled)

    time = distance_travelled/simulation.sound_speed_medium;
    Nt_travel = round(time/simulation.kgrid.dt);
    Nt_add = simulation.kgrid.Nt - Nt_travel;
    phased_signal = [zeros(1, Nt_travel), simulation.normalized_signal, zeros(1, Nt_add)];
    phased_signal = phased_signal(1:simulation.kgrid.Nt);
    
    % TODO: Add a therm of spreadding.
    % with this, the normalizarion cannot be used

    resulting_signal = phased_signal;
end

