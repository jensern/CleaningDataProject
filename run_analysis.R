library(data.table)


####Proposed Tidy Data Set Structure
## Join columns according to the following sequence
## 1. SubjectID from <subj_list>
## 2. ActivityCode from <activity_code>
## 3. ActivityName from <activity_list> (using match function to generate list)
## 4. Features Data from <x> & Features Column Names from <feature_list>
## 5. Inertial Datas <inertial_tot_acc, inertial_bod_acc, inertial_gyro_rad> 
##      for the 1 window data set of 128 observations in time each.
##      by column names 
##      - tot.acc.1:tot.acc.128
##      - body.acc.1:body.acc.128
##      - gyro.rad.1:gyro.rad.128
## Total no of columns : 1 + 1 + 1 + 561 + 9*128 = 948
#####



#####Work with TRAIN data
x_test<-read.table("test/x_test.txt")

##Import Feature List
feature_list<-read.table("features.txt")

##Import SUBJECT data
subj_list<-read.table("test/subject_test.txt")

##Import Activity Code
activity_code<-read.table("test/y_test.txt")
##Import activity labels
activity_label<-read.table("activity_labels.txt",col.names=c("Code","Activity"))

##Generate Activity Name List for each observation
activity_match<-match(activity_code[[1]],activity_label$Code)
activity_list<-activity_label[activity_match,][["Activity"]]

##Import Inertial Datas
inertial_tot_acc_x<-read.table("test/Inertial Signals/total_acc_x_test.txt")
inertial_tot_acc_y<-read.table("test/Inertial Signals/total_acc_y_test.txt")
inertial_tot_acc_z<-read.table("test/Inertial Signals/total_acc_z_test.txt")

inertial_bod_acc_x<-read.table("test/Inertial Signals/body_acc_x_test.txt")
inertial_bod_acc_y<-read.table("test/Inertial Signals/body_acc_y_test.txt")
inertial_bod_acc_z<-read.table("test/Inertial Signals/body_acc_z_test.txt")

inertial_gyro_rad_x<-read.table("test/Inertial Signals/body_gyro_x_test.txt")
inertial_gyro_rad_y<-read.table("test/Inertial Signals/body_gyro_y_test.txt")
inertial_gyro_rad_z<-read.table("test/Inertial Signals/body_gyro_z_test.txt")


tidydata_test<-cbind(subj_list,
      activity_code,
      activity_list,
      x_test,
      inertial_tot_acc_x,
      inertial_tot_acc_y,
      inertial_tot_acc_z,
      inertial_bod_acc_x,
      inertial_bod_acc_y,
      inertial_bod_acc_z,
      inertial_gyro_rad_x,
      inertial_gyro_rad_y,
      inertial_gyro_rad_z,
      stringsAsFactors=FALSE
      )

######

#####Work with TRAIN data
x_test<-read.table("train/x_train.txt")

##Import Feature List
feature_list<-read.table("features.txt")

##Import SUBJECT data
subj_list<-read.table("train/subject_train.txt")

##Import Activity Code
activity_code<-read.table("train/y_train.txt")
##Import activity labels
activity_label<-read.table("activity_labels.txt",col.names=c("Code","Activity"))

##Generate Activity Name List for each observation
activity_match<-match(activity_code[[1]],activity_label$Code)
activity_list<-activity_label[activity_match,][["Activity"]]

##Import Inertial Datas
inertial_tot_acc_x<-read.table("train/Inertial Signals/total_acc_x_train.txt")
inertial_tot_acc_y<-read.table("train/Inertial Signals/total_acc_y_train.txt")
inertial_tot_acc_z<-read.table("train/Inertial Signals/total_acc_z_train.txt")

inertial_bod_acc_x<-read.table("train/Inertial Signals/body_acc_x_train.txt")
inertial_bod_acc_y<-read.table("train/Inertial Signals/body_acc_y_train.txt")
inertial_bod_acc_z<-read.table("train/Inertial Signals/body_acc_z_train.txt")

inertial_gyro_rad_x<-read.table("train/Inertial Signals/body_gyro_x_train.txt")
inertial_gyro_rad_y<-read.table("train/Inertial Signals/body_gyro_y_train.txt")
inertial_gyro_rad_z<-read.table("train/Inertial Signals/body_gyro_z_train.txt")


