# The number of jobs.
param N;

# Job parameters.
param T {1..N};  # Processing time.
param w {1..N};  # Weight.
param W {1..N};  # Width.
param H {1..N};  # Height.

# Parameters.
param board_W;  # Board width.
param board_H;  # Board height.

# Dependent parameters.
param T_max := (sum {j in 1..N} (T[j]));  # Upper bound on time.

# X[j,t,x,y] := Whether job j starts at time t with its upper left corner at
# position (x,y).
var X {j in 1..N,
       t in 0..(T_max - 1),
       x in 0..(board_W - 1),
       y in 0..(board_H - 1):
       ((x + W[j]) <= board_W) and
       ((y + H[j]) <= board_H) and
       ((t + T[j]) <= T_max)} binary;

# Minimize the weighted completion time.
minimize weighted_completion_time:
    (sum {j in 1..N,
          t in 0..(T_max - 1),
          x in 0..(board_W - 1),
          y in 0..(board_H - 1):
          ((x + W[j]) <= board_W) and
          ((y + H[j]) <= board_H) and
          ((t + T[j]) <= T_max)} (X[j,t,x,y] * (t + T[j]) * w[j]));

# All jobs must be completed.
subject to completion {j in 1..N}:
    (sum {t in 0..(T_max - 1),
          x in 0..(board_W - 1),
          y in 0..(board_H - 1):
          ((x + W[j]) <= board_W) and
          ((y + H[j]) <= board_H) and
          ((t + T[j]) <= T_max)} (X[j,t,x,y])) = 1;

# position (x,y) can only be filled by one job from time t to t + 1.
subject to occupancy {t in 0..(T_max - 1),
                      x in 0..(board_W - 1),
                      y in 0..(board_H - 1)}:
    (sum {_j in 1..N,
          _t in 0..(T_max - 1),
          _x in 0..(board_W - 1),
          _y in 0..(board_H - 1):
          (_x <= x) and
          (x < (_x + W[_j])) and
          (_y <= y) and
          (y < (_y + H[_j])) and
          (_t <= t) and
          (t < (_t + T[_j])) and
          ((x + W[_j]) <= board_W) and
          ((y + H[_j]) <= board_H) and
          ((t + T[_j]) <= T_max)} (X[_j,_t,_x,_y])) <= 1;
