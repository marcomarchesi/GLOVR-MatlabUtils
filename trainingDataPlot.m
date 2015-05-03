
% TRAINING DATA ANALYZER 

% global values
DIM_OF_SAMPLES = 3;
% destination files
output_filename = 'NormalizedData.txt';
f2 = fopen(output_filename,'a');
params_filename = 'MeanStdData.txt';
f3 = fopen(params_filename,'a');

% source file
f1 = fileread('TrainingData_class1_mic.txt');
splitData = regexp(f1,'************TIME_SERIES************','split');
splitData = splitData(:,2:end);
samplesSize = size(splitData,2)
meanVector = zeros(DIM_OF_SAMPLES,1);
stdVector = zeros(DIM_OF_SAMPLES,1);
s = 0;
sum_of_data = zeros(1,DIM_OF_SAMPLES);

for k=1:samplesSize
    [classes,class_tokens] = regexp(f1,'ClassID:\s([0-9])','tokens','match');
    [sample,sample_tokens] = regexp(splitData(1,k),'TimeSeriesData:(.*)','tokens','match');
    
    data = str2num(char(sample{1,1}{1,1}));
    sum_of_data = cat(1,sum_of_data,data);
%     data = str2num(char(sample{1,1}));
    arraySize = size(data,1);
end

sum_of_data = sum_of_data(2:end,:);
for i=1:DIM_OF_SAMPLES
    meanVector(i) = mean(sum_of_data(:,i));
    stdVector(i) = std(sum_of_data(:,i));
        fprintf(f3,'%s','Dim:');
        fprintf(f3,'%i\n',i);
        fprintf(f3,'%s\n',meanVector(i));
        fprintf(f3,'%s\n',stdVector(i));
end
fclose(f3);

for k=1:samplesSize
    % return the class of each sample
    [classes,class_tokens] = regexp(f1,'ClassID:\s([0-9])','tokens','match');
    [sample,sample_tokens] = regexp(splitData(1,k),'TimeSeriesData:(.*)','tokens','match');
    data = str2num(char(sample{1,1}{1,1}));
    arraySize = size(data,1);
    

    if(k==1) 
        figure
        plot(data(:,1:DIM_OF_SAMPLES));  % only accelerometer (or gyroscope) data
%         legend('acc_x','acc_y','acc_z','gyr_x','gyr_y','gyr_z');
    end

    % NORMALIZE DATA
    for i=1:DIM_OF_SAMPLES
        for j=1:arraySize
            data(j,i) = (data(j,i) - meanVector(i))/stdVector(i);
        end
    end

    if(k==1) 
        figure
        plot(data(:,1:DIM_OF_SAMPLES));  % only accelerometer (or gyroscope) data
%         legend('acc_x','acc_y','acc_z','gyr_x','gyr_y','gyr_z');
    end
%     
%     
    fprintf(f2,'%s\n','************TIME_SERIES************');
    fprintf(f2,'%s\n',class_tokens{1,k});
    fprintf(f2,'%s','TimeSeriesLength: ');
    fprintf(f2,'%s\n',num2str(arraySize));
    fprintf(f2,'%s\n','TimeSeriesData:');

    dlmwrite(output_filename,data,'-append',...  
             'delimiter','\t',...
             'newline','pc');
end

fclose(f2);





