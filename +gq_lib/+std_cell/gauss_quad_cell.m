classdef gauss_quad_cell < ndg_lib.std_cell.std_cell
    %GAUSS_QUAD_CELL Gauss 数值积分单元基本类型
    %   Detailed explanation goes here
    
    properties(SetAccess = protected)
        Nq, Nfq % 体积分与面积分节点个数
    end
    % 积分节点属性
    properties(SetAccess = protected)
        rq, sq, tq % 体积分节点
        wq % 积分节点权重
        rbq, sbq, tbq % 面积分节点
        wbq % 边界积分节点权重
    end
    
    % 基函数在积分节点函数值矩阵
    properties(SetAccess = protected)
        Vq, Vbq
    end
    
    % 基函数在积分节点导数值矩阵
    properties(SetAccess = protected)
        Drq, Dsq, Dtq
    end
    
    % 公有虚函数
    methods(Access=public)
        
    end
    
    % 私有虚函数
    methods(Abstract, Access=protected) 
        [rq, sq, tq, wq] = gaussquad_vol_coor(obj, N);
        [rbq, sbq, tbq, wbq] = gaussquad_surf_coor(obj, N);
    end
    
    methods
        function obj = gauss_quad_cell(N)
            obj = obj@ndg_lib.std_cell.std_cell(N);
            
            [obj.rq, obj.sq, obj.tq, obj.wq] = obj.gaussquad_vol_coor(N);
            [obj.rbq, obj.sbq, obj.tbq, obj.wbq] = obj.gaussquad_surf_coor(N);
            obj.Nq = numel(obj.rq);
            obj.Nfq = numel(obj.rbq);
            
            obj.Vq = vand_mat(obj, obj.rq, obj.sq);
            obj.Vbq = vand_mat(obj, obj.rbq, obj.sbq);
            obj.Drq = obj.project_node2quad(obj.Dr); 
            obj.Dsq = obj.project_node2quad(obj.Ds);
            obj.Dtq = obj.project_node2quad(obj.Dt);
        end
        
        function [ fq_Q ] = project_node2quad(obj, f_Q)
            % 根据插值节点系数计算 guass 积分点函数值
            fq_Q = obj.Vq*f_Q;
        end
        
        function [ fbq_Q ] = project_node2surf_quad(obj, f_Q)
            % 根据插值节点系数计算边界 gauss 积分点函数值
            fbq_Q = obj.Vbq*f_Q;
        end
    end
    
    methods
        function [ V ] = vand_mat(obj, r, s)
            % 计算节点处基函数的值
            Ng = numel(r);
            Vg = zeros(Ng, obj.Np);
            for n = 1:obj.Np
                Vg(:, n) = obj.orthogonal_func(obj.N, n, r, s, obj.t);
            end% for
            V = Vg/obj.V;
        end
    end
    
end

