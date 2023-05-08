function [out1,out2,out3,out4] = massF1(in1,in2,s,ds,t_sym)
%massF1
%    [OUT1,OUT2,OUT3,OUT4] = massF1(IN1,IN2,S,DS,T_SYM)

%    This function was generated by the Symbolic Math Toolbox version 9.1.
%    07-Mar-2023 03:42:23

g_x_ = in1(:,13);
g_y_ = in1(:,14);
g_z_ = in1(:,15);
gamma_ = in1(:,21);
lambda_ = in1(:,34);
q4 = in2(4,:);
q5 = in2(5,:);
q6 = in2(6,:);
q7 = in2(7,:);
q8 = in2(8,:);
q9 = in2(9,:);
r_p1_ = in1(:,19);
r_s1_ = in1(:,3);
r_s2_ = in1(:,4);
sigma_s_ = in1(:,1);
u4 = in2(13,:);
u5 = in2(14,:);
u6 = in2(15,:);
u7 = in2(16,:);
u8 = in2(17,:);
u9 = in2(18,:);
t2 = cos(gamma_);
t3 = sin(gamma_);
t4 = q4.*s;
t5 = q6.*s;
t6 = q8.*s;
t7 = lambda_.^2;
t8 = r_p1_.^2;
t9 = r_s1_.^2;
t10 = r_s2_.^2;
t11 = s.^2;
t12 = s.^3;
t18 = 1.0./lambda_;
t13 = t11.^2;
t14 = t2.^2;
t15 = t4.*2.0;
t16 = t5.*2.0;
t17 = t6.*2.0;
t19 = t8.*6.0;
t20 = t11.*2.0;
t21 = t12.*2.0;
t23 = 1.0./t3.^2;
t24 = q5.*t11;
t25 = q7.*t11;
t26 = q9.*t11;
t27 = -t9;
t28 = -t10;
t32 = t9./4.0;
t33 = t10./4.0;
t22 = t13.*2.0;
t29 = q5.*t20;
t30 = q7.*t20;
t31 = q9.*t20;
t34 = t7.*t14;
t35 = t4+t24;
t36 = t5+t25;
t37 = t6+t26;
t54 = t9+t19+t28;
t55 = t32+t33;
t38 = t15+t29;
t39 = t16+t30;
t40 = t17+t31;
t41 = t35.^2;
t42 = t36.^2;
t43 = t37.^2;
t44 = t34-1.0;
t56 = sigma_s_.*t54.*pi;
t45 = s.*t38;
t46 = s.*t39;
t47 = s.*t40;
t48 = -t41;
t49 = -t42;
t50 = -t43;
t51 = t11.*t38;
t52 = t11.*t39;
t53 = t11.*t40;
t57 = -t56;
t58 = t19.*t23.*t44;
t59 = t10+t27+t58;
t60 = t48+t49+t50+1.0;
t61 = sqrt(complex(t60));
t65 = sigma_s_.*t18.*t55.*t59.*pi;
out1 = reshape([t57,0.0,0.0,0.0,0.0,0.0,0.0,t57,0.0,0.0,0.0,0.0,0.0,0.0,t57,0.0,0.0,0.0,0.0,0.0,0.0,t65,0.0,0.0,0.0,0.0,0.0,0.0,t65,0.0,0.0,0.0,0.0,0.0,0.0,sigma_s_.*t18.*t59.*pi.*(t9./2.0+t10./2.0)],[6,6]);
if nargout > 1
    t62 = 1.0./t61;
    t64 = s.*t61.*2.0;
    t66 = t20.*t61;
    t63 = t62.^3;
    t67 = t20.*t35.*t62;
    t68 = t21.*t35.*t62;
    t69 = t22.*t35.*t62;
    t70 = t20.*t36.*t62;
    t71 = t21.*t36.*t62;
    t72 = t22.*t36.*t62;
    t73 = t20.*t37.*t62;
    t74 = t21.*t37.*t62;
    t75 = t22.*t37.*t62;
    t76 = t51.*t62;
    t77 = t12.*t38.*t62;
    t78 = t13.*t38.*t62;
    t79 = t52.*t62;
    t80 = t12.*t39.*t62;
    t81 = t13.*t39.*t62;
    t82 = t53.*t62;
    out2 = reshape([t11,0.0,0.0,0.0,0.0,0.0,0.0,t11,0.0,0.0,0.0,0.0,0.0,0.0,t11,0.0,0.0,0.0,0.0,0.0,0.0,t64+t35.*t45.*t62,-t47+t35.*t46.*t62,t46+t35.*t47.*t62,0.0,0.0,0.0,t66+t35.*t76,-t53+t35.*t79,t52+t35.*t82,0.0,0.0,0.0,t47+t36.*t45.*t62,t64+t36.*t46.*t62,-t45+t36.*t47.*t62,0.0,0.0,0.0,t53+t36.*t76,t66+t36.*t79,-t51+t36.*t82,0.0,0.0,0.0,-t46+t37.*t45.*t62,t45+t37.*t46.*t62,t64+t37.*t47.*t62,0.0,0.0,0.0,-t52+t37.*t76,t51+t37.*t79,t66+t37.*t82],[6,9]);
