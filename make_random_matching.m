function [M] = make_random_matching(men_rank_list,women_rank_list,n)
%create a matching consisting of single person
%k is the percent number of men matched with women
x = rand(1,n);
y = rand(1,n);
[~,a] = sort(x,2);
[~,b] = sort(y,2);
M = zeros(2,2*n);
M(1,1:n) = a;
M(2,n+1:2*n) = b;
%
k = randi(n,1,1);
%only k men is matched with k women who accept each other
for i = 1:k
    mi = M(1,i);
    for j = n+1:2*n
        wj = M(2,j);
        if (wj >0) && (men_rank_list(mi,wj) >0) && (women_rank_list(wj,mi) >0)
            M(2,j) = 0;
            M(2,i) = wj;
            break;
        end
    end
end
%check accept each other
for i = 1:size(M,2)
    m = M(1,i);
    w = M(2,i);
    if (m ~=0) && (w ~=0)
        mr = men_rank_list(m,w);
        wr = women_rank_list(w,m);
        if (mr ==0) || (wr ==0)
            fprintf("\nThere exist unaceptable pairs");
            [m,w]
            M = [];
            break;
        end
    end
end
end
%======================================
