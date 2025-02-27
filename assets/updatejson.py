import json

def transform_pdf_library(input_file, output_file):
    with open(input_file, 'r') as infile:
        data = json.load(infile)

    transformed_data = {"categories": {}}

    for category in data["categories"]:
        category_name = category["name"]
        transformed_data["categories"][category_name] = {"subcategories": {}}

        for subcategory in category["subcategories"]:
            subcategory_name = subcategory["name"]
            transformed_data["categories"][category_name]["subcategories"][subcategory_name] = []

            for pdf in subcategory["pdfs"]:
                transformed_pdf = {
                    "filePath": pdf["filePath"],
                    "pdfName": pdf["pdfName"],
                    "version": "2024-05-01",  # Default version as per example
                    "fileDriveID": None       # Default fileDriveID as per example
                }
                transformed_data["categories"][category_name]["subcategories"][subcategory_name].append(transformed_pdf)

    with open(output_file, 'w') as outfile:
        json.dump(transformed_data, outfile, indent=4)

# Input and output file names
input_file = "pdf_library.json"
output_file = "pdf_library_baseline.json"

# Run the transformation
transform_pdf_library(input_file, output_file)