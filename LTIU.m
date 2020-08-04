function [f_time,f_cost,f_stable,f_iter,f_reset]= LTIU(men_rank_list,women_rank_list,M)
%==========================================================================
% By Hoang Huu Viet
% LTIU algorithm
% reference: M. Gelain, M. S. Pini, F. Rossi, K. B. Venable1, T. Wals
% Local search for stable marriage problems with ties and incomplete lists
%==========================================================================
%
n = size(men_rank_list,1);
f = find_cost_of_matching(men_rank_list,women_rank_list,M);
%
%initialize the best matching
M_best = M;
f_best = f;
f_stable = 0;
%
p = 0.05;
MAX_ITERS = 3000;
num_reset = 0;
iter = 0;
tic
while (iter <= MAX_ITERS)
    iter = iter + 1;
    %if a perfect matching is found
    if (f_best == 0) && (f_stable ==1)
        break;
    end
    %swap the role of men and women at iterations
    if (mod(iter,2) == 1)
        X = find_undominated_blocking_pairs1(men_rank_list,women_rank_list,M);
    else
        X = find_undominated_blocking_pairs2(men_rank_list,women_rank_list,M);
    end
    %check if the undominated blocking pairs of M is empty, i.e. M is stable
    if (isempty(X))
        f_stable = 1;
        if (f_best > f)
            M_best = M;
            f_best = f;
        end
        %perform a random restart
        if (f_best > 0)
           num_reset = num_reset + 1;
           M = make_random_matching(men_rank_list,women_rank_list,n);
           f = find_cost_of_matching(men_rank_list,women_rank_list,M);
        end
        continue;
    end
    %find the neighbor set of matching M
    neighbors = {};  
    f_cost = [];
    for i = 1:size(X,1)
        %take undominated blocking pair (mi,wj)     
        mi = X(i,1);
        wi = X(i,2);
        mj = X(i,3);
        wj = X(i,4);
        %
        %remove undominated blocking pair (mi,wj) in M to obtain a neighbor
        M_child = M;
        %find the position of man mi in M_child(1,:)
        mi_idx = find(M_child(1,:) == mi,1,'first');
        %find the position of woman wj in M_child(2,:)
        wj_idx = find(M_child(2,:) == wj,1,'first'); 
        %mi is married with wj
        M_child(2,mi_idx) = wj;
        %mj become single
        M_child(2,wj_idx) = 0;
        %wi become single
        wi_idx = find((M_child(1,:)==0) & (M_child(2,:)==0),1,'first'); 
        M_child(2,wi_idx) = wi;
        %
        %remember a neighbor matching
        neighbors{end+1} = M_child;
        %
        %find the cost after removing undominated blocking pair (mi,wj)
        f = find_cost_of_matching(men_rank_list,women_rank_list,M_child);
        f_cost(end+1) = f;
    end
    %
    if (rand() < p)
        %random walk
        idx = randi(size(f_cost,2),1,1);
    else
        %find the matching with the minnimum cost
        [~,idx] = min(f_cost); 
    end
    %take the best neighbor matching or random walk
    M = neighbors{idx};
    f = find_cost_of_matching(men_rank_list,women_rank_list,M);
end
f_time = toc;
f_cost = f_best;
f_iter = iter;
f_reset = num_reset;
%
%verify the result matching
%verify_result_matching(men_rank_list,women_rank_list,M_best);
end
%==========================================================================
%find undominated blocking pairs from men's point of view
%==========================================================================
function [X] = find_undominated_blocking_pairs1(men_rank_list,women_rank_list,M)
%X: a set of undominated blocking pairs in M from men's point of view
%
n = size(men_rank_list,1);
X = [];
for i = 1:size(M,2)
    mi = M(1,i);
    if (mi == 0) 
        continue;
    end
    wi = M(2,i);
    %
    if (wi > 0)
        mr_wi = men_rank_list(mi,wi);
    else
        mr_wi = n+1;
    end
    %find an undominated blocking pair (mi,wj)
    x = men_rank_list(mi,:);
    [mi_rank_list,idx] = sort(x); 
    for j = 1:n
        mr_wj = mi_rank_list(j);
        if (mr_wj > 0) && (mr_wj < mr_wi)
            wj = idx(j);
            wj_idx = find(M(2,:) == wj,1,'first');
            mj = M(1,wj_idx);
            if (check_blocking_pair(men_rank_list,women_rank_list,mi,wi,mj,wj) == true)               
                %add (mi,wi), (mj,wj), where (mi,wj) is an undominated blocking pair
                X(end+1,:) = [mi,wi,mj,wj];
                break;
            end
        end
    end
end
end
%==========================================================================
%find undominated blocking pairs from women's point of view
%==========================================================================
function [X] = find_undominated_blocking_pairs2(men_rank_list,women_rank_list,M)
%X: a set of undominated blocking pairs in M from women's point of view
%
n = size(women_rank_list,1);
X = [];
for j = 1:size(M,2)
    wj = M(2,j);
    if (wj == 0) 
        continue;
    end
    mj = M(1,j);
    %
    if (mj > 0)
        wr_mj = women_rank_list(wj,mj);
    else
        wr_mj = n+1;
    end
    %find an undominated blocking pair (mi,wj)
    x = women_rank_list(wj,:);
    [wj_rank_list,idx] = sort(x); 
    for i = 1:n
        wr_mi = wj_rank_list(i);
        if (wr_mi > 0) && (wr_mi < wr_mj)
            mi = idx(i);
            mi_idx = find(M(1,:) == mi,1,'first');
            wi = M(2,mi_idx);
            if (check_blocking_pair(men_rank_list,women_rank_list,mi,wi,mj,wj) == true)               
                %add (mi,wi), (mj,wj), where (mi,wj) is an undominated blocking pair
                X(end+1,:) = [mi,wi,mj,wj];
                break;
            end
        end
    end
end
end
%==========================================================================
%find the cost of a matching M
%==========================================================================
function [f] = find_cost_of_matching(men_rank_list,women_rank_list,M)
%f = #nbp + #nsg
%
nbp = 0;
nsg = 0;
for i = 1:size(M,2)
    mi = M(1,i);
    if (mi == 0) 
        continue;
    end
    %count the number of blocking pairs in M
    wi = M(2,i);
    check_bp = false;
    for j = 1:size(M,2)
        mj = M(1,j);
        wj = M(2,j);
        if (wj == 0)
            continue;
        end
        if (check_blocking_pair(men_rank_list,women_rank_list,mi,wi,mj,wj) == true)
            %count the number of blocking pairs (mi,wj)
            nbp = nbp + 1;
            check_bp = true;
        end
    end
    %count the number of singles in M which are not in any blocking pairs
    if ((check_bp == false) && (wi == 0))
        nsg = nsg + 1;
    end
end
f = nbp + nsg;
end
%==========================================================================