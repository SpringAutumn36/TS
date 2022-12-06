clc
clear
close all


num_turn = 100;
num_machine = 4;

% Default Beta(1,1) for each machine
num_pos_reward = ones(1,num_machine);
num_neg_reward = ones(1,num_machine);

%machineRates = rand(1,num_machine);% Random win rate for each machine
machineRates = [0.8	0.4	0.7 0.2];



max_beta_value =[];

beta=[];

for i=1:num_turn
    
    machineToPlay = -1;
    max_beta = -1;

    for j = 1:num_machine
    
        a = num_pos_reward(j) ;
        b = num_neg_reward(j) ;

        randomBeta = random('Beta',a,b);

        if randomBeta > max_beta
            max_beta = randomBeta;
            machineToPlay = j;
        end
    end

    max_beta_value = [max_beta_value max_beta];

    %add rewards & update distribution
    if  rand < machineRates(machineToPlay)
        num_pos_reward(machineToPlay) = num_pos_reward(machineToPlay)+1;
    else
        num_neg_reward(machineToPlay) = num_neg_reward(machineToPlay)+1;
    end

end

regret = 0.8 - max_beta_value;
figure(1)
plot(1:num_turn,regret);grid;
sgtitle('regret')

%beta
x = 0:0.001:1;

figure(2)
subplot(141)
plot(x,betapdf(x,num_pos_reward(1),num_neg_reward(1)),'Color',"#4DBEEE",'LineWidth',5);grid off
title('Machine 1');xlabel(['(a,b) = (',num2str(num_pos_reward(1)),',',num2str(num_neg_reward(1)),')']);

subplot(142)
plot(x,betapdf(x,num_pos_reward(2),num_neg_reward(2)),'Color',"#77AC30",'LineWidth',5);grid off
title('Machine 2');xlabel(['(a,b) = (',num2str(num_pos_reward(2)),',',num2str(num_neg_reward(2)),')']);

subplot(143)
plot(x,betapdf(x,num_pos_reward(3),num_neg_reward(3)),'Color',"#EDB120"	,'LineWidth',5);grid off
title('Machine 3');xlabel(['(a,b) = (',num2str(num_pos_reward(3)),',',num2str(num_neg_reward(3)),')']);

subplot(144)
plot(x,betapdf(x,num_pos_reward(4),num_neg_reward(4)),'Color',"#FFCCCB"	,'LineWidth',5);grid off
title('Machine 4');xlabel(['(a,b) = (',num2str(num_pos_reward(4)),',',num2str(num_neg_reward(4)),')']);

%plot(x,betapdf(x,num_pos_reward(5),num_neg_reward(5)))
%legend(["machine1","machine2","machine3","machine4","machine5"]);
sgtitle(['n = ',num2str(num_turn)])