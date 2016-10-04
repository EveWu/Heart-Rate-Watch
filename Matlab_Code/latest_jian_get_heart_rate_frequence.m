%All Copyright reserved by School of Mobile Information Engineering of Sun Yat-sen University
function [heart_rate_frequence] = latest_jian_get_heart_rate_frequence(Sorted_Maybe_frequence_unique,Sorted_Maybe_frequence_unique2,xyz_f_unique,time_point_now )

     global heart_record_buff;
    weight_set=[10 8 6 4 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];%[10 6 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
    dis_set = [2 1.0 0.6 0.2 0.1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];

   xyz_f_len = size(xyz_f_unique,2);
   jian_ii = 1;
   m_xyz_f_unique(1) = 0.9;
   for m_i = 1:xyz_f_len
       if xyz_f_unique(m_i) > 0.8
       m_xyz_f_unique(jian_ii) = xyz_f_unique(m_i);
       jian_ii  = jian_ii + 1;
       end
   end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%initialization%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [success,heart_rate_frequence] = initialization(Sorted_Maybe_frequence_unique,Sorted_Maybe_frequence_unique2,xyz_f_unique,time_point_now);
    if success == 1
        return ;
    end
       %%
    predit_heart_point = heart_record_buff(time_point_now - 1); % edit by liujian
    predict_frequency_dis = predit_heart_point - heart_record_buff(time_point_now - 2);
    if predict_frequency_dis>0
        direction = 1;
    elseif predict_frequency_dis<0
        direction = -1;
    else
        direction = 0;
    end
    
    [record_frequency,record_frequency_op,close_point_with_xyz,min_address] = get_both_direction_point( Sorted_Maybe_frequence_unique,m_xyz_f_unique,time_point_now );
    [record_frequency2,record_frequency_op2,close_point_with_xyz2,min_address2] = get_both_direction_point( Sorted_Maybe_frequence_unique2,m_xyz_f_unique,time_point_now );
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
     max = 10;
     rate_heart = 0;
%     sum_predict_frequency = 0;
    all_weight = 0;
    if record_frequency(1) ~= -1
        heart_rate_return = predit_heart_011(record_frequency,Sorted_Maybe_frequence_unique);
        if abs(heart_rate_return -  predit_heart_point) < max
            max = abs(heart_rate_return -  predit_heart_point);
            rate_heart = heart_rate_return;
            all_weight = 1;
        end

    end
     if record_frequency_op(1) ~= -1
        heart_rate_return = predit_heart_011(record_frequency_op,Sorted_Maybe_frequence_unique);
        if abs(heart_rate_return -  predit_heart_point) < max
            max = abs(heart_rate_return -  predit_heart_point);
            rate_heart = heart_rate_return;
            all_weight = 1;
        end

     end   
    if record_frequency2(1) ~= -1
        heart_rate_return = predit_heart_011(record_frequency2,Sorted_Maybe_frequence_unique2);
        if abs(heart_rate_return -  predit_heart_point) < max
            max = abs(heart_rate_return -  predit_heart_point);
            rate_heart = heart_rate_return;
            all_weight = 1;
        end
    end
     if record_frequency_op2(1) ~= -1
        heart_rate_return = predit_heart_011(record_frequency_op2,Sorted_Maybe_frequence_unique2);
        if abs(heart_rate_return -  predit_heart_point) < max
            max = abs(heart_rate_return -  predit_heart_point);
            rate_heart = heart_rate_return;
            all_weight = 1;
        end         
     end 
    
    
    % use cluster to define the point
    if all_weight==0
        [success,heart_rate_frequence] = use_set_information(time_point_now,predit_heart_point);
        if success==0
            [heart_rate_frequence] =rate_frequency_by_predict01(predit_heart_point,min_address,min_address2,Sorted_Maybe_frequence_unique,Sorted_Maybe_frequence_unique2,close_point_with_xyz,close_point_with_xyz2,direction);
        end
    else
        [heart_rate_frequence] = rate_heart;
    end

    heart_record_buff(time_point_now)=heart_rate_frequence;
    
end
