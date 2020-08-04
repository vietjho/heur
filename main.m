function main
clc
clear vars
clear all
close all
%
n = 100; %the size of SMTI instances
k = 50;  %the number of instances has the same (n,p1,p2)
for alg = 1 %1:3
    for p1 = 0.8 %0.1:0.1:0.8 %0.5 for n = 1200
        for p2 = 0.5:0.1:1.0
            f_results= [];
            i = 1;
            while (i <= k)
                %load the preference matrices and the matching from file
                filename1 = ['input100\I(',num2str(n),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),')-',num2str(i),'.mat'];
                load(filename1,'men_rank_list','women_rank_list','M');
                %run algorithms
                if (alg == 1)                    
                    [f_time,f_cost,f_stable,f_iter,f_reset,f_nbps] = MCS(men_rank_list,women_rank_list,M);
                end
                if (alg == 2)
                    [f_time,f_cost,f_stable,f_iter,f_reset] = AS(men_rank_list,women_rank_list,M);
                end
                if (alg == 3)
                    [f_time,f_cost,f_stable,f_iter,f_reset] = LTIU(men_rank_list,women_rank_list,M);
                end
                %
                f_results = [f_results; f_time,f_cost,f_stable,f_iter,f_reset];
                %
                fprintf('\nI(%d,%0.1f,%0.1f)-%d: time = %3.3f, f(M)=%d, stable=%d, iters=%d, reset=%d',n,p1,p2,i,f_time,f_cost,f_stable,f_iter,f_reset);
                %
                %save number of undominated blocking pair 
                %filename2 = ['ubps900\MCS(',num2str(n),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),')-',num2str(i),'.mat'];
                %save(filename2,'f_nbps');
                %
                i = i + 1;
            end
            %
            %save to file for averaging results
            if (alg == 1)
                filename3 = ['output100\MCS(',num2str(n),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];
                save(filename3,'f_results');
            end
            if (alg == 2)
                filename3 = ['output500\AS(',num2str(n),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];
                %save(filename3,'f_results');
            end
            if (alg == 3)
                filename3 = ['output100\LTIU(',num2str(n),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];
                %save(filename3,'f_results');
            end
        end
    end
end
end
%==========================================================================