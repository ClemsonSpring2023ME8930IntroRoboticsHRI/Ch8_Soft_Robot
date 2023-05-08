 %% initialize
close all;
clear all;
format shorte;
clc;
pause(1);
addpath('./hll');
user_pars.exp_case = 2 ; % experiment scenario

%% parameters
% 2023.01.04
% Since for EBR modelling method, the problem that different segments will
% separate from each other when the shear force is too large (actually not
% that large), to showcase a relatively normal animation video, we now try
% to use ROM method.

user_pars.n_SRA=1; % number of the SRA or bodies
n_p = 2; % number of segments

% If we are going to use for loop to derive the EOMs from here, it could be
% unrealistic because in the future the geometry properties of each arm
% might be different, they should be well defined in the beginning.

l_s = 600e-3 ; %44e-3 ; % manipulator length
r_s2 = 40e-3 ; % manipulator outer radius, ra2,12.5
r_s1 = 32e-3 ; % manipulator inner radius, ra1, make-up data for all inner radius.
r_p2 = 10.5e-3 ; % pressure chamber outer radius
r_p1 = 8.5e-3 ; % 2.25e-3 pressure chamber inner radius, rp
r_t = 0.2e-3 ; % braid diameter
gamma = pi / 2 - acos( 1 - r_t ^ 2 / 2 / r_p2 ^ 2 ) ;
r_o = 8.5e-3 ; %8.4e-3
phi_o = acos( 1 - r_p2 ^ 2 / 2 / r_o ^ 2 ) ;
r_od = [ cos( 3*pi/6)  sin( 3*pi/6)  0 ; % according to Ali's inputs
         cos( 3*pi/6)  sin( 3*pi/6)  0 ;
         cos( -pi/6 )   sin( -pi/6 )   0 ;
         cos( -pi/6 )   sin( -pi/6  )  0 ;
         cos( 7*pi/6)  sin( 7*pi/6 )  0 ;
         cos( 7*pi/6 )  sin( 7*pi/6)  0 ] ;
r_od = [ r_od(:,2) -r_od(:,1) r_od(:,3) ] ;

m_f = 13.47e-3 ; % 11e-3 ; % force sensor and its mount mass
l_f = 14.5e-3; % 36.5e-3 ; % 36.5-23=14.5e-3 ; %17e-3 ;
r_f = 7.5e-3;

g_x = 0 ; g_y = 0 ; g_z = 9.81 ; % gravity
% g_x =9.81;
% g_y =0;
% g_z =0 ;

% 2023.01.16
% The density was estimated by dividing the mass of the SRA by the volume.
estimated_m=661/1000; % Unit is kg.
estimated_V=pi*(r_s2^2-3*r_p1^2)*l_s;
sigma_s =estimated_m/estimated_V; % 1.4 * ; % silicon density

E_s = 2.5e6 ; % 205e3 kPa was set originally as stated in the paper.
mu_pow = 1 ; % < 1: rate thining, > 1: rate thikening
% 2022.11.24
% mu_xi and mu_zeta are damping coefficients of local strain and
% curvature/torsion respectively.
mu_x = 1e-1 ; % 1e-1
mu_y = 1e-1 ;
mu_z = 1e-1 ;
mu_xx = 1e-5 ; % 1e-4
mu_yy = 1e-5 ;
mu_zz = 1e-5 ;


%% variables
% symbolic parameters to be changed after EOM derivation
% 2023.01.25
% It would be fine to build up symbolic variables as below when the number
% of the SRA or body is just one, when the number is increasing, there will
% be a lot of repeated procedures, so I guess if we could use sym instead
% of syms.
% syms sigma_s_ E_s_ r_s1_ r_s2_ r_p1_ l_s_ ...
%     mu_x_ mu_y_ mu_z_ mu_xx_ mu_yy_ mu_zz_ mu_pow_ ...
%     g_x_ g_y_ g_z_ lambda_ m_f_ l_f_ r_f_ r_o_ gamma_ ...
%     p11_ p21_ p31_ p41_ p51_ p61_ ...
%     p12_ p22_ p32_ p42_ p52_ p62_...
%     f_tx1_ f_ty1_ f_tz1_ tau_tx1_ tau_ty1_ tau_tz1_...
%     f_tx2_ f_ty2_ f_tz2_ tau_tx2_ tau_ty2_ tau_tz2_ real;
    % 2023.01.24 ⬆
