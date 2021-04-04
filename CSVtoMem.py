import csv
path = r"C:\Users\reyam\Desktop\ECE350Project\ECE350_Final_Project\assets\assetsCSV\\"
savePath = r"""C:\Users\reyam\Desktop\ECE350Project\ECE350_Final_Project\assets\assetsMemFiles\\"""
def CSVtoMem(imageName):
    with open(path + imageName + "colors.csv", "r") as csvFile:
        with open(savePath +r"\\"+ imageName+ "colors.mem", "w") as memFile:
                for row in csv.reader(csvFile):
                    memFile.write(" ".join(row) + "\n")

    with open(path + imageName+ "image.csv", "r") as csvFile:
        with open(savePath + imageName + "image.mem", "w") as memFile:
            for row in csv.reader(csvFile):
                memFile.write(" ".join(row) + "\n")
