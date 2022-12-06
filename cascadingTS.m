clc
clear
close all


num_turn = 1000;
num_item = 5;
recom_item = 3;

num_pos_reward = ones(1,num_item);
num_neg_reward = ones(1,num_item);

%p = rand(1,num_item); % random win rate for each machine
p = [0.1 0.5 0.3 0.8 0.2]; %The defalut win rate for each machine

%initial
beta=[];
choice=0; % if the user did not make a choice the choice will be 0
RB=[];
Re=[];
H=[];

for i=1:num_turn
    
    %sample Beta distribution of K items
    randomBeta = random('Beta',num_pos_reward,num_neg_reward);
    RB = [RB ;randomBeta];
    %choose J items to recommend which have max beta sample value
    recommed = sort(maxk(randomBeta,recom_item));
    Re = [Re ;recommed];

    for k = 1:recom_item
        
        index = find(randomBeta == recommed(k));
        a = rand;
        if a < p(index) %if p>random number we choose this item then break
            choice = k;
            break
        end

    end

    if choice == 0 % if there is no choice break
        break
    else
        for j = 1:choice
            ind = find(randomBeta==recommed(j));
            if j == choice %a+1 for the choice
                num_pos_reward(ind) = num_pos_reward(ind)+1;
            elseif j < choice %b+1 for the items before the choice
                num_neg_reward(ind) = num_neg_reward(ind)+1;
            end
        end
    end
    
    h = 1 - prod(1 - recommed);
    H=[H h];
end

h_hat = 1 - prod(1 - maxk(p,recom_item)); %regret

regret = h_hat - H;
figure(1)
plot(1:num_turn,regret);grid;
sgtitle('Regret')

x = 0:0.001:1;

figure(2)
subplot(151)
plot(x,betapdf(x,num_pos_reward(1),num_neg_reward(1)),'Color',"#74DAFF",'LineWidth',5);grid off
title('Item  1');xlabel(['(a,b) = (',num2str(num_pos_reward(1)),',',num2str(num_neg_reward(1)),')']);

subplot(152)
plot(x,betapdf(x,num_pos_reward(2),num_neg_reward(2)),'Color',"#D5FFC9",'LineWidth',5);grid off
title('Item  2');xlabel(['(a,b) = (',num2str(num_pos_reward(2)),',',num2str(num_neg_reward(2)),')']);

subplot(153)
plot(x,betapdf(x,num_pos_reward(3),num_neg_reward(3)),'Color',"#FFCA94"	,'LineWidth',5);grid off
title('Item 3');xlabel(['(a,b) = (',num2str(num_pos_reward(3)),',',num2str(num_neg_reward(3)),')']);

subplot(154)
plot(x,betapdf(x,num_pos_reward(4),num_neg_reward(4)),'Color',"#9FAFFF"	,'LineWidth',5);grid off
title('Item 4');xlabel(['(a,b) = (',num2str(num_pos_reward(4)),',',num2str(num_neg_reward(4)),')']);

subplot(155)
plot(x,betapdf(x,num_pos_reward(5),num_neg_reward(5)),'Color',"#FFB8AA"	,'LineWidth',5);grid off
title('Item 5');xlabel(['(a,b) = (',num2str(num_pos_reward(5)),',',num2str(num_neg_reward(5)),')']);

sgtitle(['n = ',num2str(num_turn)])

