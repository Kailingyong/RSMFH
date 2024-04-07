
################ Information ################

Matlab demo code for "Robust supervised matrix factorization hashing with application to cross-modal retrieval"  accepted by Neural Computing and Applications
Authors: Zhenqiu Shu, Kailing Yong, Donglin Zhang, Jun Yu, Zhengtao Yu, and Xiaojun Wu;
Contact: yongkailing@163.com


This code uses some public software packages by the 3rd party applications, and is free for educational, academic research and non-profit purposes. Not for commercial/industrial activities. If you use/adapt our code in your work (either as a stand-alone tool or as a component of any algorithm), you need to appropriately cite our work.



################ Tips ################
1. To run a demo, conduct the following command:
        RSMFH_demo.m

* If you have got any question, please do not hesitate to contact us.
* Bugs are also welcome to be reported.

################ Contents ################
This package contains cleaned up codes for the RSMFH, including:

RSMFH_demo.m: test example on public LabelMe dataset
main_RSMFH.m: function to calculate mAP value of RSMFH
slove_RSMFH.m: function to optimize the objective function of RSMFH
compactbit.m: function to compute the compact hash code matrix
hammingDist.m: function to compute the hamming distance between two sets
Kernelize.m: function to compute a kernel matrix
NormalizeFea: function to centerlize the data
map_rank:function to calculate mAP value




