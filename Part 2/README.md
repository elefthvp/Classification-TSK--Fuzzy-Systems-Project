# Main Idea
<p align=justify> Use a high-dimensional dataset for a more specific tackle of the Classification problem using neuro-fuzzy TSK models. The dataset is split in three parts for training, validation and final check of the employed neuro-fuzzy models. <br></p>
<p align=justify> The developed models use a varying number of rules.  The results of each model using the check subset are then evaluated using the criteria mentioned below. <br></p>
p align = justify> Although the main idea shares the same theoretical background with the first part of the project, there are additional aspects to be taken into consideration.<br></p>
A TSK model creation becomes more difficult as the number of inputs increases and an unwanted phenomenon known as "rule explosion" may appear. In order to prevent this from happening, we first define a partition for k-fold cross-validation on certain observations and then we tune both the number of the inputs and the number of the rules using the Relief algorithm and a grid search to decide the optimal features' selection<br></p>
<p align = justify> After the optimal parameters have been found, they are used to train the TSK model which is then evaluated with the metrics presented below.


# Dataset
The code uses the Isolet dataset which consists of 7797 samples and 618 features. It is available in the UCI Repository. 

# Evaluation Metrics 
- Error Matrix
- Overall Accuracy
- Producer's Accuracy - User's Accuracy
- K

These metrics have been implemented in the respective file `calcErrorMatrix` and `findPA_UA_k` found in the main folder and need to be included in the same repository as the `part1` file for it to execute.
