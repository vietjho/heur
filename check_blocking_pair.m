function [f] = check_blocking_pair(men_rank_list,women_rank_list,mi,wi,mj,wj)
% A pair (mi,wj) is a blocking pair in M iif 
%(1) mi and wj find acceptable each other, and
%(2) mi is either single in M or he strictly prefers wj to wi, and
%(3) wj is either single in M or she strictly prefers mi to mj.
%
%(1) m and w find acceptable each other
mr_wj = men_rank_list(mi,wj);
wr_mi = women_rank_list(wj,mi);
%
%(2) mi is either single (wi = 0) in M or he strictly prefers wj to wi
if (wi ~= 0)
    mr_wi = men_rank_list(mi,wi);
end
%
%(3) wj is either single (mj = 0) in M or she strictly prefers mi to mj
if (mj ~= 0)
    wr_mj = women_rank_list(wj,mj);
end
%the blocking pair definition 
f = ((mr_wj > 0)&&(wr_mi > 0)) && ((wi == 0)||(mr_wj <mr_wi)) && ((mj == 0)||(wr_mi < wr_mj));
end