import csv
from collections import defaultdict

def order_csv_class_incremental(input_file, output_file):
    # Specified order of classes
    class_order = [
        "True",
        "False"
    ]

    # Read the CSV file
    with open(input_file, 'r', newline='', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        rows = list(reader)

    # Group rows by llm_hard label
    grouped_rows = defaultdict(list)
    for row in rows:
        grouped_rows[row['llm_hard']].append(row)

    # Check if any of the specified classes are present in the data
    present_classes = [label for label in class_order if label in grouped_rows]
    
    if not present_classes:
        print("Error: None of the specified classes are present in the input data.")
        print("Classes found in the data:", list(grouped_rows.keys()))
        return

    # Order rows based on the specified class order
    ordered_rows = []
    for label in class_order:
        if label in grouped_rows:
            ordered_rows.extend(grouped_rows[label])

    # Write the ordered rows to a new CSV file
    with open(output_file, 'w', newline='', encoding='utf-8') as f:
        fieldnames = ['gold_hard', 'input', 'llm_soft', 'llm_hard']
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        
        writer.writeheader()
        for row in ordered_rows:
            writer.writerow(row)

    print(f"Ordered CSV saved to {output_file}")
    print("Classes present in the ordered data:", present_classes)
    print("Number of examples per class:")
    for label in present_classes:
        print(f"  {label}: {len(grouped_rows[label])}")

# Example usage
input_file = 'fever/train_soft.csv'
output_file = 'fever/train_soft_label_asc.csv'
order_csv_class_incremental(input_file, output_file)