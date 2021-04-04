import csv
path = r"C:\Users\samar\Desktop\Semester 6\ECE350Labs\ECE350_Final_Project\assets\assetsCSV\\";
def CSVtoMem(imageName):
    with open(path + imageName + "colors.csv", "r") as csvFile:
        with open(path + "colors.mem", "w") as memFile:
                for row in csv.reader(csvFile):
                    memFile.write(" ".join(row) + "\n")

    with open(path + imageName+ "image.csv", "r") as csvFile:
        with open(path + "image.mem", "w") as memFile:
            for row in csv.reader(csvFile):
                memFile.write(" ".join(row) + "\n")