% add additional elements for arm 2
 
syms sigma_s_ E_s_ r_s1_ r_s2_ r_p1_ l_s_ ...
    mu_x_ mu_y_ mu_z_ mu_xx_ mu_yy_ mu_zz_ mu_pow_ ...
    g_x_ g_y_ g_z_ lambda_ m_f_ l_f_ r_f_ r_o_ gamma_ real;

% Pressure definition
p1_=sym('p1_',[1,user_pars.n_SRA]);
p2_=sym('p2_',[1,user_pars.n_SRA]);
p3_=sym('p3_',[1,user_pars.n_SRA]);
p4_=sym('p4_',[1,user_pars.n_SRA]);
p5_=sym('p5_',[1,user_pars.n_SRA]);
p6_=sym('p6_',[1,user_pars.n_SRA]);

% Force input definition
ft_x_=sym('ft_x_',[1,user_pars.n_SRA]);
ft_y_=sym('ft_y_',[1,user_pars.n_SRA]);
ft_z_=sym('ft_z_',[1,user_pars.n_SRA]);
taut_x_=sym('taut_x_',[1,user_pars.n_SRA]);
taut_y_=sym('taut_y_',[1,user_pars.n_SRA]);
taut_z_=sym('taut_z_',[1,user_pars.n_SRA]);

vars = [ sigma_s_ E_s_ r_s1_ r_s2_ l_s_ ...
    mu_x_ mu_y_ mu_z_ mu_xx_ mu_yy_ mu_zz_ mu_pow_ ...
    g_x_ g_y_ g_z_ ...
    m_f_ l_f_ r_f_ r_p1_ r_o_ ...
    gamma_ zeros(1,12) lambda_ ] ;

