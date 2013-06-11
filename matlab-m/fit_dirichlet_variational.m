function alpha = fit_dirichlet_variational(alpha, data,symmetric,beta)
%
% function alpha = fit_dirichlet_variational(data)
%
% Use linear time Newton-Raphson algorithm to fit a Dirichlet to Dirichlet estimates of samples.
% See Blei, Ng & Jordan, JMLR, 2003.
%
% J.J. Verbeek, INRIA Rhone-Alpes, 2006.
%

done = 0;
iter = 0;

k = length(alpha);

if nargin<4; beta = 0;end % inverse variance of gaussian prior on parameters 

alpha = max(alpha,1e-10);

while ~done; iter = iter + 1;

    alpha_sum = sum(alpha);

        f =  -beta*alpha'*alpha + gammaln( alpha_sum ) -  sum( gammaln( alpha ) ) + (alpha - 1)' * data ;
        g =  -beta*alpha + digamma( alpha_sum ) -       digamma( alpha )	+ data;

	if symmetric;
		g   = sum(g);
		h   = k^2 * trigamma(alpha_sum) - k * trigamma( alpha_sum / k );
		HiG = g/h;
		a   = (alpha_sum/k)./HiG(HiG>0); 
	else
		z   =   trigamma( alpha_sum );
		h   = - trigamma(alpha) - beta;
        hi  = h.^-1;
        c1  = z*(g'*hi);
        c3  = 1 + z*sum(hi);
        if c3==0; keyboard;end
		c2  = c1 ./ c3; 
		HiG = (g - c2) ./ h;
	    a   = alpha(HiG>0)./HiG(HiG>0);
    end
        a       = min([ a*.9; 1]); % prevent overshoot to negative values, can happen with very large gradient when including new observations.
    	alpha   = alpha - a*HiG;

    	if iter >1; if abs(f-f_old)/abs(f) < 1e-5; done =1;end;end
    	f_old = f;
end
alpha = max(alpha,1e-10);