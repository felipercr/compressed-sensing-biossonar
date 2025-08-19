function nc_mask = create_nc_mask(simulation, type, size)
    switch type
        case 'half_grid'
            Nx = simulation.kgrid.Nx;
            Ny = simulation.kgrid.Ny;
            nc_mask = zeros(Nx, Ny);
            for i = size:Nx
                nc_mask(i, :) = 1;
            end
    end
end

