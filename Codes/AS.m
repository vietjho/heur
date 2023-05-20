function [f_time,f_cost,f_stable,f_iter,f_reset]= AS(men_rank_list,women_rank_list,M)
%==========================================================================
% Coded by Hoang Huu Viet
% AS algorithm
% reference: Danny Munera, Daniel Diaz, Salvador Abreu, Francesca Rossi
% Solving Hard Stable Matching Problems 
% via Local Search and Cooperative Parallelization
%==========================================================================
%
n = size(men_rank_list,1);
f = cost_of_marriage(men_rank_list,women_rank_list,M);
%
%initialize the best matching
M_best = M;
f_best = f;
f_stable = 0;
%
p = 0.98;
MAX_ITERS = 3000;
num_reset = 0;
iter = 0;
tic
while (iter <= MAX_ITERS)
    iter = iter + 1;
    %
    %evaluate the current matching
    [f,~,~,blocking_pairs] = cost_of_marriage(men_rank_list,women_rank_list,M);    
    %
    %check if M is stable matching
    if (f < n)
        f_stable = 1;
        if (f_best > f)
            M_best = M;
            f_best = f;
        end
        %check if a perfect matching is found, ends
        if (f_best == 0)
            break;
        end
        %reset the best stable matching
        if (f_best > 0)
            num_reset = num_reset + 1;
            M = reset(men_rank_list,women_rank_list,M,p);
        end
        continue;
    end
    %
    %fix the worst variable to move a new configuration
    [~,idx] = max(blocking_pairs(:,5));
    mi = blocking_pairs(idx,1);
    wi = blocking_pairs(idx,2);
    mj = blocking_pairs(idx,3);
    wj = blocking_pairs(idx,4);
    %
    %find the position of man mi in M(1,:)
    mi_idx = find(M(1,:) == mi,1,'first');
    %find the position of woman wj in M(2,:)
    wj_idx = find(M(2,:) == wj,1,'first');
    %mi is married with wj
    M(2,mi_idx) = wj;
    %mj become single
    M(2,wj_idx) = 0;
    %wi become single
    wi_idx = find((M(1,:)==0) & (M(2,:)==0),1,'first'); 
    M(2,wi_idx) = wi;
    %
    %re-evaluate the cost of the resulting matching
    %
    f_last = f;
    [f,~] = cost_of_marriage(men_rank_list,women_rank_list,M);
    if (f >= f_last)
        %invoke a reset procedure to alter the current configuration
        num_reset = num_reset + 1;
        M = reset(men_rank_list,women_rank_list,M,p);
    end
end
f_time = toc;
f_cost = f_best;
f_iter = iter;
f_reset = num_reset;
%verify the result matching
%verify_result_matching(men_rank_list,women_rank_list,M_best);
end
%==========================================================================
function [f] = blocking_pair_error(women_rank_list,mj,wj,mi)
%input: (mj,wj) belongs matching M and a man m who prefers wj to his partner
%output: if (mi,wj) is a BP, return > 0 else return 0
%
%wj is single, i.e., mj = 0: BP
if (mj == 0)
    f = 1;
    return;
end
wr_mj = women_rank_list(wj,mj);
wr_mi = women_rank_list(wj,mi);
%mi is not in wj's preference list: not a BP
if (wr_mi == 0)
    f = 0;
    return;
end
%return max meaning wj most prefers mi to the other man 
f = max(0,wr_mj - wr_mi);
end
%==========================================================================
function [f,nbp,nsg,blocking_pairs] = cost_of_marriage(men_rank_list,women_rank_list,M)
%function to evaluate a matching
n = size(men_rank_list,1);
nbp = 0;
nsg = 0;
blocking_pairs = [];
%
for i = 1:size(M,2)
    mi = M(1,i);
    %check wi is single
    if (mi == 0) 
        continue;
    end
    %count the number of blocking pairs in M
    wi = M(2,i);
    check_bp = false;
    %
    if (wi > 0)
        mr_wi = men_rank_list(mi,wi);
    else
        mr_wi = n+1;
    end
    %for all wj in mi's preference list with rank < mr(mi,wi)
    x = men_rank_list(mi,:);
    [mi_rank_list,idx] = sort(x); 
    for j = 1:n
        mr_wj = mi_rank_list(j);
        if (mr_wj > 0) && (mr_wj < mr_wi)
            wj = idx(j);
            wj_idx = find(M(2,:) == wj,1,'first');
            mj = M(1,wj_idx);
            %
            if (check_blocking_pair(men_rank_list,women_rank_list,mi,wi,mj,wj) == true)
                error_mi = blocking_pair_error(women_rank_list,mj,wj,mi);
                if (error_mi > 0)
                    nbp = nbp + 1;
                    %add error_mi to the last columns of blocking_pairs
                    blocking_pairs(end+1,:) = [mi,wi,mj,wj,error_mi];
                    check_bp = true;
                    break;
                end
            end           
        end
    end
    %
    %count the number of singles which are not in blocking pairs
    if (check_bp == false) && (wi == 0)
        nsg = nsg + 1;
    end
