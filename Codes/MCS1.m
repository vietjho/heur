function [f_time,f_cost,f_stable,f_iter,f_reset,f_nbps]= MCS1(men_rank_list,women_rank_list,M)
%==========================================================================
% By Hoang Huu Viet
% MCS: a max-conflicts-based heuristic search algorithm for SMTI
%==========================================================================
%
%initialize the best matching
n = size(men_rank_list,1);
M_best = M;
f_best = n;
%
p = 0.0;
f_stable = 0;
num_reset = 0;
MAX_ITERS = 10000;
iter = 0;
f_nbps = [];
tic
while (iter <= MAX_ITERS)
    %find the cost, blocking pairs and heuristics in M
    %[X,y] = find_UBPs(men_rank_list,women_rank_list,M);
    [X,y] = find_UBPs1(men_rank_list,women_rank_list,M);
    
    f_nbps(end+1) = size(X,1);
    %check if the undominated blocking pairs of M is empty, i.e. M is stable
    if isempty(X)
        f_stable = 1;
        f = matching_cost(M);
        if (f_best > f)
            M_best = M;
            f_best = f;
        end
        %escape from a local minimum
        if (f > 0)
            num_reset = num_reset + 1;
            M = escape_local_minima(men_rank_list,women_rank_list,M);
            continue;
        else
            break;
        end
    end
    %compute the values of heuristic
    h = zeros(n,1);
    for i = 1:size(X,1)
        mi = X(i,1);
        wj = X(i,4);
        h(mi) = n*y(wj) - women_rank_list(wj,mi);
    end
    if (rand() < p)
        %take a random man in undominated blocking pairs
        r = randi(size(X,1),1,1);
        mi = X(r,1);
    else
        %take the man with max(h2), i.e., max-conflicts
        [~,mi] = max(h);
    end
    %
    %find undominated blocking pair (mi,wj)
    row = find(X(:,1) == mi,1,'first');
    %remove a blocking pair (mi,wj)         
    mi = X(row,1);
    wi = X(row,2);
    mj = X(row,3);
    wj = X(row,4);
    %
    %--------------------------------------------------------------------
    %for debug size of X and Y
    %[f0,nbp,nsg,BPs] = number_of_blocking_pairs(men_rank_list,women_rank_list,M);
    %fprintf('\n |X| =%3d, |BPs| =%5d, nbp =%5d, (mi,wj) = (%3d,%3d), wi = %3d, mj = %3d',...
    %        size(X,1),f0,nbp,mi,wj,wi,mj);
    %--------------------------------------------------------------------
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
    iter = iter + 1;
end
f_time = toc;
f_cost = f_best;
f_iter = iter;
f_reset = num_reset;
%verify the result matching;
%verify_result_matching(men_rank_list,women_rank_list,M_best);
end
%==========================================================================
function [X,y] = find_UBPs(men_rank_list,women_rank_list,M)
%X: a set of blocking pairs in M
%h: the heuristic of men
%y: frequency of women in undominated blocking pairs
%
n = size(men_rank_list,1);
%
%initalize variables
X = [];
y = zeros(n,1);
%
for i = 1:size(M,2)
    mi = M(1,i);
    if (mi == 0) 
        continue;
    end
    wi = M(2,i);
    if (wi > 0)
        mr_wi = men_rank_list(mi,wi);
    else
        mr_wi = n+1;
    end
    %find blocking pairs (mi,wj)
    x = men_rank_list(mi,:);
    [mi_rank_list,idx] = sort(x); 
    for j = 1:n
        mr_wj = mi_rank_list(j);
        if (mr_wj > 0) && (mr_wj < mr_wi)
            wj = idx(j);
            wj_idx = find(M(2,:) == wj,1,'first');
            mj = M(1,wj_idx);
            if (check_blocking_pair(men_rank_list,women_rank_list,mi,wi,mj,wj) == true)
                %add (mi,wi) and (mj,wj) to X
                X(end+1,:) = [mi,wi,mj,wj];
                %increase the frequency of wj
                y(wj) = y(wj) + 1;  
                break;
            end
        end
    end
end
end
%==========================================================================
function [X,y] = find_UBPs1(men_rank_list,women_rank_list,M)
%X: a set of blocking pairs in M
%h: the heuristic of men
%y: frequency of women in undominated blocking pairs
%
n = size(men_rank_list,1);
%
%initalize variables
X = [];
y = zeros(n,1);
%
for i = 1:size(M,2)
    mi = M(1,i);
    if (mi == 0) 
        continue;
    end
    wi = M(2,i);   
    if (wi > 0)
        mr_wi = men_rank_list(mi,wi);
    else
        mr_wi = n+1;
    end    
    %find undominated blocking pairs (mi,wj)
    mi_rank_list = men_rank_list(mi,:);
    for j = 1:n     
        mr_wj = min(mi_rank_list(mi_rank_list > 0));
        if isempty(mr_wj) || (mr_wj == mr_wi)
            break;
        end
        wj = find(mi_rank_list == mr_wj,1,'first');
        wj_idx = find(M(2,:) == wj,1,'first');
        mj = M(1,wj_idx);
        if  (check_blocking_pair(men_rank_list,women_rank_list,mi,wi,mj,wj) == true)
            %add (mi,wi) and (mj,wj) to X
            X(end+1,:) = [mi,wi,mj,wj];
            %increase the frequency of wj
            y(wj) = y(wj) + 1;  
            break;
        else
            mi_rank_list(wj) = 0;
        end
    end         
end
end
%==========================================================================
function [M] = escape_local_minima(men_rank_list,women_rank_list,M)
if (rand()<=0.5)
    %find the positions of the single men
    idxm = find((M(1,:) ~= 0)&(M(2,:) ==0));
    %select a random single man, mi
    r = randi(size(idxm,2),1,1);
    i = idxm(:,r);
    mi = M(1,i);
    %
    %find all the women in mi's rank list
    setw = find(men_rank_list(mi,:) > 0);
    %make all the women in mi's rank list to be single
    for i = 1:size(setw,2)
        wi = setw(i);
        %find woman wi in M
        j = find((M(1,:) ~= 0)&(M(2,:) == wi),1,'first');
        if ~isempty(j)
            %find the locations consisting of (0,0) in M 
            k = find((M(1,:) == 0)&(M(2,:) == 0),1,'first');
            %make M(1,j) to be single
            M(2,k) = M(2,j); 
            M(2,j) = 0;
        end
    end
else
    %find the positions of the single women
    idxw = find((M(1,:) == 0)&(M(2,:) ~=0));
    %select a random single woman, wi
    r = randi(size(idxw,2),1,1);
    i = idxw(:,r);
    wi = M(2,i);
    %
    %find all the men in wi's rank list
    setm = find(women_rank_list(wi,:) > 0);
    %make all the men in wi's rank list to be single
    for i = 1:size(setm,2)
        mi = setm(i);
        %find man mi in M
        j = find((M(1,:) == mi)&(M(2,:) ~= 0),1,'first');
        if ~isempty(j)
            %find the locations consisting of (0,0) in M 
            k = find((M(1,:) == 0)&(M(2,:) == 0),1,'first');
            %make M(2,j) to be single
            M(1,k) = M(1,j); 
            M(1,j) = 0;
        end
    end
end
end
%==========================================================================
function f = matching_cost(M)
    idx = find((M(1,:) ~= 0) & (M(2,:) == 0));
    f = size(idx,2);
end
%==========================================================================