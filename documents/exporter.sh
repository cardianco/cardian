#!/bin/bash
# Destnation.
output="./diagrams"
# Exporting from Draw to PDF.
command -v drawio || (echo "Error: drawio not found." && exit 1)
drawio -x -f pdf -o "$output/diagrams.pdf" "diagrams.drawio"
# If no output path exists, one will be created.
mkdir -p "$output"
cd "$output"
# Split the primary PDF into multiple PDF files.
pdftk diagrams.pdf burst output d%02d.pdf compress || exit 2
# Delete the main and log files.
rm diagrams.pdf
rm doc_data.txt
# Naming table for diagrams.
mv d01.pdf "usecase-diagram.pdf"
mv d02.pdf "activity-diagram.pdf"
mv d03.pdf "bpmn-diagram-1.pdf"
mv d04.pdf "bpmn-diagram-2.pdf"
mv d05.pdf "bpmn-diagram-3.pdf"
mv d06.pdf "bpmn-diagram-4.pdf"
mv d07.pdf "database.pdf"