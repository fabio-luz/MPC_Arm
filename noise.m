function x = noise(x_pre)
    x = x_pre + (-0.05 + 0.1*rand(6,1));
    flag = 1; % To guarantee the physical constraints are respected
    while(flag)
        flag = 0;
        if (x(1) < -3.054 || x(1) > 3.054)  
            x(1) = x_pre(1) + (-0.05 + 0.1*rand(1));
            flag = 1;
        end
        if (x(2) < -1.5707 || x(2) > 0.628319)
            x(2) = x_pre(2) + (-0.05 + 0.1*rand(1));
            flag = 1;
        end
        if (x(3) < -1.4101 || x(3) > 0.994838)
            x(3) = x_pre(3) + (-0.05 + 0.1*rand(1));
            flag = 1;
        end 
        if (x(4) < -2.61799 || x(4) > 2.61799)  
            x(4) = x_pre(4) + (-0.05 + 0.1*rand(1)); 
            flag = 1;
        end
        if (x(5) < -2.26893 || x(5) > 2.26893) 
            x(5) = x_pre(5) + (-0.05 + 0.1*rand(1));  
            flag = 1;
        end
        if (x(6) < -2.57 || x(6) > 2.57)
            x(6) = x_pre(6) + (-0.05 + 0.1*rand(1));
            flag = 1;
        end
    end
end