function [ocp_model, ocp_opts] = ocp_build(T, N, model, x0, x_ref)
%% Model
ocp_model = acados_ocp_model();
ocp_model.set('name', 'arm_model');
ocp_model.set('T', T);
ocp_model.set('sym_x', model.sym_x);
ocp_model.set('sym_xdot', model.sym_xdot);
ocp_model.set('sym_u', model.sym_u);
% Cost
ocp_model.set('cost_type', 'nonlinear_ls');  
ocp_model.set('cost_type_e', 'nonlinear_ls'); 
ocp_model.set('cost_W', model.W);
ocp_model.set('cost_W_e', model.W_e);
ocp_model.set('cost_expr_y', model.cost_expr_y);
ocp_model.set('cost_expr_y_e', model.cost_expr_y_e);
% Dynamics
ocp_model.set('dyn_type', 'explicit');
ocp_model.set('dyn_expr_f', model.expr_f_expl);
% Constraints
ocp_model.set('constr_type', 'auto');
ocp_model.set('constr_expr_h', model.expr_h);
ocp_model.set('constr_lh', model.constr_l); 
ocp_model.set('constr_uh', model.constr_u); 
ocp_model.set('constr_Jbx', eye(model.nx,model.nx));
ocp_model.set('constr_lbx', model.constr_l);
ocp_model.set('constr_ubx', model.constr_u);
ocp_model.set('constr_Jbx_e', eye(model.nx,model.nx));
ocp_model.set('constr_lbx_e', model.constr_l);
ocp_model.set('constr_ubx_e', model.constr_u);
ocp_model.set('constr_x0', x0);
ocp_model.set('cost_y_ref', [x_ref; 0; 0; 0; 0; 0; 0]); 
% ocp_model.set('cost_y_ref', [x_ref; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0]); 
ocp_model.set('cost_y_ref_e', x_ref); 

%% Opts
ocp_opts = acados_ocp_opts();
ocp_opts.set('param_scheme_N', N);
ocp_opts.set('nlp_solver', 'sqp'); 
ocp_opts.set('nlp_solver_exact_hessian', 'false');
ocp_opts.set('qp_solver', 'partial_condensing_hpipm'); 
ocp_opts.set('qp_solver_cond_N', 5);
ocp_opts.set('sim_method', 'erk');
ocp_opts.set('sim_method_num_stages', 4);
ocp_opts.set('sim_method_num_steps', 3);
end