for i=1:user_pars.n_SRA
    user_pars.i=i;
    vars(end-12:end-1)=[p1_(i) p2_(i) p3_(i) p4_(i) p5_(i) p6_(i) ...
        ft_x_(i) ft_y_(i) ft_z_(i) taut_x_(i) taut_y_(i) taut_z_(i)];
    
    % parameter values, can be changed after derivations
    var_vals = [ sigma_s, E_s, r_s1, r_s2, l_s, mu_x, mu_y, mu_z, mu_xx, mu_yy, ...
        mu_zz, mu_pow, g_x, g_y, g_z, m_f, l_f, r_f, r_p1, r_o, gamma, zeros(1,12) , 1 ] ;
    
    % simplification
    mu_pow_ = mu_pow ;
    
    %% exp. readings
    [tip_pos , tip_RQ , p,f_ex, t_exp , t_exp_equil ] = data_editor( var_vals ,user_pars); % motor input and robot tip position from a sample experiment
    user_pars.tip_pos = tip_pos ;
    user_pars.tip_RQ = tip_RQ ;
    user_pars.p = p;
    user_pars.f_ex = f_ex ;
    user_pars.n_l = n_p ;
    
    %% preprocess
    l_ss = l_s_ / n_p ; % segment length
    a_aw = pi * ( r_s2_.^ 2 - r_s1_.^ 2 - 6 * r_p1_.^ 2 ) ; % no change
    m_s = a_aw * l_s_ * sigma_s_ ;  % manipulator mass
    r_ov = r_o_ * r_od / sqrt( lambda_ ) ;
    r_p1_ = r_p1_ * sqrt( 1 - lambda_.^ 2 * cos( gamma_ ) ^ 2 ) / sin( gamma_ ) ;
    a_p = pi * r_p1_.^ 2 ;
    a_aw = pi * ( ( r_s2_.^ 2 - r_s1_.^ 2 ) / lambda_ - 6 * r_p1_.^ 2 ) ;
    m_ss = m_s / l_s_ ; % manipulator segment mass, per unit length?
    G_s = E_s_ / 3 ;
    I_aw =  [ 1 1 2 ] * 1 / 4 * pi * ( ( r_s2_.^ 4 - r_s1_.^ 4 ) / lambda_.^ 2 - 6 * r_p1_.^ 4 ) ...
        - a_p * [ diag( r_ov(:,1:2).' * r_ov(:,1:2) ).' r_o_.^2*lambda_ ] ;
    K_v = diag( [ G_s G_s E_s_ ] ) * a_aw / lambda_ ; % ( l_ss / lambda_ ) to get deformation not strain
    K_u = diag( [ E_s_ E_s_ G_s ] ) * diag( I_aw ) / lambda_ ; % ( l_ss / lambda_ ) to get angles not curvatures/torsion
    I_ss = diag( ...
        sigma_s_ * pi * ( r_s2_.^2 - r_s1_.^2- 6 * r_p1_.^2 ) * ...
        [ 1/12*(3*(r_s2_.^2+r_s1_.^2))/lambda_ , ...
        1/12*(3*(r_s2_.^2+r_s1_.^2))/lambda_ , ...
        1/2*(r_s2_.^2+r_s1_.^2)/lambda_ ] ) ; % manipulator segment inertia
    I_f = diag( [ 1/12*m_f_*(3*r_f_^2+l_f_.^2) 1/12*m_f_*(3*r_f_.^2+l_f_.^2) 1/2*m_f_*r_f_.^2 ]...
        + m_f_ * (l_f_/2).^2 * [ 1 1 0 ] ) ; % tip force sensor segment inertia
    
    p=[p1_(i) p2_(i) p3_(i) p4_(i) p5_(i) p6_(i)];
    f_p=[0 0 p*ones(6,1)*a_p];
    tau_p=p*a_p*r_ov;
    
    %% robot
    % break DSL down to smaller pieces to prevent Matlab from complaining about too complex arguments!
    % 2023.01.27
    % Since for each new body established, the EOMs derivation and animation
    % process will be executed for one more time, we can move the aninmation
    % code to the very behind to see if anything will be changed.
    
    if user_pars.n_SRA==1
        results = ...
            tmtdyn()...
            .simulation()... % simulation
            .variables(vars, var_vals)...
            .user_parameters(user_pars)...
            .derive_eom('no')... % 'full_system', 'assume_small_velocities', 'no'
            .plot_initial_conditions('final')... % 'all', 'final' 2023.01.29: this lines of code were deleted for n_SRA>=2, probably in the future we need to plot the ICs of all arms into just one figure.
            .optimize_code()...
            .analysis()...
            .static_sim('generate_mex_file', t_exp_equil)... % edited_m_file, generate_m_file, generate_mex_file, old_mex_file, generate_mex_from_edited_m_file, generate_mex_from_c_files
            .dynamic_sim('generate_m_file', 'matlab', t_exp(1), t_exp(end))... % matlab, sundials_ode, sundials_dae, radau, radau_mex, external
            .spatial_integration_step(1e1)...
            .results_sample_rate(1e2)...
            .report_time_intervals(1)... % show sim progress in terminal
            .post_process()...
            ...animate('tube', 'show_frame', 30, 20, 20)... % ({null 'none', 'show_frame', 'side_views', 'show_frame_side_views'}, fps, axis edges, cross-section edges) 
            ...record_video()...
            .number_of_reports(1)...
            .run_user_code() ;
        
        results= results...
            .world()... % world
            .g([g_x_, g_y_, g_z_])...
            .robot(['series_rigid_link_arm_',num2str(i)])... % robot
            .body(['rigid_link',num2str(i)])...
            .with_mass(m_ss)...
            .with_inertia(I_ss)...
            .with_cross_section_radius(1/sqrt(lambda_)*r_s2_)...
            .connected_to_joint()...
            .rom()...
            .default_order(n_p)...
            .default_fit_type('polynomial')... % polynomial, spline_piecewise, spline_logistic_func
            .length(0, l_s_)...
            .fixed_inital_values()...
            .with_transformation_from_body()... % leave empty for connection to ground
            .translation([inf,inf,inf])... % axial translation w.r.t. previous joint copy
            .dof(1)...
            .base_director(0)... % prependicular at the base
            .dof(2)...
            .base_director(0)... % prependicular at the base
            .dof(3)...
            .base_director(1)... % prependicular at the base
            .initial_value_axial_locations(( 1:n_p ) * l_ss)...
            .initial_value(( 1:n_p ) * l_ss)...
            .parallel_spring()...
            .relaxed_state_from_initial_condition()...
            .rot_unit_quat([inf, inf, inf])...
            .beam_stiffness()...
            .coefficient([ diag( K_v ).' diag( K_u ).' ])...
            .relaxed_state_from_initial_condition()...
            .beam_damping()...
            .viscosity([ mu_x_ mu_y_ mu_z_ mu_xx_ mu_yy_ mu_zz_ ])...
            .power(mu_pow_)...
            .beam_internal_actuation([f_p tau_p ]) ;
        
        results = results...
            .body(['tip_force_sensor',num2str(i)])...
            .with_mass(m_f_)...
            .with_inertia(I_f)...
            .with_center_of_mass_at( [ 0 0 l_f_/2 ] )...
            .with_tip_at( [ 0 0 l_f_ ] )...
            .with_cross_section_radius(r_f_)...
            .connected_to_joint()...
            .from_body_tip(1)...
            .exload(['tip_load',num2str(i)])...
            .exerted_on_body_with_transformation(2)... % >> transformation
            .translation([0 0 l_f_])... % axial translation w.r.t. previous joint copy
            .force([ft_x_(i), ft_y_(i), ft_z_(i)])...
            .moment([taut_x_(i), taut_y_(i), taut_z_(i)])...
            .run() ;
    
    elseif user_pars.n_SRA>=2
        results =tmtdyn()...
            .simulation()...
            .variables(vars, var_vals)...
            .user_parameters(user_pars)...
            .derive_eom('full_system')... % 'full_system', 'assume_small_velocities', 'no'
            .optimize_code()...
            .analysis()...
            .static_sim('generate_mex_file', t_exp_equil)... % edited_m_file, generate_m_file, generate_mex_file, old_mex_file, generate_mex_from_edited_m_file, generate_mex_from_c_files
            .dynamic_sim('generate_m_file', 'matlab', t_exp(1), t_exp(end))... % matlab, sundials_ode, sundials_dae, radau, radau_mex, external
            .spatial_integration_step(1e1)...
            .results_sample_rate(1e2)...
            .report_time_intervals(1); % show sim progress in terminal
        
        results=results...
            .world()... % world
            .g([g_x_, g_y_, g_z_])...
            .robot(['series_rigid_link_arm_',num2str(i)])... % robot
            .body(['rigid_link',num2str(i)])...
            .with_mass(m_ss)...
            .with_inertia(I_ss)...
            .with_cross_section_radius(1/sqrt(lambda_)*r_s2_)...
            .connected_to_joint()...
            .rom()...
            .default_order(n_p)...
            .default_fit_type('polynomial')... % polynomial, spline_piecewise, spline_logistic_func
            .length(0, l_s_)...
            .fixed_inital_values()...
            .with_transformation_from_body()... % leave empty for connection to ground
            .translation([inf,inf,inf])... % axial translation w.r.t. previous joint copy
            .dof(1)...
            .base_director(0)... % perpendicular at the base
            .dof(2)...
            .base_director(0)... % perpendicular at the base
            .dof(3)...
            .base_director(1)... % perpendicular at the base
            .initial_value_axial_locations(( 1:n_p ) * l_ss)...
            .initial_value(( 1:n_p ) * l_ss)...
            .parallel_spring()...
            .relaxed_state_from_initial_condition()...
            .rot_unit_quat([inf, inf, inf])...
            .beam_stiffness()...
            .coefficient([ diag( K_v ).' diag( K_u ).' ])...
            .relaxed_state_from_initial_condition()...
            .beam_damping()...
            .viscosity([ mu_x_ mu_y_ mu_z_ mu_xx_ mu_yy_ mu_zz_ ])...
            .power(mu_pow_)...
            .beam_internal_actuation([ f_p tau_p ]) ;
        
        intm(i).results = results...
            .body(['tip_force_sensor',num2str(i)])...
            .with_mass(m_f_)...
            .with_inertia(I_f)...
            .with_center_of_mass_at( [ 0 0 l_f_/2 ] )...
            .with_tip_at( [ 0 0 l_f_ ] )...
            .with_cross_section_radius(r_f_)...
            .connected_to_joint()...
            .from_body_tip(1)...
            .exload(['tip_load',num2str(i)])...
            .exerted_on_body_with_transformation(2)... % >> transformation
            .translation([0 0 l_f_])... % axial translation w.r.t. previous joint copy
            .force([ft_x_(i), ft_y_(i), ft_z_(i)])...
            .moment([taut_x_(i), taut_y_(i), taut_z_(i)])...
            .run() ;

        if i~=user_pars.n_SRA
            close;
        end

        % The aim of the "close" is to delete the meaningless figure that
        % represents the size of animation frame, in the original code I
        % haven't managed to fulfill it to shut down related "figure"
        % function, maybe this method is not the smartest, but the most
        % efficient.
        %% And pay attention please, please do not click any other windows pop up, it will
        %% affect the utilization of "close" function, just leave the simulation running alone,
        %% please do not touch the PC until the simulation finishes.
        % 2023.01.31
        % New issue found: if we close all the "blank" figures, the
        % animation will be plotted in a new figure as well as the last one
        % in the precious subplot; and as we know, the blank figure or
        % frame is used to confirm the edge size of animation, if we don't
        % close it in the last iteration in the for loop, such issue would
        % not happen.
    end
end

if user_pars.n_SRA>=2
    % To animate all the bodies in the same frame, we must cope with the final
    % results, and put them together into just one cell rather than struct.
    fresults=cell(user_pars.n_SRA,1);
    z=cell(user_pars.n_SRA,1);
    par=cell(user_pars.n_SRA,1);
    for i=1:user_pars.n_SRA
        fresults{i,1}=intm(i).results;
        z{i,1}=fresults{i,1}.z;
        par{i,1}=fresults{i,1}.par;
    end
    t=fresults{1,1}.t;
    save('results/fresults.mat');

    %% Animation process for n_SRA>=2

    anim_switch=1; % 0=off, 1=on.

    if anim_switch==1
        for i=1:user_pars.n_SRA
            par{i,1}.anim=1;
            par{i,1}.anim_frame=1;
            % The following parameter is very important, on and off of the
            % anim_line is to control whether we are going to plot the body
            % of SRA or just the central line (backbone).
            % 0=just show the central line;
            % 1=show the body.
            par{i,1}.anim_line=1;
            par{i,1}.movie=1;
        end
        addpath('./tmtdyn');
        [ r_anim , rjtip , rks , Qjtip , Qks , par ] = anim( t , z , par );
    end

    %% Post processing for n_SRA>=2
    
    for i=1:fresults{1,1}.par.user_pars.n_SRA
        t_equil{i,1}=fresults{i,1}.t_equil;
        z_equil{i,1}=fresults{i,1}.z_equil;
        rjtip{i,1}=fresults{i,1}.rjtip;
        rjtip_equil{i,1}=fresults{i,1}.rjtip_equil;
        Qjtip_all{i,1}=fresults{i,1}.Qjtip;
        Qjtip_equil_all{i,1}=fresults{i,1}.Qjtip_equil;
        Phi_modal{i,1}=fresults{i,1}.Phi_modal;
        M_modal{i,1}=fresults{i,1}.M_modal;
        K_modal{i,1}=fresults{i,1}.K_modal;
        V_modal{i,1}=fresults{i,1}.V_modal;
        omega{i,1}=fresults{i,1}.omega;
        xi{i,1}=fresults{i,1}.xi;
    end
    addpath('./eom');
    par=post_proc(t,...
        t_equil,z,z_equil,...
        rjtip,...
        rjtip_equil,Qjtip_all,Qjtip_equil_all,Phi_modal,M_modal,K_modal,V_modal,omega,xi,...
        par);
end