end
%cost of matching M
f = nbp*n + nsg;
end
%==========================================================================
function [M] = reset(men_rank_list,women_rank_list,M,p)
[~,nbp,nsg,blocking_pairs] = cost_of_marriage(men_rank_list,women_rank_list,M);
%
%check for the number of blocking pairs
if (nbp >= 1)
    %
    %find the first worst variable
    [~,idx1] = max(blocking_pairs(:,5));
    %
    mi = blocking_pairs(idx1,1);
    wi = blocking_pairs(idx1,2);
    mj = blocking_pairs(idx1,3);
    wj = blocking_pairs(idx1,4);
    %
    %find the second worst variable
    rows = find((blocking_pairs(:,1) == mi)&(blocking_pairs(:,3) == mj)&(blocking_pairs(:,4) == wj));
    blocking_pairs(rows,5) = 0;
    [~,idx2] = max(blocking_pairs(:,5));
    %
    %swap Xm and Xm', i.e. swap (mi,wi) and (mj,wj)    
    %
    %find the position of pair (mi,wi) in M
    mi_idx = find((M(1,:) == mi) & (M(2,:) == wi),1,'first');
    %find the position of pair (mj,wj) in M
    wj_idx = find((M(1,:) == mj) & (M(2,:) == wj),1,'first');
    %
    %mi is married with wj
    M(2,mi_idx) = wj;
    %mj become single
    M(2,wj_idx) = 0;
    %wi become single
    wi_idx = find((M(1,:)==0) & (M(2,:)==0),1,'first'); 
    M(2,wi_idx) = wi;
    %
    %fix the second worst variable with a probability p
    if (nbp >=2) && (rand() <=p)
        %
        mi = blocking_pairs(idx2,1);
        wi = blocking_pairs(idx2,2);
        mj = blocking_pairs(idx2,3);
        wj = blocking_pairs(idx2,4);
        %
        %swap Xm and Xm', i.e. swap (mi,wi) and (mj,wj)    
        %
        %M is change when #BP >=1, but blocking_pairs are not changed
        %so we have to find the position of pair (mi,wi) in M
        mi_idx = find((M(1,:) == mi) & (M(2,:) == wi),1,'first');
        %
        %find the position of pair (mj,wj) in M
        wj_idx = find((M(1,:) == mj) & (M(2,:) == wj),1,'first');
        %
        if (~isempty(mi_idx) && ~isempty(wj_idx))
            %mi is married with wj to remove blocking pair (mi,wj)
            M(2,mi_idx) = wj;
            %mj become single
            M(2,wj_idx) = 0;
            %wi become single
            wi_idx = find((M(1,:)==0) & (M(2,:)==0),1,'first'); 
            M(2,wi_idx) = wi;
        end
        return;
    end
end
%
%check for the number of singles
if (nsg >= 1)
    %there are at least a single man and a single woman
    %
    %find the positions of the single men
    idxm = find((M(1,:) ~= 0)&(M(2,:) ==0));
    %select randomly a single man, mi
    r = randi(size(idxm,2),1,1);
    mi_idx = idxm(r);
    mi = M(1,mi_idx);
    %
    %find the positions of the single women
    idxw = find((M(1,:) == 0)&(M(2,:) ~=0));
    %select randomly a single woman, wi
    r = randi(size(idxw,2),1,1);
    wj_idx = idxw(r);
    wj = M(2,wj_idx);
    %check acceptable
    if (men_rank_list(mi,wj) > 0)
        %assign wj to be a partner of mi
        M(2,mi_idx) = wj;
        M(2,wj_idx) = 0;
    end
else
    %there are no a single man and a single woman
    %
    %find the positions of all of  pairs in M
    idx = find((M(1,:) ~= 0)&(M(2,:) ~=0));
    %select randomly a pair (mi,wi) in M
    r = randi(size(idx,2),1,1);
    mi_idx = idx(r);
    mi = M(1,mi_idx);
    wi = M(2,mi_idx);
    %
    %select randomly a pair (mj,wj) in M
    r = randi(size(idx,2),1,1);
    wj_idx = idx(r);
    mj = M(1,wj_idx);
    wj = M(2,wj_idx);
    %swap mi's partner and mj's a partner
    if (men_rank_list(mi,wj) >0)
        %assign wj to be a partner of mi
        M(2,mi_idx) = wj;
        %
        %mj become single
        M(2,wj_idx) = 0;
        %wi become single
        wi_idx = find((M(1,:)==0) & (M(2,:)==0),1,'first'); 
        M(2,wi_idx) = wi;
    end
end
end
%==========================================================================