clc
clear vars
clear all
close all
%
 
 %filename2 = ['examples\M8-1.mat'];
 %load(filename2,'M');
 
 men_rank_list = [1     0     0     0     0     0     0     0;
                  0     0     2     2     1     2     3     3;
                  0     2     0     1     2     0     0     0;
                  0     0     0     0     1     1     3     2;
                  1     3     1     2     2     0     0     0;
                  2     3     3     1     0     0     1     3;
                  0     0     3     1     3     2     3     0;
                  0     0     3     0     1     2     0     0];
 %
 women_rank_list = [1     0     0     0     2     2     0     0;
                    0     0     1     0     1     1     0     0;
                    0     4     0     0     3     1     2     2;
                    0     2     1     0     3     2     2     0;
                    0     3     2     2     1     0     1     1;
                    0     1     0     3     0     0     2     3;
                    0     1     0     3     0     1     2     0;
                    0     1     0     1     0     2     0     0];
 
 n = size(men_rank_list,1);
%[M] = make_random_matching(men_rank_list,women_rank_list,n)
%
M = [1 2 3 4 5 6 7 8 0  0  0  0  0  0  0  0;
     1 6 4 8 0 2 7 0 3  5  0  0  0  0  0  0]
%X = [(2,5),(4,5),(5,3),(6,7),(8,5)
%
%if remove (2,5)
%M = [1 2 3 4 5 6 7 8 0  0  0  0  0  0  0  0;
%     1 5 4 8 0 2 7 0 3  6  0  0  0  0  0  0]
%
%if remove (4,5)
%M = [1 2 3 4 5 6 7 8 0  0  0  0  0  0  0  0;
%     1 6 4 5 0 2 7 0 3  8  0  0  0  0  0  0]
%
%if remove (5,3)
%M = [1 2 3 4 5 6 7 8 0  0  0  0  0  0  0  0;
%     1 6 4 8 3 2 7 0 0  5  0  0  0  0  0  0]
%if remove (6,7) 
%M = [1 2 3 4 5 6 7 8 0  0  0  0  0  0  0  0;
%     1 6 4 8 0 7 0 0 3  5  2  0  0  0  0  0]
    
 %[f,nbp,nsg,BPs] = number_of_blocking_pairs(men_rank_list,women_rank_list,M);
 %
%[f_time,f_cost,f_stable,f_iter,f_reset] = MCS(men_rank_list,women_rank_list,M);
[f_time,f_cost,f_stable,f_iter,f_reset] = AS(men_rank_list,women_rank_list,M);
f_iter
f_reset
 
 