# only a knapsack problem when we cannot be greedy? b/c requests don't come in all at once, they're streaming.
# Though likely in big chunks so maybe its worth trying to optimize, but that's what the PQ will do. so perhaps just greedy appraoch
# is fine

# Efficient dispatching of all tasks is a 3-cost 0-1 knapsack problem where:


# A individual workflow is a DAG, and we want to complete as many as possible minimizing on time and latency for priority
# https://www.pythonpool.com/knapsack-problem-python/
# https://www.geeksforgeeks.org/0-1-knapsack-problem-dp-10/
# "workflow scheduling algorithm"
# https://scholarworks.sjsu.edu/cgi/viewcontent.cgi?article=1358&context=etd_projects
# http://www.cloudbus.org/papers/MHS-Springer-Jia2008.pdf

"""
EWSA
/*Update phase*/
1:For each path Pi
2:     Find MIi, Ex(Ti), and Si using Eq. (1), Eq. (2), and  Eq. (3) respectively
3:     For each task in the path
4:            Calculate  and  update et  using  Eq.  (4)  and  Eq. (5) respectively.
5:     End for
6:End for /*Task-VM mapping*/
7:For each level
8:For each task ti  in the level
9:If existing VM is available
10:                Schedule  the  VM  so  that  the  execution of the task ti is eti
11:else
12:                VMM create a new VM and schedule it so that the execution of the task ti is eti
13:End if
14:       End for
15:End for
16:For each level
17:For each task in the level
18:              Calculate st and ct, using Eq. (6) and Eq. (7) respectively.
19:       End for
20:End for
"""

# https://medium.com/@AlainChabrier/scheduling-with-constraint-programming-35a23839e25c
# https://www.cs.cmu.edu/~cga/ai-course/constraint.pdf
# ScienceDirect