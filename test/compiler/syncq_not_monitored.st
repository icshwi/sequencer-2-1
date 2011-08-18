program p

int x;
assign x;
syncq x 1; /* ok: not monitored */

#include "simple.st"
