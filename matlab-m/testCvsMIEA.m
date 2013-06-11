st=1/s/t;
miesc = zeros(10, 10);
for cor = 0.1 : 0.1 : 0.9
    if (cor == 0)
        Agt = ones(s, t) * st;
    else
        ng = (1/st-1);
        BA = (ng / ((cor^2 * st) * (1 + ng)^2) - 1) / (1 + ng);
        for loop = 1 : 100
            while 1,
                Agt = betarnd(BA, ng * BA, [s t]);
                if (abs(sum(Agt(:)) - 1) < 1e-4), break; end;
                miesc(int32(cor*10),loop) = mutualinfo(Agt);
            end;
        end;
    end;
end;