function [f] = verify_result_matching(men_rank_list,women_rank_list,M)
%find all blocking pair in M
f = 1;
blocking_pairs = [];
for i = 1:size(M,2)
    mi = M(1,i);
    if (mi == 0) 
        continue;
    end
    wi = M(2,i);
    for j = 1:size(M,2)
        mj = M(1,j);
        wj = M(2,j);
        if (wj == 0)
            continue;
        end
        if (check_blocking_pair(men_rank_list,women_rank_list,mi,wi,mj,wj) == true)
            %add mr_wj,wr_mi to the last columns of blocking_pairs
            blocking_pairs(end+1,:) = [mi,wi,mj,wj];
        end
    end
end
if isempty(blocking_pairs)
    %fprintf("\n\nThe matching of the following instance is stable !!!!");
else
    f = 0;
    %fprintf("\n\nThe matching of the following instance is NOT STABLE !!!!");
    %blocking_pairs
end

%check for every man is matched
%fprintf("\n\n ------- Verify the result matching !! ---------");
%
n = size(men_rank_list,1);
X = setdiff(0:n,M(1,:));
Y = setdiff(0:n,M(2,:));
if (isempty(X))
    %fprintf("\nEvery man is matched !!");
else
    f = 0;
    fprintf("\nThere exist men are not matched !!");
    %X
end
%
if (isempty(Y))
    %fprintf("\nEvery woman is matched !!");
else
    f = 0;
    fprintf("\nThere exist women are not matched !!");
    %Y
end
%check duplicate elements
x = M(1,:);
y = x(x>0);
h = histc(y, unique(y));
idx = find(h > 1);
if (~isempty(idx))
    f = 0;
    fprintf('\n There exists a duplicate men!');
end
%
x = M(2,:);
y = x(x>0);
h = histc(y, unique(y));
idx = find(h > 1);
if (~isempty(idx))
    f = 0;
    fprintf('\n There exists a duplicate women!');
end

%check acceptable pairs
for i = 1:size(M,2)
    m = M(1,i);
    w = M(2,i);
    if (m ~=0) && (w ~=0)
        mr = men_rank_list(m,w);
        wr = women_rank_list(w,m);
        if (mr ==0) || (wr ==0)
            f = 0;
            fprintf("\nThere exist unaceptable pairs");
            %[m,w]
        end
    end
end
end
%====================================================================