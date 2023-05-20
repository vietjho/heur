function [f,nbp,nsg,BPs] = number_of_blocking_pairs(men_rank_list,women_rank_list,M)
%f = #nbp + #nsg
%
nbp = 0;
nsg = 0;
X = [];
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
            %find the ranks of blocking pair (mi,wj)
            wr_mi = women_rank_list(wj,mi);
            mr_wj = men_rank_list(mi,wj);
            %add wr_mi,mr_wj to the last columns of blocking_pairs
            X(end+1,:) = [mi,wi,mj,wj,wr_mi,mr_wj];
        end
    end
    %count the number of singles in M which are not in any blocking pairs
    if ((check_bp == false) && (wi == 0))
        nsg = nsg + 1;
    end
end
f = nbp + nsg;
BPs = X;
end
%==========================================================================