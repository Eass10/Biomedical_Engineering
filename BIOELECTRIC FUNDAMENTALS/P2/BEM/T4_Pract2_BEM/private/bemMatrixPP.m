function T = bemMatrixPP(model)
% Function that computes the BEM transfer matrix.
%
% DESCRIPTION
% This function computes the transfer matrix between the inner and
% the most outer surface. It is assumed that surface 1 is the outer
% most surface and surface N the inner most. At the outermost surface
% a Neumann condition is assumed that no currents leave the model.
%
% INPUT 
% model       The model description
%
% OUTPUT
% T           The transfer matrix from inside to outside
%
% STRUCTURE DEFINITIONS
% model
%  .surface{p}           A cell array containing the different surfaces that form the model
%                        These surfaces are numbered from the outside to the inside
%      .node              A 3xN matrix that describes all node positions
%      .face              A 3xM matrix that describes which nodes from one triangle
%                        Each trianlge is represented by one column of this matrix
%      .sigma            The conductivity inside and outside of this boundary
%                        The first element is the conductivity outside and the second the one inside
%      .cal              The vector describes the calibration of the potential the nodes in this vector
%                        will be summed to zero in the deflation process.
%
% NOTE The fields mentioned here are the fields the program uses for its computation purposes. However
%      more fields may be present that resulted from other programs, like channels files etc. These fields
%      will be ignored by the current program
%
% STABILITY
% The program is still in a testing phase and some features have not been tested thoroughly. Please report
% any bugs you encounter.
%
% FUTURE WORK
% - Test/expand the capabilities for doing more than two surfaces
% - Add options to switch on or off the radon integration and support full analytical
%   as well as radon integral solutions
% - Need to add some more features on computing the auto solid angles. At the moment the notion of an eigen value 0
%    is used to computed these auto solid angles (angle computed from a point on the triangle itself).
% - Upgrade some old code that computes the current density using the bem method rather than taking a numerical gradient
%

%
%  For more information, please see: http://software.sci.utah.edu
% 
%  The MIT License
% 
%  Copyright (c) 2009 Scientific Computing and Imaging Institute,
%  University of Utah.
% 
%  
%  Permission is hereby granted, free of charge, to any person obtaining a
%  copy of this software and associated documentation files (the "Software"),
%  to deal in the Software without restriction, including without limitation
%  the rights to use, copy, modify, merge, publish, distribute, sublicense,
%  and/or sell copies of the Software, and to permit persons to whom the
%  Software is furnished to do so, subject to the following conditions:
% 
%  The above copyright notice and this permission notice shall be included
%  in all copies or substantial portions of the Software.
% 
%  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
%  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
%  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
%  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
%  DEALINGS IN THE SOFTWARE.
%


    % VALIDATE THE INTEGRITY OF THE MODEL BY DOING SOME SIMPLE TESTS ON THE GEOMETRY
    % - IS THE BOUNDARY CLOSED ?
    % - ARE ALL TRIANGLES ORIENTED THE SAME WAY ?
    % - IS A NODE BEING USED MORE THAN ONCE IN A TRIANGLE ?

    model = bemCheckModel(model);
    
    hsurf = length(model.surface); % heart surface
    bsurf = 1:(hsurf-1); % body surface (one or more surfaces)
    
    % The EE Matrix computed the potential to potential matrix.
    % The boundary element method is formulated as
    %
    % EE*u + EJ*j = source
    %
    % Here u is the potential at the surfaces and j is the current density normal to the surfac.
    % and source are dipolar sources in the interior of the mode space, being ignored in this formulation
    
    
    [EE,row] = bemEEMatrix(model,[bsurf hsurf],[bsurf hsurf]);
    % Gth: Coeff matrix respresenting the contribution of the voltage gradient of a point of the heart to a point of the torso.
    Gbh = bemEJMatrix(model,bsurf,hsurf); 
    % Ghh: Coeff matrix respresenting the contribution of the voltage gradient of a point of the heart to a point of the heart
    Ghh = bemEJMatrix(model,hsurf,hsurf); 
    
    % Do matrix deflation
    
    % The matrix deflation is performed on the potential to potential
    % matrix. I still have to include a more throrough deflation for
    % the case that there are multiple surfaces as proposed by Lynn and Timlake
    
    % There are two options :
    % If cal is defined for each surface use, those calibration matrices
    % and make the sum of the matrices they indicate zero
    % Or else use every node with equal weighing
   
    test = 1;
    for p = 1:length(model.surface)
        test = test * isfield(model.surface{p},'cal');
    end


    if test == 1
        % constuct a deflation vector
        % based on the information of which 
        % nodes sum to zero.
        
        eig = ones(size(EE,2),1);
        p = zeros(1,size(EE,2));
        k = 0;
        for q = 1:length(model.surface)
            p(model.surface{q}.cal+k) = 1;
            k = k + size(model.surface{q}.node,2);
        end
        p = p/nnz(p);
        EE = EE + eig*p;        
    else
        EE = EE + 1/(size(EE,2))*ones(size(EE));
    end
   
    % Get the proper indices for column and row numbers
    
    b = find(row ~= hsurf);   % body surface indices
    h = find(row == hsurf);   % heart surface indices
    
    % Dtt = Pbb: Coeff matrix that represents the contribution of the potential to a point of the torso to a point of the torso
    Pbb = EE(b,b);
    % Dhh = Phh: Coeff matrix that represents the contribution of the potential to a point of the heart to a point of the heart
    Phh = EE(h,h); 
    % Dth = Pbh: Coeff matrix that represents the contribution of the potential to a point of the heart to a point of the torso
    Pbh = EE(b,h); 
    % Dht = Phb: Coeff matrix that represents the contribution of the potential to a point of the torso to a point of the heart
    Phb = EE(h,b); 
    
    iGhh = inv(Ghh); % Ghh⁻¹
    
    % Formula as used by Barr et al.
    
    % The transfer function from innersurface to outer surfaces (forward problem)
    % PEDRON P. 71 this T = M (transfer matrix heart-torso).
    %T = inv(Pbb - Gbh*iGhh*Phb)*(Gbh*iGhh*Phh-Pbh);
    % M = [Dtt-Gth*Ghh⁻¹*Dht]⁻¹ * [Gth*Ghh⁻¹*Dhh-Dth]
    T = (Pbb - Gbh*iGhh*Phb) \ (Gbh*iGhh*Phh-Pbh);
    
return    

