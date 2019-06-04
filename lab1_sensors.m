clear all
close all
clc

%Import data
ref = "reference.dat";
dry = "dry/Measure7.dat";
wet = "wet/Measure8.dat";

filenames = [ref,dry,wet];
%name = ["Reference"];
name = ["Reference","Dry sample","Wet sample"];

%Set initial temperature
ambient=[24,19,22];         %%Adjust for every sample. highest tamperature possible. There can't be any values from the setup time in the graphs.
count=1;

for i =  name
    disp(i)
    disp(' ')
    disp("Importing data from:")
    disp(filenames(count))
    disp("Ambient temperature:")
    disp([num2str(ambient(count)),'ºC'])
    disp(' ')
    [time,T] = importfile(filenames(count));
    probetimeconstant(i, time, T, ambient(count))
    disp(' ')
    disp(' ')
    disp(' ')
    count = count + 1;
end


