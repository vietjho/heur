%======================================================================================
%By Hoang Huu Viet
%reference: Ian Philip Gent, Patrick Prosser. An Empirical Study of the Stable Marriage Problem with
%Ties and Incomplete Lists
%======================================================================================
function SMTIGenerator()
clc
clear vars
clear all
close all
%
n = 20;% 1200; %the size of SMTI instances
k = 1;%50;  %the number of instances has the same (n,p1,p2)
for p1 = 0.5 %; 0.1:0.1:0.8
    for p2 = 0.0:0.1:1.0
        i = 1;
        while (i <= k)
            A = rand(n,n);
            B = rand(n,n);
            %generate men's and women's preference lists
            [~,men_pref_list] = sort(A,2);
            [~,women_pref_list] = sort(B,2);
            %generate an SMTI instance
            [f,men_rank_list,women_rank_list] = Generator(men_pref_list,women_pref_list,p1,p2);
            %
            if (f == true) 
                %create a random matching
                M = make_random_matching(men_rank_list,women_rank_list,n);
                %
                %save preference matrices and the matching to file
                filename = ['tests\I(',num2str(n),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),')-',num2str(i),'.mat'];
                save(filename,'men_rank_list','women_rank_list','M');
                %men_pref_list
                %men_rank_list
                %
                %women_pref_list
                %women_rank_list
                i = i + 1;
            end
        end
    end
end
end
%============================================================================================
function [f,men_rank_list,women_rank_list] = Generator(men_pref_list,women_pref_list,p1,p2)
% size of the comleted instance
n = size(men_pref_list,1);
%
%1. generate an instance of stable marriage problem with incomplete lists
%
%generate randomly using a probability 
for i = 1:n
    %r -rank
    for r1 = 1:n
        if (rand() <= p1)
            %delete woman j from man i's list
            j = men_pref_list(i,r1);
            men_pref_list(i,r1) = 0;
            %delete man i from woman j's list
            r2 = find(women_pref_list(j,:) == i);
            women_pref_list(j,r2) = 0;
        end
    end
    %
end
%
%2. generate an instance of stable marriage problem with ties
%
men_rank_list   = zeros(n,n);
women_rank_list = zeros(n,n);
%if any man or woman has an empty preference list, discard the instance
f = true;
for i = 1:n
    if (~any(men_pref_list(i,:))) || (~any(women_pref_list(i,:)))
        f = false;
        return;
    end
end
%
%generate randomly using a probability 
for i = 1:n
    %
    idx = find(men_pref_list(i,:) ~=0,1,'first');
    men_rank_list(i,men_pref_list(i,idx)) = 1;
    cj = 1;
    for j = idx+1:n
        if (men_pref_list(i,j) > 0)
            if (rand() >= p2)
                cj = cj + 1;
            end
            men_rank_list(i,men_pref_list(i,j)) = cj;
        end
    end
    %
    idx = find(women_pref_list(i,:) ~=0,1,'first');
    women_rank_list(i,women_pref_list(i,idx)) = 1;
    cj = 1;
    for j = idx+1:n
        if (women_pref_list(i,j) > 0)
            if (rand() >= p2)
                cj = cj + 1;
            end
            women_rank_list(i,women_pref_list(i,j)) = cj;
        end
    end
    %
end
end
%==========================================================================