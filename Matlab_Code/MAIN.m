%All Copyright reserved by School of Mobile Information Engineering of Sun Yat-sen University
function [OutputBPM, otherOutputParameters]=MAIN_hao_for_IEEE(input_raw_window_data,time_start)
% During data recording, each subject ran on a treadmill with changing speeds. For datasets with names containing 'TYPE01', the running speeds changed as follows:
% 
if time_start==0%%
clear global after_ssa_data;
clear global haorawdata;
clear global refresh_data;
clear global point_id;
clear global group_chart;
clear global group_size;
clear global max_group_id;
clear global big_component_num;
clear global group_distance_xyz;
clear global group_item_statistics;
clear global BPM0;
clear global sigraw;
clear global heart_bpm;
clear global heart_rate_frequence
clear global get_xyz_frequence_threshold;
clear global ssa_delete_by_motion_threshold;
clear global ssa_period_peak_threshold;
clear global ssa_period_peak_num;

clear global heart_record_buff;
clear global group_chart;
clear global big_set_or_not
clear global final_sets;
clear global heart_record_buff;

end

global haorawdata;

global refresh_data;

global after_ssa_data;
global point_id;
global group_chart;
global group_size;
global max_group_id;
global big_component_num;
global group_distance_xyz;
global group_item_statistics;
global BPM0;
global sigraw;
 global heart_bpm;
 
 global heart_rate_frequence
global get_xyz_frequence_threshold;
global ssa_delete_by_motion_threshold;
global ssa_period_peak_threshold;
global ssa_period_peak_num;

global heart_record_buff;
global group_chart;
global big_set_or_not

haorawdata=2;%%%
refresh_data=0;%%%
% 
ssa_period_peak_num=3;
ssa_period_peak_threshold=1/2;
ssa_delete_by_motion_threshold=0.03;
get_xyz_frequence_threshold=2/3;
%%%%%%%%%%%%%%%%%%

time_windows=8; %
time_point=time_start;%%
i=time_start;


        input_raw_window_data(1:5,1001)=[0;0;0;0;0];%%%%
        sigraw(2:6,1+time_start*125:1+(time_windows+time_start)*125)=input_raw_window_data(:,:);%%%
        sig2_butter=hao_butter_band_pass(sigraw(2,:),time_start,time_windows,1,3,6,0);
        [A,B,C,Sorted_Maybe_frequence_unique,xyz_f_unique]=hao_ssa(sig2_butter,time_start,time_windows);%
         after_ssa_data(i/2*10+1:i/2*10+1+2,1:size(Sorted_Maybe_frequence_unique,2))=Sorted_Maybe_frequence_unique(:,:);
        
        sig3_butter=hao_butter_band_pass(sigraw(3,:),time_start,time_windows,1,3,6,0);
        [A2,B2,C2,Sorted_Maybe_frequence_unique2,xyz_f_unique2]=hao_ssa(sig3_butter,time_start,time_windows);%
         after_ssa_data(i/2*10+4:i/2*10+1+5,1:size(Sorted_Maybe_frequence_unique2,2))=Sorted_Maybe_frequence_unique2(:,:);
        Sorted_xyz_f=get_xyz_frequence_all_para4(time_start,time_windows);
        xyz_f_unique_limit=get_xyz_frequence_all_para5(time_start,time_windows);                                                  
        after_ssa_data(i/2*10+7:i/2*10+8,1:size(Sorted_xyz_f,2))=Sorted_xyz_f(1:2,:);
        after_ssa_data(i/2*10+1+9,1)=0;%%%%%%
      


    hao_get_heart_points_in_time(time_start);%
    sets_item_out=get_final_sets_item(time_point);
       outx=zeros(1,size(sets_item_out,2));
     outx(:,:)=time_point;
      plot(outx,sets_item_out*60,'sk');
      
    %%%%%%%»­PPG1
   
    points=size(Sorted_Maybe_frequence_unique,2);
    for ii=1:points
        hold on
        if ii==1
            plot(time_point,Sorted_Maybe_frequence_unique(1,ii)*60,'*r');
        end
        if ii==2
            plot(time_point,Sorted_Maybe_frequence_unique(1,ii)*60,'*m');
        end
        if ii==3
            plot(time_point,Sorted_Maybe_frequence_unique(1,ii)*60,'*b');
        end
        if ii==4
            plot(time_point,Sorted_Maybe_frequence_unique(1,ii)*60,'*g');
        end

        ylim([0 200])
    end
        
    points2=size( xyz_f_unique_limit,2);
    for ii2=1:points2
        plot(time_point, xyz_f_unique_limit(1,ii2)*60,'ok');
        ylim([0 200])
    %   drawnow;
    end

    points=size(Sorted_Maybe_frequence_unique2,2);
    for ii=1:points
        hold on
        if ii==1
            plot(time_point,Sorted_Maybe_frequence_unique2(1,ii)*60,'vr');
        end
        if ii==2
            plot(time_point,Sorted_Maybe_frequence_unique2(1,ii)*60,'vm');
        end
        if ii==3
            plot(time_point,Sorted_Maybe_frequence_unique2(1,ii)*60,'vb');
        end
        if ii==4
            plot(time_point,Sorted_Maybe_frequence_unique2(1,ii)*60,'vg');
        end
%         if ii>4
%             plot(time_point,Sorted_Maybe_frequence_unique2(1,ii)*60,'*y');
%         end
        ylim([0 200])
%     drawnow;
    end
    heart_rate_frequence(time_point/2+1)= latest_jian_get_heart_rate_frequence( Sorted_Maybe_frequence_unique,Sorted_Maybe_frequence_unique2,xyz_f_unique_limit(1,:),time_point/2+1);
    
     heart_bpm(time_point/2+1) = heart_rate_frequence(time_point/2+1)*60;
      plot(time_point, heart_bpm(time_point/2+1),'dk');
    
    ylim([0 200])
    drawnow;

OutputBPM=heart_rate_frequence(time_point/2+1)*60; otherOutputParameters=0;
end
function [Sorted_Maybe_frequence_unique]=get_Sorted_Maybe_frequence_unique_from_after_ssa_data(time_point,PPGtype)
global after_ssa_data;
Sorted_Maybe_frequence_unique_with_zero_expand=after_ssa_data(time_point/2*10+(PPGtype-1)*3+1:time_point/2*10+(PPGtype-1)*3+3,:);
icount=0;
for i=1:size(Sorted_Maybe_frequence_unique_with_zero_expand,2)
    if Sorted_Maybe_frequence_unique_with_zero_expand(3,i)==0%%%%%%
        break;
    end
    icount=icount+1;
end
Sorted_Maybe_frequence_unique=Sorted_Maybe_frequence_unique_with_zero_expand(:,1:icount);
end
function [xyz_f_unique]=get_xyz_f_unique_from_after_ssa_data(time_point)
global after_ssa_data;
    xyz_f_unique_with_zero_expand=after_ssa_data(time_point/2*10+7,:);
    icount=0;
    for i=1:size(xyz_f_unique_with_zero_expand,2)
        if xyz_f_unique_with_zero_expand(i)==0%%%%%%%%
            break;
        end
        icount=icount+1;
    end
    xyz_f_unique=xyz_f_unique_with_zero_expand(:,1:icount);
end
