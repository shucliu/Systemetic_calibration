function [ox]=trans_param(para,paraname,parameters)
% Transform values back to original parameter values
orirange={parameters.orirange};
switch paraname 
	case 'qi0'
		i=1;
		a = 1e8; b = 2.50e1;
	case 'tur_len'
		i=2;
		a = 1e8; b = 1.01e6;
	case 'clc_diag'
		i=3;
		a = 1e8; b = 6e7;
	case 'rat_sea'
		i=4;
		a = 1e8; b = 5.98e6;
	case 'cloud_num'
		i=5;
		a = 1e8; b = 2.43e9;
	case 'uc1'
		i=6;
		a = 1e8; b = 1.66e5;
end;		

xn = orirange{i}(1); xx = orirange{i}(2);
if a == 0
	ox = para;
else
	ox = round((10.^para-b)/a.*(xx-xn)+xn,3,'significant');
end;
