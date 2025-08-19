function g_new = add_nc_voxels(simulation, nc_mask, g)
    
    Nx = simulation.kgrid.Nx;
    Ny = simulation.kgrid.Ny;
    grid_size = Nx*Ny;

    g_new = zeros(grid_size, 1);

    nc_indices = find(nc_mask);

    i = 0;
    for v = 1:grid_size
        if ismember(v, nc_indices)
            continue
        else
            i = i+1;
            g_new(v) = g(i);
        end
    end


end

