function [x,labels] = generateDataFromUMM(N,ummParameters,visualizationFlag)
% Generates N vector samples from the specified mixture of Gaussians
% Returns samples and their component labels
% Data dimensionality is determined by the size of mu/Sigma parameters
priors = ummParameters.priors; % priors should be a row vector
a = ummParameters.a;
b = ummParameters.b;
n = size(ummParameters.a,1); % Data dimensionality
C = length(priors); % Number of components
x = zeros(n,N); labels = zeros(1,N); 
% Decide randomly which samples will come from each component
u = rand(1,N); thresholds = [cumsum(priors),1];

for l = 1:C
    indl = find(u <= thresholds(l)); 
    Nl = length(indl);
    labels(1,indl) = l*ones(1,Nl);
    u(1,indl) = 1.1*ones(1,Nl); % these samples should not be used again
    %%x(:,indl) = mvnrnd(meanVectors(:,l),covMatrices(:,:,l),Nl)';
    pdfParameters.a=a(:,l);
    pdfParameters.b=b(:,l);
    pdfParameters.type = 'Uniform';
    pdfParameters.Scale=(pdfParameters.b-pdfParameters.a)/2;
    pdfParameters.Mean=(pdfParameters.a+pdfParameters.b)/2;
    x(:,indl)=generateRandomSamples(Nl,n,pdfParameters,0);
end
if visualizationFlag==1 & 0<n & n<=3
figure
    if n==1
        plot(x,zeros(1,N),'.'); title('x ~ 1D data Generated from Mixtures of Uniforms');
        xlabel('x-axis');
    elseif n==2
         plot(x(1,1:N),x(2,1:N),'.'); title('x ~ 2D data Generated from Mixtures of Uniforms');
         xlabel('x-axis');ylabel('y-axis');
    elseif n==3
         plot3(x(1,:),x(2,:),x(3,:),'.'); title('x ~ 3D data Generated from Mixtures of Uniforms');
         xlabel('x-axis');ylabel('y-axis'); zlabel('z-axis')
    end
end 

end 