tidydata_train<-cbind(subj_list,
                activity_code,
                activity_list,
                x_test,
                inertial_tot_acc_x,
                inertial_tot_acc_y,
                inertial_tot_acc_z,
                inertial_bod_acc_x,
                inertial_bod_acc_y,
                inertial_bod_acc_z,
                inertial_gyro_rad_x,
                inertial_gyro_rad_y,
                inertial_gyro_rad_z,
                stringsAsFactors=FALSE
)

####

##Join tidy data for test and train dataset
tidydata_full<-rbind(tidydata_test,tidydata_train)

####Generate column name list for tidy data
##column names for features
feature_names<-as.character(feature_list[[2]])
##inertial data column names - readings in time 128 data points
inertial_names<-c(paste("tot.acc.x.",1:128,sep=""),
                  paste("tot.acc.y.",1:128,sep=""),
                  paste("tot.acc.z.",1:128,sep=""),
                  paste("body.acc.x.",1:128,sep=""),
                  paste("body.acc.y.",1:128,sep=""),
                  paste("body.acc.z.",1:128,sep=""),
                  paste("gyro.rad.x.",1:128,sep=""),
                  paste("gyro.rad.y.",1:128,sep=""),
                  paste("gyro.rad.z.",1:128,sep="")
                  )

##Combine all names into full column name list
col_names<-c("SubjectID","ActivityCode","ActivityName",feature_names,inertial_names)

##apply column names to tidy data
names(tidydata_full)<-col_names

####Search for features containing "mean" and "std"
mean_grep_list<-grep("mean",col_names)
mean_grep_name<-col_names[mean_grep_list]

std_grep_list<-grep("std",col_names)
std_grep_name<-col_names[std_grep_list]

activity_grep_list<-grep("Activity",col_names)
activity_grep_name<-col_names[activity_grep_list]

subject_grep_list<-grep("Subject",col_names)
subject_grep_name<-col_names[subject_grep_list]

##Take union of lists to obtain combined column selection
selected_features_list<-sort(Reduce(union,list(mean_grep_list,std_grep_list,activity_grep_list,subject_grep_list)),decreasing=FALSE)

##Extract relevant columns from tidy dataset
tidydata_select<-tidydata_full[,selected_features_list]

##Generate new tidy data set looking at average measurement split by activity, for each person
tidy_activity<-split(tidydata_select,tidydata_select$ActivityName)

##Generate subjectID names to data frame (1:30)
name_list<-as.numeric(seq(1:length(tidy_activity_person)))

ActivityMeanExtractor<-function(i){
        ##Apply variable means by subject for each activity
        tidy_activity_person<-by(tidy_activity[[i]][,4:length(selected_features_list)],tidy_activity[[i]]$SubjectID,FUN=colMeans)
        
        ##Generate subjectID names to data frame (1:30)
        name_list<-as.numeric(seq(1:length(tidy_activity_person)))
        
        ##Generate activity names according to split order
        activity_split_list<-names(tidy_activity)
        
        ##Use lapply to access by subjectID and compile into data frame
        tidy_activity_person_df<-data.frame(do.call(rbind,lapply(as.numeric(names(tidy_activity_person)),function(x){as.vector(tidy_activity_person[[x]])})))
        
        ##Generate List for Activity Name
        tidy_ActivityName<-activity_split_list[i]
        
        ##Generate List for SubjectID
        tidy_SubjectID<-name_list
        
        ##Join columns for Activity, SubjectID, followed by Average Values for Mean/Std
        tidy_activity_person_df2<-cbind(ActivityName=tidy_ActivityName,SubjectID=tidy_SubjectID,tidy_activity_person_df)
        
        return(tidy_activity_person_df2)
       
}

##<rbind> activity selection across all activities into a single large data frame
tidydata_avg_mean_std<-do.call(rbind,lapply(1:length(activity_label[[2]]),function(x){ActivityMeanExtractor(x)}))
##assign respective variable names to each columns
names(tidydata_avg_mean_std)<-c("ActivityName","SubjectID",names(tidydata_select)[4:length(selected_features_list)])


###write.table(tidydata_avg_mean_std,"tidydata_avg_mean_std.txt",row.names=FALSE)