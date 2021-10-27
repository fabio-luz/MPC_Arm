function [x0, y_ref] = input_gen(Nsim, opt)
x0 = [-3; 0.5; 0; pi/4; -3*pi/5; 2.57];
y_ref = zeros(3, Nsim+1);
if opt == 1 % Example 1: Success
    y_ref = repmat([95.6238; -245.0072; 218.3647],1, Nsim+1);
elseif opt == 2 % Example 2: Success
    x0 = [0; 0; 0; 0; 0; 0];
    y_ref = repmat([126.2132; 139.0825; 573.6399],1, Nsim+1);
elseif opt == 3 % Example 3: 2 References 
    for i = 1:(Nsim+1)
        if (rem(fix(i/20),2) == 0)
           y_ref(:,i) = [-50; -150; 417.5000];
        else
           y_ref(:,i) = [0; -245.0072; 218.3647];
        end
    end
elseif opt == 4 % Example 4: Circle Reference
    ang=0:((2*pi)/Nsim):2*pi; xc=-100; yc=150; zc=450;
    y_ref(1,:) = 60*cos(ang) + xc;
    y_ref(2,:) = 60*sin(ang) + yc;
    y_ref(3,:) = zeros(1, Nsim+1) + zc;
elseif opt == 5 % Example 5: Unreachable Reference
    x0 = [0; 0; 0; 0; 0; 0];
    y_ref = repmat([300; 300; 400],1, Nsim+1);
elseif opt == 6 % Example 6: Impossible initial state
    x0 = [-5; -5; 0; pi/4; 0; 0]; 
    y_ref = repmat([95.6238; -245.0072; 218.3647],1, Nsim+1);
end
end