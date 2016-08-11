%
clear all
dbstop if error

max_imageside= 64; %cubic
blocked=[];
unblocked=[];
steps = [1 2 4 8 16 32 64 128 256 512 1024 2048 4096 8182];
average = 8;
average_amount = 100000000; %minimum amount of memory to transfer

blocked=zeros(length(steps),max_imageside);
unblocked = blocked;



for image_size = 2:max_imageside
    image=zeros([image_size image_size image_size]);
    image_size
    
    for i= steps
        Ascan=rand(3000,i);
        rec_pos = single(ones(3,i));
        
        average=ceil(average_amount/(3000*8*i+image_size^3*8))
        
        
        %blocked
        time=0;
        tic;
        for j=1:average
            image_out=addsig2vol_2(Ascan,single(ones(3,1)),rec_pos,single(ones(3,1)),single(ones(1,1)),single(ones(1,1)),single(ones(3,1)),uint32([size(image)]),image );
        end
        blocked(i,image_size)=toc/average;
        
        %unblocked
        time=0;
        tic;
        for j=1:average
            for k=1:i %emulate number of blocks by single calls
                image_out=addsig2vol_2(Ascan(:,k),single(ones(3,1)),rec_pos(:,k),single(ones(3,1)),single(ones(1,1)),single(ones(1,1)),single(ones(3,1)),uint32([size(image)]),image );
            end
        end
        unblocked(i,image_size)=toc/average;
        
    end
 
end

% q=(unblocked(steps,:)./blocked(steps,:));
% q(isnan(q))=0;
% q(isinf(q))=0;
% figure; imagesc(mean(q,1));
% figure; imagesc(mean(q,2));
% 
% figure; imagesc(blocked(steps,:));
% figure; imagesc(unblocked(steps,:));