# Source codes for the paper titled: A Max-Conflicts based Heuristic Search for the Stable Marriage Problem with Ties and Incomplete Lists
# Note: the outputs of MCS algorithm for SMTI instances are in files output100.zip, output500.zip and output700.zip.
#
# SMTIGenerator.m: generate SMTI instances
# main.m: the main function to call MCS, LTIU and AS algorithm
# LTIU.m: LTIU algorithm
AS.m: AS algorithm
MCS.m: MCS algorithm
make_random_matching.m: generate a random matching
check_blocking_pair.m: check a blocking pair for a matching
MCS_vs_LTIU_execution_time1.m: plot the average execution time of MCS and LTIU algorithms - figure 1(a)
MCS_vs_LTIU_execution_time2.m: plot the average execution time of MCS and LTIU algorithms - figure 1(b)
MCS_vs_LTIU_stable_matchings.m: plot the percentage of stable matchings and the percentage of perfect matchings found by MCS and LTIU algorithms
MCS_vs_AS_execution_time1.m: plot the average execution time of MCS and AS algorithms - figure 4(a)
MCS_vs_AS_execution_time2.m: plot the average execution time of MCS and AS algorithms - figure 4(b)
MCS_vs_AS_iters_and_resets.m: plot the average number of iterations and resets used by MCS and AS algorithms
MCS_vc_AS__stable_matchings.m: plot figure 6.
