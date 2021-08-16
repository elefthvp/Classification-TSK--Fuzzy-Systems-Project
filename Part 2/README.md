# Main Idea
<p align=justify> Use a simple dataset for a first approximation on whether the TSK models are able to solve the Classification problem efficiently. The dataset is split in three parts for training, validation and final check of the employed neuro-fuzzy models. <br></p>
<p align=justify> The developed models use a varying number of rules.  The results of each model using the check subset are then evaluated using the criteria mentioned below. <br></p>


# Dataset
The code uses the Avila dataset which consists of 20876 samples and 10 features. It is available in the UCI Repository. 

# Evaluation Metrics 
- Error Matrix
- Overall Accuracy
- Producer's Accuracy - User's Accuracy
- K

These metrics have been implemented in the respective file `calcErrorMatrix` and `findPA_UA_k` found in the main folder and need to be included in the same repository as the `part1` file for it to execute.
