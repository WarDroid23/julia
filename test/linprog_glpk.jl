# Disable output except on error

lps_opts = GLPSimplexParam()
lps_opts["msg_lev"] = GLP_MSG_ERR
lps_opts["presolve"] = GLP_ON
lps_opts["it_lim"] = 1000

# A small dense constraint satisfaction problem
 
f = [ 3.; 2. ];
A = [ 2. 1. ;
      1. 1. ]; 
b = [ 100.; 80 ];
lb = [ 0.; 0;];

(z, x) = linprog_simplex(-f, A, b, [], [], lb, [], lps_opts);
#println("z=$z")
#println("x=$x")
@assert z == -180.0
@assert x == [20.; 60.]


# Test a matching problem
# passing a sparse representation
# to linprog_simplex

f = [ 3. 2. 2. ;
      1. 0. 1. ;
      3. 3. 5. ];
f = reshape(f, (9,));
Aeq = [ 1. 1. 1. 0. 0. 0. 0. 0. 0. ;
        0. 0. 0. 1. 1. 1. 0. 0. 0. ;
        0. 0. 0. 0. 0. 0. 1. 1. 1. ;
        1. 0. 0. 1. 0. 0. 1. 0. 0. ;
        0. 1. 0. 0. 1. 0. 0. 1. 0. ;
        0. 0. 1. 0. 0. 1. 0. 0. 1. ];
Aeq = sparse(Aeq);
beq = ones(Float64, 6);
lb = zeros(Float64, 9);
ub = ones(Float64, 9);
(z, x) = linprog_simplex(f, [], [], Aeq, beq, lb, ub, lps_opts);
#println("z=$z");
#println("x=$x");
@assert z == 5.
@assert x == [ 0.; 0.; 1. ;
               0.; 1.; 0. ;
               1.; 0.; 0. ]
