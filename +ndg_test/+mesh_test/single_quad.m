function [ mesh ] = single_quad( cell )
%SINGLE_QUAD Summary of this function goes here
%   Detailed explanation goes here

if (cell.type ~= ndg_lib.std_cell_type.Quad)
    error('The input cell type is not quadrilateral.');
end

EToV = [1,2,3,4]';
vx = [0.05, .6, 0.2, 0.01]';
vy = [0.05, 0.05, .5, 0.5]';
K = 1;
Nv = 4;
EToR = 1;
EToBS = [1, 1, 1, 1]';

mesh = ndg_test.mesh_test.mesh2d_fullquad(cell, Nv, vx, vy, K, EToV, EToR, EToBS);
end