end
if nargout > 2
    t83 = t12.*t40.*t62;
    t84 = t13.*t40.*t62;
    t85 = t12.*t38.*t41.*t63;
    t86 = t12.*t39.*t41.*t63;
    t87 = t12.*t38.*t42.*t63;
    t88 = t12.*t38.*t43.*t63;
    t89 = t12.*t40.*t41.*t63;
    t90 = t12.*t39.*t42.*t63;
    t91 = t12.*t40.*t42.*t63;
    t92 = t12.*t39.*t43.*t63;
    t93 = t12.*t40.*t43.*t63;
    t94 = t35.*t36.*t51.*t63;
    t95 = t12.*t35.*t36.*t38.*t63;
    t96 = t13.*t35.*t36.*t38.*t63;
    t97 = t35.*t36.*t52.*t63;
    t98 = t35.*t37.*t51.*t63;
    t99 = t12.*t35.*t36.*t39.*t63;
    t100 = t12.*t35.*t37.*t38.*t63;
    t101 = t13.*t35.*t36.*t39.*t63;
    t102 = t13.*t35.*t37.*t38.*t63;
    t103 = t35.*t36.*t53.*t63;
    t104 = t35.*t37.*t52.*t63;
    t105 = t36.*t37.*t51.*t63;
    t106 = t12.*t35.*t36.*t40.*t63;
    t107 = t12.*t35.*t37.*t39.*t63;
    t108 = t12.*t36.*t37.*t38.*t63;
    t109 = t13.*t35.*t36.*t40.*t63;
    t110 = t13.*t35.*t37.*t39.*t63;
    t111 = t13.*t36.*t37.*t38.*t63;
    t112 = t35.*t37.*t53.*t63;
    t113 = t36.*t37.*t52.*t63;
    t114 = t12.*t35.*t37.*t40.*t63;
    t115 = t12.*t36.*t37.*t39.*t63;
    t116 = t13.*t35.*t37.*t40.*t63;
    t117 = t13.*t36.*t37.*t39.*t63;
    t118 = t36.*t37.*t53.*t63;
    t119 = t12.*t36.*t37.*t40.*t63;
    t120 = t13.*t36.*t37.*t40.*t63;
    t121 = -t95;
    t122 = -t99;
    t123 = -t100;
    t124 = -t106;
    t125 = -t107;
    t126 = -t108;
    t127 = -t114;
    t128 = -t115;
    t129 = -t119;
    t130 = t21+t106;
    t131 = t21+t107;
    t132 = t21+t108;
    t136 = t77+t85;
    t137 = t77+t87;
    t138 = t77+t88;
    t139 = t80+t86;
    t140 = t80+t90;
    t141 = t80+t92;
    t142 = t83+t89;
    t143 = t83+t91;
    t144 = t83+t93;
    t145 = t68+t99;
    t146 = t71+t95;
    t147 = t68+t114;
    t148 = t74+t100;
    t149 = t71+t119;
    t150 = t74+t115;
    t133 = t21+t124;
    t134 = t21+t125;
    t135 = t21+t126;
    t151 = t68+t122;
    t152 = t71+t121;
    t153 = t68+t127;
    t154 = t74+t123;
    t155 = t71+t129;
    t156 = t74+t128;
    mt1 = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,u6.*(t70+t94)+u8.*(t73+t98)+t136.*u5+t146.*u7+t148.*u9+u4.*(t76+t41.*t51.*t63),u8.*(t20+t104)+t131.*u9+t139.*u5-t151.*u7+u4.*(t79+t41.*t52.*t63)-u6.*(t67-t97),-t133.*u7+t142.*u5-t153.*u9+u4.*(t82+t41.*t53.*t63)-u6.*(t20-t103)-u8.*(t67-t112),0.0,0.0,0.0,u7.*(t72+t96)+u9.*(t75+t102)+t136.*u4+t146.*u6+t148.*u8+u5.*(t78+t13.*t38.*t41.*t63),u9.*(t22+t110)+t131.*u8+t139.*u4-t151.*u6-u7.*(t69-t101)+u5.*(t81+t13.*t39.*t41.*t63)];
    mt2 = [-t133.*u6+t142.*u4-t153.*u8-u7.*(t22-t109)-u9.*(t69-t116)+u5.*(t84+t13.*t40.*t41.*t63),0.0,0.0,0.0,-t135.*u9+t137.*u7-t152.*u5+u6.*(t76+t42.*t51.*t63)-u8.*(t20-t105)-u4.*(t70-t94),u4.*(t67+t97)+u8.*(t73+t113)+t140.*u7+t145.*u5+t150.*u9+u6.*(t79+t42.*t52.*t63),u4.*(t20+t103)+t130.*u5+t143.*u7-t155.*u9+u6.*(t82+t42.*t53.*t63)-u8.*(t70-t118),0.0,0.0,0.0,-t135.*u8+t137.*u6-t152.*u4-u9.*(t22-t111)-u5.*(t72-t96)+u7.*(t78+t13.*t38.*t42.*t63)];
    mt3 = [u5.*(t69+t101)+u9.*(t75+t117)+t140.*u6+t145.*u4+t150.*u8+u7.*(t81+t13.*t39.*t42.*t63),u5.*(t22+t109)+t130.*u4+t143.*u6-t155.*u8-u9.*(t72-t120)+u7.*(t84+t13.*t40.*t42.*t63),0.0,0.0,0.0,u6.*(t20+t105)+t132.*u7+t138.*u9-t154.*u5+u8.*(t76+t43.*t51.*t63)-u4.*(t73-t98),-t134.*u5+t141.*u9-t156.*u7+u8.*(t79+t43.*t52.*t63)-u4.*(t20-t104)-u6.*(t73-t113),u4.*(t67+t112)+u6.*(t70+t118)+t147.*u5+t144.*u9+t149.*u7+u8.*(t82+t43.*t53.*t63),0.0,0.0,0.0];
    mt4 = [u7.*(t22+t111)+t132.*u6+t138.*u8-t154.*u4-u5.*(t75-t102)+u9.*(t78+t13.*t38.*t43.*t63),-t134.*u4+t141.*u8-t156.*u6-u5.*(t22-t110)-u7.*(t75-t117)+u9.*(t81+t13.*t39.*t43.*t63),u5.*(t69+t116)+u7.*(t72+t120)+t147.*u4+t144.*u8+t149.*u6+u9.*(t84+t13.*t40.*t43.*t63)];
    out3 = reshape([mt1,mt2,mt3,mt4],6,9);
end
if nargout > 3
    out4 = [g_x_;g_y_;g_z_;0.0;0.0;0.0];
end
