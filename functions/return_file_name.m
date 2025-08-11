function name = return_file_name(simulation, type)
    switch type
        case 'dictionary'
            if simulation.sensor_type == 1
                name = [type '_circ' num2str(simulation.n_sensors) '.mat'];
            elseif simulation.sensor_type == 2
                name = [type '_line' num2str(simulation.n_sensors) '.mat'];
            end

        case 'g'
            if simulation.sensor_type == 1
                name = [type '_circ' num2str(simulation.n_sensors) '_ob' num2str(simulation.image_number) '.mat'];
            elseif simulation.sensor_type == 2
                name = [type '_line' num2str(simulation.n_sensors) '_ob' num2str(simulation.image_number) '.mat'];
            end
        
        case 'result'
            if simulation.sensor_type == 1
                name = ['results/' type '_circ' num2str(simulation.n_sensors) '_ob' num2str(simulation.image_number) '.png'];
            elseif simulation.sensor_type == 2
                name = ['results/' type '_line' num2str(simulation.n_sensors) '_ob' num2str(simulation.image_number) '.png'];
            end


         case 'accplt'
            if simulation.sensor_type == 1
                name = ['results/' type '_circ' num2str(simulation.n_sensors) '_ob' num2str(simulation.image_number) '.png'];
            elseif simulation.sensor_type == 2
                name = ['results/' type '_line' num2str(simulation.n_sensors) '_ob' num2str(simulation.image_number) '.png'];
            end

         case 'recplt'
            if simulation.sensor_type == 1
                name = ['results/' type '_circ' num2str(simulation.n_sensors) '_ob' num2str(simulation.image_number) '.png'];
            elseif simulation.sensor_type == 2
                name = ['results/' type '_line' num2str(simulation.n_sensors) '_ob' num2str(simulation.image_number) '.png'];
            end
    end
end

