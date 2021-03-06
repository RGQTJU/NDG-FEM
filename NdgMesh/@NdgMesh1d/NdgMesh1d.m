classdef NdgMesh1d < NdgMesh
    %LINE_MESH Summary of this class goes here
    %   Detailed explanation goes here

    properties(Constant)
        type = NdgMeshType.OneDim
    end
    
    methods(Hidden, Access = protected)
        function [ J ] = assembleJacobiFactor( obj )
            xr = obj.cell.Dr*obj.x;
            J = xr; rx = 1./J;

            ry = zeros(size(rx));
            rz = zeros(size(rx)); 
            sx = zeros(size(rx));
            sy = zeros(size(rx));
            sz = zeros(size(rx)); 
            tx = zeros(size(rx));
            ty = zeros(size(rx));
            tz = zeros(size(rx)); 
        end
        
        function [nx, ny, nz, Js] = assembleFacialJaobiFactor( obj )
            xb = obj.x(obj.cell.Fmask, :);
            nx = ones(obj.cell.TNfp, obj.K);
            % Define outward normals
            [~, ind] = min(xb);
            nx(ind, :) = -1;
            Js = ones(size(nx));
            ny = zeros(obj.cell.Nface, obj.K);
            nz = zeros(obj.cell.Nface, obj.K);
        end
        
        function faceId = assembleGlobalFaceIndex( obj )
            faceId = zeros(obj.cell.Nface, obj.K);
            for f = 1:obj.cell.Nface
                faceId(f, :) = obj.EToV(obj.cell.FToV(1,f), :);
            end
        end% func
    end% methods
    
    methods
        obj = refine(obj, refine_level);
        
        function obj = NdgMesh1d(cell, Nv, vx, K, EToV, EToR, BCToV)
            vy = zeros(size(vx)); % vy is all zeros
            vz = zeros(size(vx)); % vz is all zeros            
            obj = obj@NdgMesh(cell, Nv, vx, vy, vz, K, EToV, EToR, BCToV);
        end% func
        
        function draw(obj)
            plot(obj.x, zeros(obj.cell.Np, obj.K), '.-');
        end
    end
    
end

